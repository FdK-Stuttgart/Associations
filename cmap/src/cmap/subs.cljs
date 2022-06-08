(ns cmap.subs
  (:require
   [re-frame.core :as re-frame]
   [cmap.data :as data]
   [clojure.set :refer [rename-keys]]
   ;; TODO cleanup org.clojars.bost/utils:
   ;; It produce a lot of warnings (probably because of differences clojure vs.
   ;; clojurescript)
   #_[utils.core :refer [in?]]
   [clojure.string :as s]))

(def districts--id-name
  "A map of pairs e.g.
  {\"district-id1\" \"district-name1\"
   \"district-id2\" \"district-name2\"
   ...}"
  ((comp
    (partial apply conj)
    (partial map
             (comp
              (partial apply hash-map)
              vals
              (fn [m] (select-keys m [:value :label])))))
   data/districts))

(defn ids-to-names [m]
  (update-in m [:districtlist] (comp
                                (partial mapv (partial get districts--id-name))
                                cljs.reader/read-string)))

;; TODO districts need to be obtained from the db
(defn districts [db]
  data/districts ;; load saved data
  #_((comp
      cljs.reader/read-string
      #_(fn [d]
          (->>
           #_{:a 1 :b 2 :x "fox"}
           d
           (println)
           d))
      :db-districts)
     db))

(re-frame/reg-sub ::name (fn [db] (:name db)))

(defn adjust-associations [ms]
  ((comp
    (fn [m] (dissoc m :lng :lat))
    (fn [m] (assoc-in m [:coords] (vals (select-keys m [:lng :lat]))))
    (fn [m] (rename-keys m {:associationid :k
                            :addressline1 :addr
                            :districtlist :districts
                            :mail :email
                            :activities_text :activities
                            :goals_text :goals}))
    (fn [m] (update-in m [:name] (fn [s] (s/replace s " e. V." ""))))
    (fn [m] (select-keys m [:associationid
                            :name
                            :street
                            :postcode-city
                            :city
                            :activities_text
                            :goals_text
                            :addressline1
                            :districtlist
                            :mail
                            :lng
                            :lat
                            :imageurl
                            :links
                            :socialmedia]))
    first)
   ms))

(defn in?
  "true if `sequence` contains `elem`. See (contains? (set sequence) elem)"
  [sequence elem]
  (boolean (some (fn [e] (= elem e)) sequence)))

(defn group-by-stuff [ms]
  ((comp
    (fn [m] (assoc m
                   :postcode-city (str (:postcode m) " " (:city m))
                   :links
                   {
                    :url  (keep :linkurl ms)
                    :text (keep :linklinktext ms)
                    }
                   :socialmedia
                   {
                    :ids         (keep :socialmediaid ms)
                    :platforms   (keep :socialmediaplatform ms)
                    :urls        (keep :socialmediaurl ms)
                    ;; :orderindexs (keep :socialmediaorderindex ms)
                    :linktexts   (keep :socialmedialinktext ms)}))
    first
    (partial map (fn [m]
                   (dissoc m
                           :socialmediaid
                           :socialmediaplatform
                           :socialmediaurl
                           :socialmediaorderindex
                           :socialmedialinktext
                           :linklinktext
                           :linkurl
                           ))))
   ms))

;; TODO the 'e. V.' should appear in the popups but not in the right panel
(re-frame/reg-sub
 :db-associations
 (fn [db _]
   ((comp
     (fn [m] (def as m) m)
     (partial sort-by :name)
     (partial map adjust-associations)
     vals
     (partial group-by :associationid)
     (partial map group-by-stuff)
     (partial map (partial sort-by :socialmediaorderindex))
     vals
     (partial group-by :associationid)
     #_(fn [m] (def bs m) m)
     #_(partial filter (fn [m] (in? [
                                     ;; Evidence and COEXIST are overlapping
                                   "Evidence e. V."
                                   #_"Kalimera e. V. Deutsch-Griechische Kulturinitiative"
                                   #_"Afro Deutsches Akademiker Netzwerk ADAN"
                                   #_"Africa Workshop Organisation e. V."]
                                  (:name m))))
     (partial map ids-to-names)
     (fn [_] "load saved data" data/associations)
     #_(comp cljs.reader/read-string
             #_(fn [d] (->>
                        #_{:a 1 :b 2 :x "fox"}
                        d
                        (println)
                        d))
             :db-associations))
    db)))
