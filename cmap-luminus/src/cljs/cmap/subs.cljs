(ns cmap.subs
  "subscriptions / subscription handlers (query layer)"
  (:require
   [re-frame.core :as rf]
   [markdown.core :refer [md->html]]
   [clojure.string :as s]))

(rf/reg-sub :common/route
            (fn [db _] (-> db :common/route)))
(rf/reg-sub :common/page-id :<- [:common/route]
            (fn [route _] (-> route :data :name)))
(rf/reg-sub :common/page    :<- [:common/route]
            (fn [route _] (-> route :data :view)))
(rf/reg-sub :db-vals
            (fn [db _]
              ((comp
                (partial map
                         (fn [ms]
                           (let [m (first ms)]
                             [(:associationid m)
                              ((comp (fn [s] (s/replace s " e. V." ""))
                                     :name)
                               m)])))
                vals
                (partial group-by :associationid)
                cljs.reader/read-string
                :db-vals)
               db)))
(rf/reg-sub :docs
            (fn [db _] ((comp md->html :docs) db)))
(rf/reg-sub :common/error
            (fn [db _] (:common/error db)))
