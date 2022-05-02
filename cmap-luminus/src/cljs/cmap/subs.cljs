(ns cmap.subs
  "subscriptions / subscription handlers (query layer)"
  (:require
   [re-frame.core :as rf]
   [markdown.core :refer [md->html]]))

(rf/reg-sub :common/route
            (fn [db _] (-> db :common/route)))
(rf/reg-sub :common/page-id :<- [:common/route]
            (fn [route _] (-> route :data :name)))
(rf/reg-sub :common/page    :<- [:common/route]
            (fn [route _] (-> route :data :view)))
(rf/reg-sub :db-vals
            (fn [db _]
              ((comp
                (partial vector :div)
                (partial map (comp (partial vector :div) :name first))
                vals
                (partial group-by :associationid)
                cljs.reader/read-string
                :db-vals)
               db)))
(rf/reg-sub :docs
            (fn [db _] ((comp md->html :docs) db)))
(rf/reg-sub :common/error
            (fn [db _] (:common/error db)))
