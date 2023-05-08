(ns fdk.cmap.subs
  (:require
   [re-frame.core :as rf]
   [fdk.cmap.data :as data]
   [clojure.set :refer [rename-keys]]
   ;; TODO cleanup org.clojars.bost/utils:
   ;; It produce a lot of warnings (probably because of differences clojure vs.
   ;; clojurescript)
   #_[utils.core :refer [in?]]
   [cljs.reader :refer [read-string]]
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
                                read-string)))

(defn prepare [db]
  ((comp
    (partial map ids-to-names)
    ;; (fn [_] "load saved data" data/associations)
    read-string
    :db-associations)
   db))

;; TODO districts need to be obtained from the db
(defn districts [db]
  #_data/districts ;; load saved data
  ((comp
      read-string
      #_(fn [d]
          (->>
           #_{:a 1 :b 2 :x "fox"}
           d
           (println)
           d))
      :db-districts)
     db))

(rf/reg-sub ::name (fn [db] (:name db)))

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
  "Generic. Returns true if `sequence` \"contains\" `elem`.
  See (contains? (set sequence) elem). E.g.:
  (in?                             [\"a\" \"b\" \"c\"] \"b\")
  (in? cljs.core/=                 [\"a\" \"b\" \"c\"] \"b\")
  (in? clojure.string/includes?    [\"a\" \"b\" \"c\"] \"xyzb\")
  (in? clojure.string/starts-with? [\"a\" \"b\" \"c\"] \"cxyz\")
  "
  ([sequence elem] (in? cljs.core/= sequence elem))
  ([matching-fun patterns full-string]
   ((comp
     boolean
     (partial some (partial matching-fun full-string)))
    patterns)))

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

;; TODO overlapping associations:
;; Evidence COEXIST
;; FdK Kalimera

;; dispatchers
;; What is the difference between reg-event-db, reg-event-fx and reg-event-ctx in Re-frame?
;; https://stackoverflow.com/a/54864938/5151982

;; TODO the 'e. V.' should appear in the popups but not in the right panel
(rf/reg-sub
 :db-associations
 (fn [db _]
   ((comp
     (partial sort-by :name)
     (partial map adjust-associations)
     vals
     (partial group-by :associationid)
     (partial map group-by-stuff)
     (partial map (partial sort-by :socialmediaorderindex))
     vals
     (partial group-by :associationid)
     #_
     (partial filter
              (comp (partial in?
                             s/includes?
                             [
                              "ABADÁ Capoeira"
                              "Capoeira Stuttgart"
                              #_"Evidence"
                              "Forum der Kulturen"
                              #_"Kalimera"
                              #_"Afro Deutsches Akademiker Netzwerk ADAN"
                              #_"Africa Workshop Organisation"])
                    :name))
     prepare)
    db)))

;; Docstring doesn't work for rf/reg-sub
;; "Center is the location the FdK"
(rf/reg-sub
 :center-map
 (fn [db _]
   ((comp
     vals
     (fn [m] (select-keys m [:lng :lat]))
     first
     (partial filter
              (comp (partial in? s/includes? ["Forum der Kulturen"])
                    :name))
     prepare)
    db)))
