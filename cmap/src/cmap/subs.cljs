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
      :db-associations)
     db))


(re-frame/reg-sub
 ::name
 (fn [db]
   (:name db)))

(re-frame/reg-sub
 :db-associations
 (fn [db _]
   ((comp
     (partial map
              (fn [ms]
                (let [m (first ms)]
                  [(:associationid m)
                   [((comp (fn [s] (s/replace s " e. V." ""))
                           :name)
                     m)
                    (:activities_text m)
                    (:goals_text m)]
                   (:addressline1 m)
                   (:districtlist m)
                   (:mail m)
                   [(:lng m) (:lat m)]
                   (:imageurl m)])))
     vals
     (partial group-by :associationid)
     associations)
    db)))

(re-frame/reg-sub
 :db-districts
 (fn [db _]
   ((comp
     (partial map
              (fn [ms]
                (let [m (first ms)]
                  [
                   (:value m) ;; "connect" :value with :districtlist
                   (:label m)
                   (:category m)
                   (:categoryLabel m)
                   (:orderIndex m)
                   ])))
     associations)
    db)))

