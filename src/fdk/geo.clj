(ns fdk.geo
  "Mapping of Address to Latitude and Longitude. umap-json file creation."
  (:require
   [cheshire.core :as cheshire]
   [clj-http.client :as client]
   [clj-time-ext.core :as te]
   [clojure.data.json :as json]
   [clojure.string :as s]
   [utils.core :refer [in? coll-and-not-empty? not-empty?]]
   [fdk.data :as data]
   [fdk.datasrc.ods :as ods]
   [clojure.inspector :refer :all]
   [ring.util.codec :as codec]
   [taoensso.timbre :as timbre :refer :all]
   [clojure.core :as cc]

   [clojure.set :as set]))

(defn create-url
  "Returns the address-to-latlon mapping service url.
  E.g.
  (create-url {:address \"adr\" :format :umap})
  (create-url {:address \"adr\" :format :geojson})"
  [{:keys [address format]}]
  (clojure.core/format
   "https://nominatim.openstreetmap.org/search?q=%s&format=%s" address (name format)))

(def request-delay 200)

(defn get-json [url]
  ;; TODO use monad for logging
  (def url url)
  (let [tbeg (te/tnow)]
    #_(println (str "[" tbeg "             /" "get-json " url "]"))
    (let [r (as-> url $
              (client/get $ {:accept :json})
              (:body $)
              (json/read-json $))]
      (Thread/sleep request-delay)
      #_(println (str "[" tbeg ":" (te/tnow) " /" "get-json " url "]"))
      r)))

(defn extra-properties
  " E.g:
  (extra-properties {:name \"n\" :desc \"d\"})
  "
  [{:keys [desc name]}]
  (conj
   {}
   #_{
    :_umap_options {
                    :showLabel true
                    :labelInteractive true
                    ;; :iconUrl "/uploads/pictogram/theatre-24-white.png"
                    ;; :iconClass "Default"
                    }}
   {
    :name name
    :description desc}))

(defn geojson [features]
  {:type "FeatureCollection" :features features})

(defn layer [idx layer-name features]
  {:type "FeatureCollection"
   :features features
   :_umap_options
   {:displayOnLoad true :browsable true :name layer-name
    :color (nth ["Blue"
                 "Red"
                 "Gold"
                 "LightSkyBlue"
                 "DarkSlateBlue"
                 "Chocolate"
                 "Black"
                 "MediumSlateBlue"
                 "CadetBlue"
                 ] idx)
    :id (rand-int 1e7)}}
  )

(defn umap
  "
  Test-direkt:    https://umap.openstreetmap.fr/de/map/stadtteilkarte_testversion_459974
  Test-short-url: http://u.osmfr.org/m/459974/

  Prod-direkt:    https://umap.openstreetmap.fr/de/map/stadtteilkarte_459647
  Prod-short-url: http://u.osmfr.org/m/459647/
  "
  [features]
  (def features features)
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
    :limitBounds {:east 12.041016 :west 6.767578 :north 49.94415 :south 47.997274}
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
    }
   :geometry {:type "Point" :coordinates [9.148864746093752 48.760262727297]}
   :layers
   (let [cats ods/categories ;; (take 3 ods/categories)
         feats features ;; (take 12 features)
         groups (partition-all (inc (quot (count features) (count cats)))
                               feats)]
     #_(println "(count cats)" (count cats) "(count groups)" (count groups) "(count feats)" (count feats))
     (->> groups
          (map-indexed (fn [idx group]
                         #_(println "idx" idx)
                         (layer idx (nth ods/categories idx) group)))
          (vec)
          #_(inspect-tree)))})

(defn feature-collection
  "E.g.
  (feature-collection :umap features)
  (feature-collection :umap [1 2 3])"
  [format features]
  (def features features)
  (let [json-fn (case format
                  :umap    umap
                  :geojson geojson)]
    (json-fn features)))

(defn relevant-feature?
  "Created add-hoc. Hmm"
  [count-features feature]
  (def count-features count-features)
  (def feature feature)
  (cond
    (> count-features 1)
    (or
     (let [category (get-in feature [:properties :category])
           osm_type (get-in feature [:properties :osm_type])]
       (or
        (in? ["building"] category)
        (and (in? ["amenity"] category)
             (in? ["node"] osm_type))))

     (let [type (get-in feature [:properties :geocoding :type])
           osm_type (get-in feature [:properties :geocoding :osm_type])]
       (or
        (and (in? ["way"] osm_type)
             (in? ["yes"] type))
        (and (in? ["node"] osm_type)
             (in? ["library" "parking"] type)))))

    (= count-features 1)
    true

    :else
    (error "No matching condition for:" feature)))

(defn normalize-address [address]
  (let [adr (s/replace address "\n" ", ")]
    (if-let [old-house-nr (re-find #"[0-9] [A-z]," adr)]
      (let [last-idx (.lastIndexOf adr old-house-nr)
            new-house-nr (.replaceAll old-house-nr " " "")]
        (.replaceFirst adr old-house-nr new-house-nr))
      adr)))

(defn geo-data
  "E.g.:
  (geo-data {:ms (ods/ms) :format :umap})
  (geo-data {:ms data/ms :format :umap})
  "
  [{:keys [ms format] :or {format #_:geojson :umap}}]
  (let [request-format (if (= format :umap) :geocodejson format)]
    (->>
     ms
     (map (fn [{:keys [address name desc] :as m}]
            (let [norm-addr (normalize-address address)]
              (let [all-features (->> norm-addr
                                      (codec/url-encode)
                                      (assoc {:format request-format}
                                             :address)
                                      (create-url)
                                      (get-json)
                                      :features)
                    cnt-all-features (count all-features)]
                (debug (cc/format "norm-addr: \"%s\"; cnt-all-features: %s"
                                  norm-addr cnt-all-features))
                (def all-features all-features)
                (->> all-features
                     (map-indexed (fn [i feature] [i feature]))
                     (filter (fn [[idx feature]]
                               (let [relevant (relevant-feature?
                                               cnt-all-features feature)]
                                 (debug
                                  (cc/format
                                   "norm-addr: \"%s\"; idx: %s; relevant: %s"
                                   norm-addr idx relevant))
                                 relevant)))
                     (mapv (fn [[_ feature]] feature))
                     (mapv (fn [feature]
                             (def feature feature)
                             (update-in
                              feature
                              [:properties]
                              (fn [properties]
                                (def properties properties)
                                (conj (assoc properties
                                             :display_name norm-addr
                                             :description desc
                                             :name name)
                                      #_(->> [:name :desc]
                                           (select-keys all-features)
                                           (extra-properties))))))))))))
     (reduce into [])
     ((fn [coll]
        (println "Coordinates found" (count coll))
        coll))
     ;; The right param of `feature-collection` is `format` not the
     ;; `request-format`
     (feature-collection format))))

(defn resolved-addresses
  "
  => (def json (geo-data {:ms (ods/ms) :format :umap}))
  => (resolved-addresses json)"
  [json]
  (->> json
       :layers
       (map (fn [layer]
              (->> (get-in layer [:features])
                   (map (fn [feature]
                          (get-in feature [:properties :display_name]))))))
       (flatten)
       (set)))

(defn unresolved-addresses [json]
  (let [resolved (resolved-addresses json)]
    (->> (ods/addresses)
         (remove (fn [{:keys [address idx]}]
                   (empty? address)))
         (map (fn [{:keys [address idx] :as m}]
                (update-in m [:address] normalize-address)))
         (remove (fn [{:keys [idx address]}]
                   (in? resolved address)))
         (map (fn [m] (clojure.set/rename-keys m {:idx :row}))))))

(defn save-json
  "During evaluation it defines the `json` var for debugging purposes. E.g.:

  (save-json (geo-data {:ms (ods/ms) :format :umap}) \"resources/<filename>.umap\")
  (save-json (geo-data {:ms data/ms :format :umap}) \"resources/<filename>.umap\")
  (save-json json \"resources/relevant.umap\")
  (save-json (geo-data {:ms (fdk.relevant/ms) :format :umap}) \"resources/relevant.umap\")

  (save-json (feature-collection :umap features) \"resources/relevant.umap\")

  (save-json (geo-data {:ms (->> (fdk.relevant/ms)
                                 (remove (fn [m] (in? associations-found (:name m)))))
                        :format :umap}) \"resources/relevant.umap\")
  "
  [json filename]
  (def json json)
  (spit filename
        (cheshire/generate-string
         json
         #_(geo-data {:ms ms :format :umap})
         {:pretty true})
        #_(json/write-str
           (geo-data {:format :umap})))
  (debug "See" "(inspect-tree json) (inspect-tree features)")
  )

#_(json/pprint (geo-data {:format :umap}))

