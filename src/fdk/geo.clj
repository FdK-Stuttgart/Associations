(ns fdk.geo
  "Mapping of Address to Latitude and Longitude. Creation of a geojson file."
  (:require [cheshire.core :as cheshire]
            [clj-http.client :as client]
            [clj-time-ext.core :as te]
            [clojure.data.json :as json]
            [clojure.string :as s]
            [utils.core :refer :all]
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
      #_(Thread/sleep 200)
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
  [count-features m]
  (cond
    (> count-features 1)
    (or
     (let [category (get-in m [:properties :category])
           osm_type (get-in m [:properties :osm_type])]
       (or
        (in? ["building"] category)
        (and (in? ["node"] osm_type)
             (in? ["amenity"] category))))

     (let [type (get-in m [:properties :geocoding :type])
           osm_type (get-in m [:properties :geocoding :osm_type])]
       (or
        (and (in? ["way"] osm_type)
             (in? ["yes"] type))
        (and (in? ["node"] osm_type)
             (in? ["library"] type)))))

    (= count-features 1)
    true

    :else
    (println "ERROR" "No matching condition for" m)))

(defn update-features [m]
  #_(def service-response m)
  (update-in
   m
   [:json :features]
   (fn [features]
     (let [count-features (count features)]
       (->> features
            (filter (fn [m] (relevant-response? count-features m)))
            (mapv (fn [feature]
                    (update-in
                     feature
                     [:properties]
                     (fn [properties]
                       (conj (assoc properties

                                    :display_name
                                    (s/replace (:address m) "\n" ", ")

                                    :description
                                    (:desc m)
                                    )
                             (->> [:name :desc]
                                  (select-keys m)
                                  (extra-properties))))))))))))

(defn geo-data
  "(geo-data {:ms ods/ms :format :umap})"
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
     ;; not the request-format
     (feature-collection format))))

(defn save-json
  "(save-json (geo-data {:ms ods/ms :format :umap}) \"resources/<filename>.umap\")"
  [json filename]
  (spit filename
        (cheshire/generate-string
         json
         #_(geo-data {:ms ms :format :umap})
         {:pretty true})
        #_(json/write-str
           (geo-data {:format :umap}))))

#_(json/pprint (geo-data {:format :umap}))

