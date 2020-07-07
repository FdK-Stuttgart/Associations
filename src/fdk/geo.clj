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
  (url {:address \"adr\" :format :geojson})
  (url {:address \"adr\" :format :geocodejson})"
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
      #_(Thread/sleep 1000)
      #_(println (str "[" tbeg ":" (te/tnow) " /" "get-json " url "]"))
      r)))

(defn extra-properties
  " E.g:
  (foo {:name \"n\" :desc \"d\"})
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

(defn geocodejson
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
    :datalayersControl true
    :description "CityMapStuttgart"
    :displayPopupFooter false
    :easing true
    :embedControl true
    :fullscreenControl true
    :licence ""
    :limitBounds {}
    :miniMap false
    :moreControl true
    :name "CityStuttgartMigrantenvereine"
    :scaleControl true
    :scrollWheelZoom true
    :searchControl true
    :slideshow {}
    :tilelayer {}
    :zoom 12
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
  (feature-collection {:format :geojson :features [1 2 3]})"
  [format features]
  (let [json-fn (case format
                  :geocodejson geocodejson
                  :geojson     geojson)]
    (json-fn features)))

(defn update-features [m]
  (update-in
   m
   [:json :features]
   (fn [features]
     (->> features
          (filter (fn [m]
                    (let [category (get-in m [:properties :category])
                          osm_type (get-in m [:properties :osm_type])]
                      (cond
                        (> (count features) 1)
                        (or
                         (in? ["building"] category)
                         (and (in? ["amenity"] category)
                              (in? ["node"] osm_type)))

                        (= (count features) 1)
                        true

                        :else
                        (println "ERROR" "No matching condition for" m)))))
          (mapv (fn [feature]
                  (update-in
                   feature
                   [:properties]
                   (fn [properties]
                     (conj (assoc properties :display_name
                                  (s/replace (:address m) "\n" ", "))
                           (->> [:name :desc]
                                (select-keys m)
                                (extra-properties)))))))))))

(defn geo-data
  "(geo-data {:ms data/ms :format :geojson})"
  [{:keys [ms format] :or {format
                           #_:geojson
                           :geocodejson}}]
  (->>
   ms
   (map (fn [{:keys [address] :as m}]
          (assoc m :url (url {:address (-> (s/replace address "\n" ", ")
                                           (codec/url-encode))
                              :format format}))))
   (map (fn [{:keys [url] :as m}]
          (assoc m :json (get-json url))))
       ;; #_(doall)
   (map (fn [{:keys [address] :as m}]
          (assoc m :url (url {:address (-> (s/replace address "\n" ", ")
                                           (codec/url-encode))
                              :format format}))))
   (map update-features)
   (map (fn [m] (get-in m [:json :features])))
   (reduce into [])
   (feature-collection format)
   ))

(defn save-json
  "(save-json (geo-data {:ms data/ms :format :geojson})
   \"resources/<filename>.geojson\")"
  [json filename]
  (spit filename
        (cheshire/generate-string
         json
         #_(geo-data {:ms ms :format :geojson})
         {:pretty true})
        #_(json/write-str
           (geo-data {:format :geojson}))))

#_(json/pprint (geo-data {:format :geojson}))

