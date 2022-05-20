(ns cmap.subs
  (:require
   [re-frame.core :as re-frame]
   [cmap.data :as data]
   [clojure.string :as s]))

(re-frame/reg-sub
 ::name
 (fn [db]
   (:name db)))

(defn db-vals [db]
  data/db-vals ;; load saved data
  #_((comp
      cljs.reader/read-string
      #_(fn [d]
          (->>
           #_{:a 1 :b 2 :x "fox"}
           d
           (println)
           d))
      :db-vals)
     db))

(re-frame/reg-sub
 :db-vals
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
                   [(:lng m) (:lat m)]
                   (:imageurl m)])))
     vals
     (partial group-by :associationid)
     db-vals)
    db)))

