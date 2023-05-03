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
   [fdk.cmap.viewso :as v]
   #_[fdk.cmap.viewsn :as v]
   ))

(enable-console-print!)

;;; from https://stackoverflow.com/questions/26233180/resize-a-div-on-border-drag-and-drop-without-adding-extra-markup
#_
(defn resizable [params center-map]
  (let [ref (react/createRef)
        re-zoom false]
    (reagent/create-class
     {
      :component-did-mount
      (fn [_this]
        ;; (js/console.log "[:component-did-mount]" "ref" ref)
        ;; (js/console.log "[:component-did-mount]" "_this" _this)
        (let [
              node-ref       (.-current ref)
              ;; TODO find header, center, footer
              node-header    (.item (-> node-ref .-children) 0)
              node-center    (.item (-> node-ref .-children) 1)
              node-footer    (.item (-> node-ref .-children) 3)
              ]
          (let [node-map-style (-> node-center .-style)]
            (set! (-> node-map-style .-width)
                  (str (.-clientWidth node-center) pxu))
            #_
            (js/console.log
             "[: did-mount]"
             "(.-clientHeight node-ref)" (.-clientHeight node-ref)
             "(.-clientHeight node-header)" (.-clientHeight node-header)
             "(.-clientHeight node-center)" (.-clientHeight node-center)
             "(.-clientHeight node-footer)" (.-clientHeight node-footer))
            (set! (-> node-map-style .-height)
                  (str (- (.-clientHeight node-center)
                          ;; '* 2' b/c padding top and bottom is the same
                          (* 2 styles/padding)) pxu)))
          (let [leaflet-map (-> node-center js/L.map)]
            (reset! map-atom leaflet-map)
            (.setView leaflet-map (let [[longitude latitude] center-map]
                                    ;; initial zoom needed
                                    (array latitude longitude)) zoom)
            (.on leaflet-map "click" (fn [_]
                                       (when @active-atom
                                         (reset! active-atom nil))))
            (.on leaflet-map "popupopen"
                 (on-popup-open-event-fn leaflet-map))

            (.addTo (js/L.tileLayer
                     "https://{s}.tile.OpenStreetMap.org/{z}/{x}/{y}.png"
                     ;; #js {:attribution
                     ;;      (gstr/format
                     ;;       "&copy; <a href=\"%s\">%s</a> contributors"
                     ;;       "http://osm.org/copyright"
                     ;;       "OpenStreetMap")}
                     )
                    leaflet-map))))

      :component-did-update
      (fn [_this _old-argv _old-state _snapshot]
        ;; (js/console.log "[:component-did-update]" "_this" _this)
        ;; (js/console.log "[:component-did-update]" "_old-argv" _old-argv)
        ;; (js/console.log "[:component-did-update]" "_old-state" _old-state)
        ;; (js/console.log "[:component-did-update]" "_snapshot" _snapshot)
        ((comp
          #_(fn [v] (js/console.log "[:component-did-update]" "v" v) v)
          (partial update-markers re-zoom)
          (fn [v] (nth v 2))
          (fn [v] (get v "argv"))
          js->clj
          (fn [v] (.-props v))
          #_(fn [v] (js/console.log "[:component-did-update]" "v" v) v))
         _this)
        )

      :display-name "My Leaflet Map"

      :reagent-render
      (fn [params center-map]
        (when @map-atom
          (update-markers re-zoom))
        [:div#c {:ref ref
                 :class [(styles/c)]}
         [:div {:class [(styles/header)]} #_"header"]
         [:div#l {:class [(styles/l) (styles/center)]
                  :on-mouse-move on-mouse-move} #_"left"]
         [:div#r {:class [(styles/r) (styles/right)]
                  :on-mouse-move on-mouse-move}
          [:div#d {:class [(styles/d)]
                   :on-mouse-down (fn [e]
                                    (js/console.log "start")
                                    (reset! isResizing true))
                   :on-mouse-up   (fn [e]
                                    (js/console.log "stop")
                                    (reset! isResizing false))}]
          (right)]
         [:div {:class [(styles/footer)]}
          (str @(re-frame/subscribe [::subs/name])
               " v"
               ;; output of `git describe --tags --dirty=-SNAPSHOT`
               ;; See :shadow-git-inject/version
               config/version)]])})))

(defn main-panel []
  ;; re-frame/subscribe must be called multiple times, otherwise the
  ;; db-vals is empty
  (when-let [db-vals @(re-frame/subscribe [:db-associations])]
    (reset! v/db-vals-atom      db-vals)
    (reset! v/db-vals-init-atom db-vals)
    #_(js/console.log "0 [main-panel]" (count db-vals))
    (let [
          ;; markers are removed from the map when the 'Vereinsdaten
          ;; durchsuchen' filter is applied

          markers (v/create-markers db-vals)
          ]
      (when-let [center-map
                 #_[9.177591 48.775471]
                 @(re-frame/subscribe [:center-map])]
        #_[resizable {} center-map]
        [v/map-with-list {} markers center-map]))))
