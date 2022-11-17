(ns fdk.cmap.core
  "entry point, plus history, routing, etc"
  (:require
    [day8.re-frame.http-fx]
    [reagent.dom :as rdom]
    #_[reagent.dom.client :refer [create-root]]
    [re-frame.core :as rf]
    [fdk.cmap.views :as views]

    ;; https://day8.github.io/re-frame/App-Structure/#the-gotcha
    [fdk.cmap.events] ;; must be required
    [fdk.cmap.subs] ;; must be required
    ))

#_
(defn ^:dev/after-load mount-components []
  (rf/clear-subscription-cache!)
  (let [root-el (.getElementById js/document "app")
        root-container (create-root root-el)]
    (rdom/unmount-component-at-node root-el)
    (.render root-container [views/main-panel])))

(defn ^:dev/after-load mount-components []
  (rf/clear-subscription-cache!)
  (let [root-el (.getElementById js/document "app")]
    (rdom/unmount-component-at-node root-el)
    (rdom/render [views/main-panel] root-el)))

(defn init []
  #_(ajax/load-interceptors!)
  (rf/dispatch [:page/init-db])
  (mount-components))
