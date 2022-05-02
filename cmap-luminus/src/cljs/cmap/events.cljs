(ns cmap.events
  "event handlers (control/update layer)"
  (:require
    [re-frame.core :as rf]
    [ajax.core :as ajax]
    [reitit.frontend.easy :as rfe]
    [reitit.frontend.controllers :as rfc]))

;; dispatchers
;; What is the difference between reg-event-db, reg-event-fx and reg-event-ctx in Re-frame?
;; https://stackoverflow.com/a/54864938/5151982

(rf/reg-event-db
  :common/navigate
  (fn [db [_ match]]
    (let [old-match (:common/route db)
          new-match (assoc match :controllers
                                 (rfc/apply-controllers (:controllers old-match) match))]
      (assoc db :common/route new-match))))

;; effects handler
(rf/reg-fx
  :common/navigate-fx!
  (fn [[k & [params query]]]
    (rfe/push-state k params query)))

(rf/reg-event-fx
  :common/navigate!
  (fn [_ [_ url-key params query]]
    {:common/navigate-fx! [url-key params query]}))

(rf/reg-event-db :set-db-vals (fn [db [_ vals]] (assoc db :db-vals vals)))

(rf/reg-event-fx
 :fetch-from-db
 (fn [_ _]
   {:http-xhrio {:method          :get
                 :uri             "/db-vals"
                 :response-format (ajax/raw-response-format)
                 :on-success       [:set-db-vals]}}))

(rf/reg-event-db :set-docs (fn [db [_ docs]] (assoc db :docs docs)))

(rf/reg-event-fx
  :fetch-docs
  (fn [_ _]
    {:http-xhrio {:method          :get
                  :uri             "/docs"
                  :response-format (ajax/raw-response-format)
                  :on-success       [:set-docs]}}))

(rf/reg-event-db :common/set-error (fn [db [_ error]] (assoc db :common/error error)))
(rf/reg-event-fx :page/init-db     (fn [_ _] {:dispatch [:fetch-from-db]}))
(rf/reg-event-fx :page/init-home   (fn [_ _] {:dispatch [:fetch-docs]}))
