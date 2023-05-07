(ns fdk.cmap.views
  (:require
   [re-frame.core :as re-frame]
   [fdk.cmap.styles :as styles :refer [pxu]]
   [fdk.cmap.subs :as subs]
   [fdk.cmap.data :as data]
   [fdk.cmap.lang :refer [de]]
   [fdk.cmap.config :as config]
   [fdk.cmap.react-components :as rc]
   [reagent.core :as reagent]
   [reagent.dom :as rdom]
   [reagent.dom.server :as rserver]
   [reagent.impl.component :as ric]
   [clojure.string :as s] ;; for s/join
   [goog.string :as gstr]
   [cljs.pprint :as pp]
   ["react-leaflet" :as rle]
   ["leaflet.markercluster"]
   ;; TODO use import instead of <link rel="stylesheet" ...>
   ;; ["semantic-ui-css/components/tab" :as csu]
   ["react" :as react]
   #_[fdk.cmap.viewso :as v]
   [fdk.cmap.viewsn :as v]
   ))

(enable-console-print!)



(defn main-panel []
  ;; re-frame/subscribe must be called multiple times, otherwise the
  ;; db-vals is empty
  (when-let [db-vals @(re-frame/subscribe [:db-associations])]
    (reset! v/db-vals-atom      db-vals)
    (reset! v/db-vals-init-atom db-vals)
    #_(js/console.log "0 [main-panel]" (count db-vals))
    (let [markers (v/create-markers db-vals)]
      (when-let [center-map
                 #_[9.177591 48.775471]
                 @(re-frame/subscribe [:center-map])]
        #_[resizable {} center-map]
        [v/map-with-list {} markers center-map]))))

