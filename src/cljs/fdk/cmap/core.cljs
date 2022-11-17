(ns fdk.cmap.core
  (:require
   [reagent.dom :as rdom]
   ;; not in the [reagent "1.1.1"] yet
   #_[reagent.dom.client :refer [create-root]]
   [re-frame.core :as re-frame]
   [fdk.cmap.events :as events]
   [fdk.cmap.views :as views]
   [fdk.cmap.config :as config]
   ))


(defn dev-setup []
  (when config/debug?
    (println "dev mode")))

#_
(defn ^:dev/after-load mount-root []
  (re-frame/clear-subscription-cache!)
  (let [root-el (.getElementById js/document "app")
        root-container (create-root root-el)]
    (rdom/unmount-component-at-node root-el)
    (.render root-container [views/main-panel])))

(defn ^:dev/after-load mount-root []
  (re-frame/clear-subscription-cache!)
  (let [root-el (.getElementById js/document "app")]
    (rdom/unmount-component-at-node root-el)
    (rdom/render [views/main-panel] root-el)))

(defn init []
  (re-frame/dispatch-sync [::events/initialize-db])
  (dev-setup)
  (mount-root))
