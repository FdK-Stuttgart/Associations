(ns fdk.geo
  "Mapping of Address to Latitude and Longitude. Creation of a geojson file."
  (:require [cheshire.core :as cheshire]
            [clj-http.client :as client]
            [clj-time-ext.core :as te]
            [clojure.data.json :as json]
            [clojure.string :as s]
            [utils.core :refer [in?]]
            [fdk.data :as data]
            [fdk.datasrc.ods :as ods]
            [clojure.inspector :refer :all]
            [ring.util.codec :as codec]))

(defn url
  "Returns the address-to-latlon mapping service url.
  E.g.
  (url {:address \"adr\" :format :umap})
  (url {:address \"adr\" :format :geojson})"
  [{:keys [address format]}]
  (clojure.core/format
   "https://nominatim.openstreetmap.org/search?q=%s&format=%s" address (name format)))

(defn get-json [url]
  ;; TODO use monad for logging
  (let [tbeg (te/tnow)]
    #_(println (str "[" tbeg "             /" "get-json " url "]"))
    (let [r (as-> url $
              (client/get $ {:accept :json})
              (:body $)
              (json/read-json $))]
      (Thread/sleep 200)
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

(defn umap
  "
  Test-direkt:    https://umap.openstreetmap.fr/de/map/stadtteilkarte_testversion_459974
  Test-short-url: http://u.osmfr.org/m/459974/

  Prod-direkt:    https://umap.openstreetmap.fr/de/map/stadtteilkarte_459647
  Prod-short-url: http://u.osmfr.org/m/459647/
  "
  [features]
  {:type "umap"
   ;; test-short-url
   :uri "http://u.osmfr.org/m/459974/"
   :properties
   {
    :captionBar false
    :datalayersControl nil
    :description "Forum der Kulturen Testversion!!"
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
    :searchControl nil
    :showLabel nil
    :slideshow {}
    :tilelayer {:tms false}
    :tilelayersControl nil
    :zoomControl true
    }
   :geometry {:type "Point" :coordinates [9.148864746093752 48.760262727297]}
   :layers
   [{:type "FeatureCollection"
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     :features features
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     :_umap_options
     {:displayOnLoad true :browsable true :name "Ebene 1" :id 1165787}}]})

(defn feature-collection
  "E.g.
  (feature-collection {:format :umap :features [1 2 3]})"
  [format features]
  (let [json-fn (case format
                  :umap    umap
                  :geojson geojson)]
    (json-fn features)))

(defn relevant-response?
  "Created add-hoc. Hmm"
  [count-features srvc-response]
  (cond
    (> count-features 1)
    (or
     (let [category (get-in srvc-response [:properties :category])
           osm_type (get-in srvc-response [:properties :osm_type])]
       (or
        (in? ["building"] category)
        (and (in? ["amenity"] category)
             (in? ["node"] osm_type))))

     (let [type (get-in srvc-response [:properties :geocoding :type])
           osm_type (get-in srvc-response [:properties :geocoding :osm_type])]
       (or
        (and (in? ["way"] osm_type)
             (in? ["yes"] type))
        (and (in? ["node"] osm_type)
             (in? ["library" "parking"] type)))))

    (= count-features 1)
    true

    :else
    (println "ERROR" "No matching condition for:\n" srvc-response)))

(defn update-features [srvc-response]
  (def srvc-response srvc-response)
  (update-in
   srvc-response
   [:json :features]
   (fn [features]
     (let [count-features (count features)]
       (->> features
            (filter (fn [srvc-response] (relevant-response? count-features srvc-response)))
            (mapv (fn [feature]
                    (def feature feature)
                    (update-in
                     feature
                     [:properties]
                     (fn [properties]
                       (def properties properties)
                       (conj (assoc properties

                                    :display_name
                                    (s/replace (:address srvc-response) "\n" ", ")

                                    :description
                                    (:desc srvc-response)
                                    )
                             (->> [:name :desc]
                                  (select-keys srvc-response)
                                  (extra-properties))))))))))))

(defn geo-data
  "E.g.:
  (geo-data {:ms (ods/ms) :format :umap})
  (geo-data {:ms data/ms :format :umap})
  "
  [{:keys [ms format] :or {format
                           #_:geojson
                           :umap}}]
  (let [request-format (if (= format :umap)
                         :geocodejson
                         format)]
    (->>
     ms
     (map (fn [{:keys [address] :as m}]
            (assoc m :url (url {:address (-> (s/replace address "\n" ", ")
                                             (codec/url-encode))
                                :format request-format}))))
     (map (fn [{:keys [url] :as m}]
            (assoc m :json (get-json url))))
     ;; #_(doall)
     (map (fn [{:keys [address] :as m}]
            (assoc m :url (url {:address (-> (s/replace address "\n" ", ")
                                             (codec/url-encode))
                                :format request-format}))))
     (map update-features)
     (map (fn [m] (get-in m [:json :features])))
     (reduce into [])
     ((fn [coll]
        (println "Coordinates found" (count coll))
        coll))
     ;; The right param of `feature-collection` is `format` not the
     ;; `request-format`
     (feature-collection format))))

(defn save-json
  "E.g.:
  (save-json (geo-data {:ms (ods/ms) :format :umap}) \"resources/<filename>.umap\")
  (save-json (geo-data {:ms data/ms :format :umap}) \"resources/<filename>.umap\")
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
  (println "See (inspect-tree json)")
  )

#_(json/pprint (geo-data {:format :umap}))

