(ns fdk.download
  (:require [clj-http.client :as client]
            [clojure.string :as s]
            [utils.core :refer :all]
            [fdk.data :as data]
            [fdk.datasrc.ods :as ods]
            [fdk.process :refer [in-bw?]]
            [hickory.core :as hick]
            [clojure.java.io :as io]
            [hickory.select :as hs]
            [clj-fuzzy.metrics :as fuzzy]
            [fdk.cities :refer :all]
            [ring.util.codec :as codec]))

(def download-urls
  {
   :google-com  "https://www.google.com/search?q="

   ;; map search works only in a browser with enabled javascript
   :google-maps "https://maps.google.com/maps?q="

   ;; search for association name (w/o e. V.) - if found try to:
   ;; 1. get the address from nearby text below
   ;; "https://www.stuttgart.de/adressen?text="
   ;;     <div class="item clearfix">
   ;;     <span>Einrichtungen</span>
   ;;     <p>Streetname HouseNr<br>
   ;;     PLZ City</p>
   ;;     </div>
   ;; alternative
   ;; 2. or try to follow the link if it is a link
   :stuttgart   "https://www.stuttgart.de/adressen?text="
   :bing        nil
   :yahoo       nil
   :duckduckgo  nil})

(defn normalize-ev-ending [s]
  (as-> s $
    (s/replace $ " e. V." " e.V.")
    (s/replace $ "e. V." "e.V.")
    ;; (s/replace $ " e. V." "e.V.")
    (s/replace $ " eV" " e.V.")))

(defn download
  "E.g.:
  (download \"<association-name>\" :url :google-com :search-operator :map :sleep 0)
  (download \"<association-name>\" :url :stuttgart :sleep 0)
  (download \"<association-name>\" :sleep 0)
  https://www.google.com/maps/search/?api=1&query=Afrokids+e.+V.

  See
  https://ahrefs.com/blog/google-advanced-search-operators/
  "
  [association assoc-fname & search-options]
  (let [{:keys [url addition addition-position search-operator map-search sleep]
         :or {url :google-com
              addition ""
              addition-position :append ;; :prepend
              search-operator nil
              map-search false
              ;; once per 15..25 seconds
              sleep (+ (* 1000 35) (int (* 1000 (rand 10))))}} search-options]
    (let [addition
          #_"Karte"
          #_"Baden Württemberg"
          "Adresse"

          base (str (if-let [sop (and (= url :google-com)
                                      search-operator
                                      (name search-operator))]
                      (str sop ":"))
                    association)
          search-vec (if (= addition-position :prepend)
                       [base addition]
                       [addition base])
          r (as-> search-vec $
              (s/join " " $)
              (normalize-ev-ending $)
              (s/replace $ " " "+")
              (codec/url-encode $)
              (str (url download-urls) $)
              (client/get
               (do
                 (println $)
                 $)
               ;; :auto - automatic charset detection
               {:as :auto})
              ;; response body
              (:body $))]
      (spit assoc-fname r)
      (Thread/sleep sleep)
      r)))

(defn get-html
  "Get html code from a directory or download it from an URL"
  [association]
  (if (empty? association)
    ""
    (let [dir-name "associations"
          assoc-fname
          (format "resources/%s/%s.html"
                  dir-name
                  ;; escape / replace slash \/ and newline \n chars with spaces
                  (s/escape association
                            {(first (char-array "/")) " "
                             (first (char-array "\n")) " "}))]
      (if (.exists (io/file assoc-fname))
        (slurp assoc-fname)
        (download association assoc-fname)))))

(def coefficient
  "(< n coefficient) means the inspected value is (probably) not an association"
  0.6)

(defn classify
  "Classify content of a given hickory node. `association` is used to exclude
  false identification."
  [{:keys [content association]}]
  (let [recognition-result
        (->> content
             (remove (fn [c]
                       (or (s/starts-with? c "Geschlossen")
                           (s/starts-with? c "Geöffnet"))))
             (map (fn [c]
                    (let [association (not (< (fuzzy/jaro-winkler association c)
                                              coefficient))
                          phone (->> (re-find #"^\+{0,1}([0-9]| )+$" c)
                                     first
                                     boolean)]
                      {:c c :phone phone :association association}))))]
    #_recognition-result
    (->> recognition-result
         (map (fn [{:keys [c phone association]}]
                (cond
                  (and phone) {:phone c}
                  (and (not association)
                       (not phone)
                       (in-bw? c)) {:address c})))
         (reduce into {})
         (conj {:association association}))))

(defn extract
  "E.g.
  (->> \"<association-name>\"
       (download)
       (extract))
  ;; => {:address \"...\" :phone \"...\"}"
  [{:keys [html association] :as prm}]
  (->> html
       (hick/parse)
       (hick/as-hickory)
       (hs/select
        (hs/child
         (hs/or
          (hs/and
           (hs/tag :div)
           (hs/class :BNeawe)
           (hs/class :iBp4i)
           (hs/class :AP7Wnd))
          (hs/and
           (hs/tag :span)
           (hs/class :BNeawe)
           (hs/class :tAd8D)
           (hs/class :AP7Wnd)))))
       (mapv (comp first :content))
       (remove map?)
       (assoc {:association association}
              :content)
       (classify)))

(defn duplicates
  "Find duplicate entries in a sequence"
  [seq]
  (for [[id freq] (frequencies seq)  ;; get the frequencies, destructure
        :when (> freq 1)]            ;; this is the filter condition
    id))                             ;; just need the id, not the frequency

(defn result []
  #_(defn aux-subvec "Auxiliary fn" [start end v] (subvec (vec v) start end))
  (let [idx 10]
    (->> ods/associations
         #_(aux-subvec idx (inc idx))
         #_(take 5)
         #_(drop (dec idx))
         (map (fn [a]
                (extract
                 {:association a :html (get-html a)})))
         (map (fn [m]
                (if (contains? m :address)
                  (update-in m [:address]
                             (fn [address] (normalize-ev-ending address)))
                  m))))))

#_(def gg (map second-search ods/associations data/results))

;; https://odftoolkit.org/api/simple/org/odftoolkit/simple/table/Cell.html
