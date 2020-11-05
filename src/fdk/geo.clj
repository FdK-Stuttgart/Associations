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
   ))

(defn create-url
  "Returns the address-to-latlon mapping service url. E.g.:
  (fdk.geo/create-url {:address \"adr\" :format :umap})
  (fdk.geo/create-url {:address \"adr\" :format :geojson})"
  [{:keys [address format]}]
  (clojure.core/format
   "https://nominatim.openstreetmap.org/search?q=%s&format=%s" address (name format)))

(def request-delay 200)

(defn request [url]
  (debugf "[request] %s" url)
  (let [r (as-> url $
            (client/get $ {:accept :json})
            (:body $)
            (json/read-json $))]
    (Thread/sleep request-delay)
    r))

(defn geojson [features]
  {:type "FeatureCollection" :features features})

(defn layer [idx layer-name features]
  ;; (println "idx" idx)
  ;; (println "layer-name" layer-name)
  ;; (println "features" features)
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

(defn search-properties
  "(fdk.geo/search-properties {:addr \"a\" :desc \"d\" ...})"
  [{:keys [addr city-district desc goal activity]}]
  (conj {} #_{:_umap_options
              {:showLabel true
               :labelInteractive true
               #_#_:iconUrl "/uploads/pictogram/theatre-24-white.png"
               #_#_:iconClass "Default"}}
        {:search_address addr
         :search_district city-district
         :search_desc desc
         :search_goal goal
         :search_activity activity}))

(defn umap
  "
  Test-direkt:    https://umap.openstreetmap.fr/de/map/stadtteilkarte_testversion_459974
  Test-short-url: http://u.osmfr.org/m/459974/

  Prod-direkt:    https://umap.openstreetmap.fr/de/map/stadtteilkarte_459647
  Prod-short-url: http://u.osmfr.org/m/459647/
  "
  [features]
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
    :filterKey (cstr/join "," (map name (into [:name] (keys (search-properties {})))))
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
   :layers (->> (create-groups features)
                #_(map-indexed (fn [idx cat-members]
                               #_(println "idx" idx)
                               (layer idx
                                      (nth ods/categories idx)  ;; here is the category
                                      cat-members                     ;; members
                                      )))
                (map-indexed (fn [idx [cat-name cat-members]]
                               #_(println "idx" idx)
                               (layer idx
                                      cat-name
                                      cat-members
                                      #_(sort-by :name cat-members))))
                (vec)
                #_(inspect-tree))})

(defn feature-collection
  "E.g.:
  (fdk.geo/feature-collection :umap features)
  (fdk.geo/feature-collection :umap [1 2 3])"
  [format features]
  (let [json-fn (case format
                  :umap    umap
                  :geojson geojson)]
    (json-fn features)
    #_(umap features)))

(defn relevant-feature?
  "Created add-hoc. Hmm"
  [count-features feature]
  (cond
    (> count-features 1)
    (or
     (let [category (get-in feature [:properties :category])
           osm_type (get-in feature [:properties :osm_type])]
       (or
        (utc/in? ["building"] category)
        (and (utc/in? ["amenity"] category)
             (utc/in? ["node"] osm_type))))

     (let [type (get-in feature [:properties :geocoding :type])
           osm_type (get-in feature [:properties :geocoding :osm_type])]
       (or
        (and (utc/in? ["way"] osm_type)
             (utc/in? ["yes"] type))
        (and (utc/in? ["node"] osm_type)
             (utc/in? ["library" "parking"] type)))))

    (= count-features 1)
    true

    :else
    (errorf "No matching condition for feature: %s" feature)))

(defn normalize-address [address]
  (let [adr (cstr/replace address "\n" ", ")]
    (if-let [old-house-nr (re-find #"[0-9] [A-z]," adr)]
      (.replaceFirst adr old-house-nr (.replaceAll old-house-nr " " ""))
      adr)))

(defn process-table-row
  [request-format
   {:keys [address city-district name desc goal activity coordinates] :as row}]
  (let [norm-addr (normalize-address address)
        all-features
        (if (empty? coordinates)
          (->> (codec/url-encode norm-addr)
               (assoc {:format request-format}
                      :address)
               (create-url)
               (request)
               :features)
          [{:type "Feature"
            :properties {:geocoding {:name ""}}
            :geometry {:type "Point"
                       :coordinates
                       (read-string (format "[%s]" coordinates))}}])

        cnt-all-features (count all-features)]
    ;; (debugf "type %s; empty? %s; %s" (type coordinates) (empty? coordinates) coordinates)
    (->> all-features
         ;; this looks like a monadic container
         (map-indexed (fn [i feature] [i feature]))
         (filter (fn [[idx feature]]
                   (let [relevant (relevant-feature?
                                   cnt-all-features feature)]
                     (debugf "%s; line %s; %s" norm-addr (:idx row)
                             (if relevant
                               (cstr/join " "
                                          (map (fn [v] (utn/round-precision v 6))
                                               (get-in feature [:geometry :coordinates])))
                               ""))
                     relevant)))

         (mapv (fn [[_ feature]] feature))
         (mapv (fn [feature]
                 #_(def feature feature)
                 (update-in
                  feature
                  [:properties]
                  (fn [properties]
                    #_(def properties properties)
                    (conj (assoc properties
                                 :description
                                 (str
                                  (if (empty? (cstr/trim address))       "" (format "%s\n\n" address))
                                  ;; TODO this (empty? ...) doesn't work
                                  (if (empty? (cstr/trim desc))          "" (format "%s\n\n" desc))
                                  (if (empty? (cstr/trim city-district)) "" (format "Aktiv in Stadtteil(en): %s\n\n" city-district))
                                  (if (empty? (cstr/trim goal))          "" (format "Ziele des Vereins: %s\n\n" goal))
                                  (if (empty? (cstr/trim activity))      "" (format "Aktivitätsbereiche: %s" activity)))
                                 :name name)
                          (search-properties {:addr norm-addr
                                              :desc desc
                                              :city-district city-district
                                              :goal goal
                                              :activity activity})))))))))

(defn calc-geo-data
  [{:keys [ods-table format] :or {format #_:geojson :umap}}]
  (let [request-format (if (= format :umap) :geocodejson format)]
    (->> ods-table
         (map (fn [table-row] (process-table-row request-format table-row)))
         (reduce into [])
         ((fn [coll]
            (infof "Coordinates found %s" (count coll))
            coll)))))

(defn resolved-addresses
  [json]
  (->> json
       :layers
       (map (fn [layer]
              (->> (get-in layer [:features])
                   (map (fn [feature]
                          (get-in feature [:properties :display_name]))))))
       (flatten)
       (set)))

(defn unresolved-addresses
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


(defn get-geo-data [prm]
  (let [ks [:geo-data]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! (fn [] (calc-geo-data prm)) ks))))

(defn calc-json-fn
  "(fdk.geo/calc-json-fn :umap)"
  [format]
  (->> (get-geo-data {:ods-table (ods/read-table) :format :umap})
       ;; The correct param of `feature-collection` is `format` not the
       ;; `request-format`
       (feature-collection format)))

(defn json
  "(fdk.geo/json :umap)"
  [format]
  (let [ks [:json]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! (fn [] (calc-json-fn format)) ks))))

(defn save-json
  "During evaluation it defines the `json` var for debugging purposes. E.g.:
  (fdk.geo/save-json (fdk.geo/json :umap) \"resources/<filename>.umap\")
  "
  [json filename]
  (spit filename
        (cheshire/generate-string json {:pretty true})))
