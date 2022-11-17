(ns fdk.cmap.events
  "event handlers (control/update layer)"
  (:require
    [fdk.cmap.data :as data]
    [re-frame.core :as rf]
    [ajax.core :as ajax]
    [reitit.frontend.easy :as rfe]
    [reitit.frontend.controllers :as rfc]))

;; ;; dispatchers
;; ;; What is the difference between reg-event-db, reg-event-fx and reg-event-ctx in Re-frame?
;; ;; https://stackoverflow.com/a/54864938/5151982

(rf/reg-event-db
 :set-db-associations
 (fn [db [_ vals]]
   (assoc db :db-associations vals)))

(rf/reg-event-fx
 :fetch-from-db
 (fn [_ _]
   {:http-xhrio {:method          :get
                 :uri             "/api/db-vals"
                 :response-format (ajax/raw-response-format)
                 :on-success      [:set-db-associations]}}))

(rf/reg-event-fx :page/init-db     (fn [_ _] {:dispatch [:fetch-from-db]}))
