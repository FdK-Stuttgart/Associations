(ns fdk.geo
  "Mapping of Address to Latitude and Longitude. umap-json file creation."
  (:require
   [cheshire.core :as cheshire]
   [clj-http.client :as client]
   [clj-time-ext.core :as te]
   [clojure.data.json :as json]
   [clojure.string :as cstr]
   [utils.core :as utc]
   [utils.num :as utn]
   [fdk.datasrc.ods :as ods]
   #_[clojure.inspector :refer :all]
   [ring.util.codec :as codec]
   [taoensso.timbre :as timbre :refer [debugf infof errorf]]
   [clojure.core :as cc]
   [fdk.common :as com]
   [clojure.set :as cset]
   )
  (:gen-class))

;; TODO icons https://nsa40.casimages.com/img/2020/11/09/mini_201109035055268763.png
;; https://www.flaticon.com/authors/freepik
;; https://www.flaticon.com/

(defn create-url
  "Returns the address-to-latlon mapping service url. E.g.:
  (fdk.geo/create-url {:address \"adr\" :format :umap})
  (fdk.geo/create-url {:address \"adr\" :format :geojson})"
  [{:keys [address format]}]
  (clojure.core/format
   "https://nominatim.openstreetmap.org/search?q=%s&format=%s" address (name format)))

(def request-delay
  "We have only 2 requests - no delay needed"
  0
  #_200)

(defn request [url]
  (debugf "[request] %s" url)
  (let [r (as-> url $
            (client/get $ {:accept :json})
            (:body $)
            (json/read-json $))]
    (Thread/sleep request-delay)
    r))

(defn layer [color layer-name features]
  ;; (println "layer-name" layer-name)
  ;; (println "features" features)
  ;; (println "color" color)
  {:type "FeatureCollection"
   :features features
   :_umap_options
   {:displayOnLoad true
    :browsable true
    :name layer-name
    :type "Cluster"
    ;; :cluster: {}
    ;; :heat: {}
    :color color
    :id (rand-int 1e7)}})

(defn fst-letters [hm]
  (-> hm :properties :name (subs 0 1) (cstr/upper-case)))

(defn assign-category-indexes [max-cat-size features]
  (loop
      [coll features
       cat {:cnt-in-cat 0 :idx 0}
       acc []]
    (if (empty? coll)
      acc
      (let [[e & es] coll
            new-cat (let [{cnt-in-cat :cnt-in-cat idx :idx} cat]
                      (cond
                        (< cnt-in-cat (dec max-cat-size)) ;; this category
                        {:cnt-in-cat (inc cnt-in-cat) :idx idx}

                        :else ;; new category
                        {:cnt-in-cat 0 :idx (inc idx)}))]
        (recur es
               new-cat
               (into acc [(assoc e :cat-idx (:idx cat))]))))))

(defn two-letters [hm]
  (-> hm :properties :name (subs 0 2) #_(cstr/upper-case)))

(defn classified
  "(fdk.geo/classified (features))"
  [features]
  (let [default-cnt-categories 1
        default-cat-name "Vereine"]
    (let [cnt-categories default-cnt-categories
          max-cat-size (int (/ (count features) cnt-categories))
          coll (->> features
                    (sort-by (fn [m]
                               ;; need to sort it lower cased:
                               ;; (sort ["AM" "Ab" "Aa"]) => ("AM" "Aa" "Ab")
                               (clojure.string/lower-case
                                (get-in m [:properties :name]))))
                    (assign-category-indexes max-cat-size)
                    (group-by :cat-idx)
                    (sort))]
      (->> coll
           (map (fn [[cat-idx members]]
                  [
                   (conj
                    {:members members}
                    {:cnt-members (count members)}
                    {:cat-idx cat-idx
                     :cat-name (cstr/join "-"
                                       (map (fn [member]
                                              (two-letters member))
                                            [(first members) (last members)]))})]))
           (flatten)
           (map (fn [{:keys [members]}]
                  (map (fn [m] (assoc m :cat-name default-cat-name))
                       members)))
           (reduce into [])
           (map (fn [m]
                  (conj
                   {:name (get-in m [:properties :name])}
                   (select-keys m [:cat-name]))))))))

(defn create-groups [features]
  (let [classification (classified features)]
    (->> features
         (map (fn [m]
                (let [f-name (get-in m [:properties :name])]
                  (conj m
                        {:cat-desc (->> classification
                                        (filter (fn [c] (= f-name (get-in c [:name]))))
                                        (first)
                                        :cat-name)}))))
         (group-by :cat-desc)
         (sort)
         (reverse))))

(defn no-public-address?
  "TODO implement no-public-address? as a regex match a la:
  return !!normAddr.match(/.*keine|Postfach.*/i)"
  [norm-addr]
  (or (.contains norm-addr "keine")
      (.contains norm-addr "Postfach")))

(defn search-properties
  "(fdk.geo/search-properties {} {:addr \"a\" :desc \"d\" ...})"
  [no-addr-color
   {:keys [addr city-district desc goal activity] :as prm}]
  (conj {} #_{:_umap_options
              {:showLabel true
               :labelInteractive true
               #_#_:iconUrl "/uploads/pictogram/theatre-24-white.png"
               #_#_:iconClass "Default"}}
        (when-not (empty? prm)
          (conj
           {:search_address addr
            :search_district city-district
            :search_desc desc
            :search_goal goal
            :search_activity activity}
           (when (no-public-address? addr)
             {:_umap_options {:color no-addr-color
                              #_"DeepSkyBlue"}})))))

(defn umap
  "
  Test-direkt:    https://umap.openstreetmap.fr/de/map/stadtteilkarte_testversion_459974
  Test-short-url: http://u.osmfr.org/m/459974/

  Prod-direkt:    https://umap.openstreetmap.fr/de/map/stadtteilkarte_459647
  Prod-short-url: http://u.osmfr.org/m/459647/
  "
  [main-color features]
  ;; (def features features)
  {:type "umap"
   ;; test-short-url
   :uri "http://u.osmfr.org/m/459974/"
   :properties
   {
    :captionBar true
    :datalayersControl "collapsed"
    :description "Forum der Kulturen\nhttps://www.forum-der-kulturen.de/"
    :displayPopupFooter true
    :easing true
    :editinosmControl nil
    :embedControl true
    :fullscreenControl true
    :labelInteractive true
    :licence ""
    :limitBounds
    #_{:south 48.667385 :west 9.003639 :north 48.892487 :east 9.662819}
    {:south 48.418264 :west 8.209534 :nord 49.317066 :east 10.846252}
    ;; there must be no space-char after ","!!!
    :filterKey (cstr/join "," (map name (into [:name] (keys (search-properties nil {})))))
    :locateControl true
    :measureControl nil
    :miniMap false
    :moreControl false
    :name "Stadtteilkarte_Testversion"
    :onLoadPanel "databrowser"
    :popupShape "Default"
    :popupTemplate "Default"
    :scaleControl true
    :scrollWheelZoom true
    :searchControl true
    :showLabel nil
    :slideshow {}
    :tilelayer {:tms false}
    :tilelayersControl nil
    :zoomControl true
    :zoom 14 ;; default zoom level
    }
   :geometry {:type "Point" :coordinates [9.148864  48.760262]}
   :layers
   ((comp
     (partial mapv (fn [[cat-name cat-members]] (layer main-color cat-name cat-members)))
     create-groups
     (partial mapv (fn [feature]
                     ;; (def feature feature)
                     (debugf "%s; %s - %s: %s"
                             (get-in feature [:properties :name])
                             (get-in feature [:properties :search_address])
                             (get-in feature [:properties :search_district])
                             (cstr/join " "
                                        (map (fn [v]
                                               ;; (def v v)
                                               (utn/round-precision v 6))
                                             (get-in feature [:geometry :coordinates]))))
                     feature)))
    features)})

(defn f-type [feature] (get-in feature [:properties :geocoding :type]))
(defn f-place-id [feature] (get-in feature [:properties :geocoding :place_id]))
(defn f-osm-type [feature] (get-in feature [:properties :geocoding :osm_type]))
(defn f-category [feature] (get-in feature [:properties :category]))

(def desired-feature-types [#_"public_building" "administrative" "studio"])

(defn relevant-feature?
  "Created add-hoc. Hmm
  (relevant-feature? all-features feature)
  "
  [all-features feature]
  (def all-features all-features)
  (def feature feature)
  (let [count-features (count all-features)]
    (cond
      (> count-features 1)
      (or
       (let [category (f-category feature)
             osm_type (f-osm-type feature)]
         ;; (def category category)
         ;; (def osm_type osm_type)
         (or
          (utc/in? ["building"] category)
          (and (utc/in? ["amenity"] category)
               (utc/in? ["node"] osm_type))))
       (let [ftype (f-type feature)
             osm_type (f-osm-type feature)]
         ;; (def ftype ftype)
         ;; (def osm_type osm_type)
         (or
          (and (utc/in? ["way"] osm_type)
               (utc/in? ["yes" "hostel" "community_centre" "social_facility"
                         "bar" "public_building" "theatre"] ftype))
          (and (utc/in? ["relation"] osm_type)
               (utc/in? ["public" "concert_hall"] ftype))
          (and (utc/in? ["node"] osm_type)
               (utc/in? ["library" "school" "community_centre" "cafe"
                         "theatre" "restaurant" #_"parking"] ftype))))
       (let [all-desired-features
             (filter (comp (partial utc/in? desired-feature-types)
                           f-type)
                     all-features)]
         (and
          (utc/in? desired-feature-types (f-type feature))
          (= (f-place-id feature)
             (f-place-id (if (= 1 (count all-desired-features))
                           (first all-desired-features)
                           (second all-desired-features))))))

       (let [ftype (f-type feature)]
         (utc/in? ["square"] ftype)))

      (= count-features 1)
      true

      :else
      (errorf "No matching condition for feature: %s" feature))))

(defn normalize-address [address]
  (let [adr (cstr/replace address "\n" ", ")]
    (if-let [old-house-nr (re-find #"[0-9] [A-z]," adr)]
      (.replaceFirst adr old-house-nr (.replaceAll old-house-nr " " ""))
      adr)))

(def facebook-logo
  "2 kB"
  "https://cdn.iconscout.com/icon/free/png-256/facebook-108-432507.png")
(def instagram-logo
  "15 kB"
  "https://cdn.iconscout.com/icon/free/png-256/instagram-188-498425.png")
(def youtube-logo
  "3.3 kB"
  "https://cdn.iconscout.com/icon/free/png-256/youtube-82-189778.png")

(defn format-link [line prefix]
  (format "[[%s|%s%s]]"
          line
          (if (or (.endsWith line "mig.madeingermany-stuttgart.de")
                  (.startsWith line (str prefix "www.")))
            ""
            "www.")
          (let [fmt-line (if (.endsWith line "/")
                           (.substring line 0 (dec (count line)))
                           line)]
            (.replaceFirst fmt-line prefix ""))))

(defn encode-line [line]
  (let [img-size 14]
    (cond
      (.startsWith line "https://www.facebook.com/")
      (format (str "{{" facebook-logo "|" img-size "}}"
                   " [[%s|Facebook]]")
              line)

      (.startsWith line "https://de-de.facebook.com/")
      (format (str "{{" facebook-logo "|" img-size "}}"
                   " [[%s|Facebook]]")
              line)

      (.startsWith line "https://www.instagram.com/")
      (format (str "{{" instagram-logo "|" img-size "}}"
                   " [[%s|Instagram]]")
              line)

      (.startsWith line "https://www.youtube.com/")
      (format (str "{{" youtube-logo "|" img-size "}}"
                   " [[%s|YouTube]]")
              line)

      (.startsWith line "https://")
      (format-link line "https://")

      (.startsWith line "http://")
      (format-link line "http://")

      :else line)))

(defn query-param [{:keys [norm-addr city-district]}]
  (if (no-public-address? norm-addr)
    city-district
    norm-addr))

(defn process-table-row
  "(process-table-row no-addr-color request-format row)"
  [no-addr-color
   request-format
   {:keys [address city-district name desc goal activity coordinates
           logos] :as row}]
  ;; (def no-addr-color no-addr-color)
  ;; (def request-format request-format)
  ;; (def row row)
  (let [norm-addr (normalize-address address)
        all-features
        (if (empty? coordinates)
          (let [query-prms (query-param {:norm-addr norm-addr
                                         :city-district city-district})]

            (if (empty? query-prms)
              []
              (let [req (->> (codec/url-encode query-prms)
                             (assoc {:format request-format}
                                    :address)
                             (create-url)
                             (request))]
                ;; (def req req)
                (get-in req [:features]))))
          [{:type "Feature"
            :properties {:geocoding {:name ""}}
            :geometry {
                       :type "Point"
                       :coordinates
                       (read-string (format "[%s]" coordinates))}}])

        desc-markdown
        (cstr/join
         "\n"
         (map encode-line (cstr/split-lines desc)))]
    ;; (def all-features all-features)
    ;; (debugf "type %s; empty? %s; %s" (type coordinates) (empty? coordinates) coordinates)
    ((comp
      (partial
       mapv
       (fn [feature]
         (update-in
          feature
          [:properties]
          (fn [properties]
            ;; (def properties properties)
            (conj (assoc properties
                         :description
                         (reduce str
                                 (map (fn [[fmt s]]
                                        (when-not (empty? (cstr/trim s))
                                          (format fmt s)))
                                      (into
                                       (mapv (fn [logo] [
                                                         "{{%s}}\n"
                                                         #_"{{%s|269}}" logo]) logos)
                                       [
                                        ["%s\n\n" address]
                                        ["%s\n\n" desc-markdown]
                                        ["Aktiv in Stadtteil(en): %s\n\n" city-district]
                                        ["Ziele des Vereins: %s\n\n" goal]
                                        ["Aktivitätsbereiche: %s" activity]])))
                         :name name)
                  (search-properties no-addr-color
                                     {:addr norm-addr
                                      :desc desc ;; not desc-markdown
                                      :city-district city-district
                                      :goal goal
                                      :activity activity}))))))
      #_
      (partial
       mapv
       (fn [feature]
         (debugf "norm-addr %s; line %s; coords %s" norm-addr (:idx row)
                 (cstr/join " "
                            (map (fn [v] (utn/round-precision v 6))
                                 (get-in feature [:geometry :coordinates]))))
         feature))
      (partial filter (partial relevant-feature? all-features)))
     all-features)))

(defn calc-geo-data
  [no-addr-color {:keys [ods-table format] :or {format #_:geojson :umap}}]
  (let [request-format (if (= format :umap) :geocodejson format)]
    (->> ods-table
         (map (fn [table-row] (process-table-row no-addr-color request-format table-row)))
         (reduce into [])
         ((fn [coll]
            #_(infof "Coordinates found %s" (count coll))
            coll)))))

#_(defn resolved-addresses
  [json]
  (->> json
       :layers
       (map (fn [layer]
              (->> (get-in layer [:features])
                   (map (fn [feature]
                          (get-in feature [:properties :display_name]))))))
       (flatten)
       (set)))

#_(defn unresolved-addresses
  [json]
  (let [resolved (resolved-addresses json)]
    (->> (ods/addresses)
         (remove (fn [{:keys [address idx]}]
                   (empty? address)))
         (map (fn [{:keys [address idx] :as m}]
                (update-in m [:address] normalize-address)))
         (remove (fn [{:keys [idx address]}]
                   (utc/in? resolved address)))
         (map (fn [m] (cset/rename-keys m {:idx :row}))))))

(defn json
  "(fdk.geo/json :umap)"
  [{:keys [colors]} fname]
  (let [geo-data (calc-geo-data
                  (:no-addr colors)
                  {:ods-table (ods/read-table fname)})]
    ;; (def geo-data geo-data)
    (umap (:main colors) geo-data)))

(defn save-json
  "During evaluation it defines the `json` var for debugging purposes. E.g.:
  (fdk.geo/save-json (fdk.geo/json :umap) \"resources/out.umap\")
  "
  [json filename]
  (spit filename
        (cheshire/generate-string json {:pretty true})))

#_"(fdk.geo/-main
    \"resources/Vereinsinformationen_öffentlich_Stadtteilkarte.ods\"
    \"out.umap\"
    \"{:colors {:main \\\"#d13858\\\" :no-addr \\\"DeepSkyBlue\\\"}}\")"

(defn -main
  "(fdk.geo/-main
    \"/home/bost/Downloads/Raumliste.ods\"
    \"out.umap\"
    \"{:colors {:main \\\"#d13858\\\" :no-addr \\\"DeepSkyBlue\\\"}}\")"
  [& [input-file output-file prm-colors]]
  (let [colors (if prm-colors
                 (read-string prm-colors)
                 ;; FdK color spectrum - see email from Joe
                 ;; "Blue"
                 ;; "Red"
                 ;; "Gold"
                 ;; "LightSkyBlue"
                 ;; "DarkSlateBlue"
                 ;; "Chocolate"
                 ;; "Black"
                 ;; "MediumSlateBlue"
                 ;; "CadetBlue"
                 {:colors {:main "#d13858"
                           :no-addr "DeepSkyBlue"}})]
    (println "colors" colors)
    (println "input-file" input-file)
    (println "output-file" output-file)
    (save-json (json colors input-file) output-file)))
