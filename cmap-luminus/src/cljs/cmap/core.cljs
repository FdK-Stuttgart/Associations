(ns cmap.core
  "entry point, plus history, routing, etc"
  (:require
    [day8.re-frame.http-fx]
    [reagent.dom :as rdom]
    [reagent.core :as r]
    [re-frame.core :as rf]
    [goog.events :as events]
    #_[goog.history.EventType :as HistoryEventType]
    [cmap.ajax :as ajax]

    ;; https://day8.github.io/re-frame/App-Structure/#the-gotcha
    [cmap.events] ;; must be required
    [cmap.subs] ;; must be required

    [cmap.views :as views]
    [cmap.config :as config]
    [reitit.core :as reitit]
    [reitit.frontend.easy :as rfe])
  #_(:import goog.History))

(def >evt re-frame.core/dispatch)

(defn navigate! [match _]
  (rf/dispatch [:common/navigate match]))

(def router
  (reitit/router
   [["/" {:name        :home
          :view        views/home-page
          :controllers [{:start (fn [_]
                                  (rf/dispatch [:page/init-home]))}]}]
    ["/about" {:name :about
               :view views/about-page}]]))

(defn start-router! []
  (rfe/start!
    router
    navigate!
    {}))

(defn dev-setup []
  (when config/debug?
    (println "dev mode")))

(defn ^:dev/after-load mount-components []
  (rf/clear-subscription-cache!)
  (let [root-el (.getElementById js/document "app")]
    (rdom/unmount-component-at-node root-el)
    (rdom/render [views/page] root-el)))

(defn init! []
  (dev-setup)
  (start-router!)
  (ajax/load-interceptors!)
  (rf/dispatch [:page/init-db])
  (mount-components))
