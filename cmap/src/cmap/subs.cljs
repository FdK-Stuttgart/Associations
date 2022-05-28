(ns cmap.subs
  (:require
   [re-frame.core :as re-frame]
   [cmap.data :as data]
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

(defn associations [db]
  ((comp
    (partial map ids-to-names))
   data/associations ;; load saved data
   #_((comp
       cljs.reader/read-string
       #_(fn [d]
           (->>
            #_{:a 1 :b 2 :x "fox"}
            d
            (println)
            d))
       :db-associations)
      db)))

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

(re-frame/reg-sub
 ::name
 (fn [db]
   (:name db)))

(defn adjust-associations [ms]
  ((comp
    (fn [m] (dissoc m :lng :lat))
    (fn [m] (assoc-in m [:coords] (vals (select-keys m [:lng :lat]))))
    (fn [m]
      (clojure.set/rename-keys m
                               {:associationid :k
                                :addressline1 :addr
                                :districtlist :districts
                                :mail :email
                                :activities_text :activities
                                :goals_text :goals
                                }))
    (fn [m] (update-in m [:name] (fn [s] (s/replace s " e. V." ""))))
    (fn [m] (select-keys m [:associationid
                            :name
                            :activities_text
                            :goals_text
                            :addressline1
                            :districtlist
                            :mail
                            :lng
                            :lat
                            :imageurl
                            :linkurl
                            :linktext
                            :socialmediaid
                            :socialmediaplatform
                            :socialmediaurl
                            :socialmediaorderindex
                            :socialmedialinktext]))
    first)
   ms))

(re-frame/reg-sub
 :db-associations
 (fn [db _]
   ((comp
     (partial map adjust-associations)
     vals
     (partial group-by :associationid)
     associations)
    db)))


