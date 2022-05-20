(ns cmap.views
  (:require
   [re-frame.core :as re-frame]
   [cmap.styles :as styles]
   [cmap.subs :as subs]
   [cmap.config :as config]
   [reagent.core :as reagent]

   ["ol/proj" :as proj]
   ["ol/geom" :as geom]

   ["rlayers" :as rl]
   ["rlayers/style" :as style]

   ["semantic-ui-react" :as rsu]
   ;; TODO use import instead of <link rel="stylesheet" ...>
   ;; ["semantic-ui-css/components/tab" :as csu]
   ;; ["ol/css" :as css]

   [clojure.string :as s]
   ["react" :as react]
   ))

(defn fromLonLat [lon-lat] (.fromLonLat proj (clj->js lon-lat)))

(def RMap (reagent/adapt-react-class rl/RMap))
(def ROSM (reagent/adapt-react-class rl/ROSM))
(def RLayerVector (reagent/adapt-react-class rl/RLayerVector))
(def RFeature (reagent/adapt-react-class rl/RFeature))
(def RPopup (reagent/adapt-react-class rl/RPopup))

;; import { RStyle, RIcon, RFill, RStroke } from "rlayers/style";
(def RStyle (reagent/adapt-react-class style/RStyle))
(def RIcon (reagent/adapt-react-class style/RIcon))

;; (.log js/console "RMap" RMap)
;; (.log js/console "ROSM" ROSM)

(def Tab (reagent/adapt-react-class rsu/Tab))

;; primeNgPubAddr           = 'pi pi-map-marker pubAddr';
;; primeNgNoPubAddr         = 'pi pi-map-marker noPubAddr';

;; primeNgPubAddrSelected   = 'pi pi-map        pubAddr';
;; primeNgNoPubAddrSelected = 'pi pi-map        noPubAddr';

;; TODO public-address? computation should be done elsewhere
(defn public-address? [norm-addr]
  (not (re-find #"(?i).*keine|Postfach.*" norm-addr)))

;; primeNgNoPubAddr          icon-padding" *ngIf="noPubAddrAssocIds.includes(association.id) === true  && association[identifiedByFieldName] !== selectedAssociationField"
;; primeNgPubAddr            icon-padding" *ngIf="noPubAddrAssocIds.includes(association.id) === false && association[identifiedByFieldName] !== selectedAssociationField"
;; primeNgNoPubAddrSelected  icon-padding" *ngIf="noPubAddrAssocIds.includes(association.id) === true  && association[identifiedByFieldName] === selectedAssociationField"
;; primeNgPubAddrSelected    icon-padding" *ngIf="noPubAddrAssocIds.includes(association.id) === false && association[identifiedByFieldName] === selectedAssociationField"


(defn simple-example []
  (let [[time-color update-time-color] (react/useState "#f34")]
    [:div
     (let [[timer update-time] (react/useState (js/Date.))]
       (react/useEffect
        (fn []
          (let [i (js/setInterval (fn [] (update-time (js/Date.))) 1000)]
            (fn [] (js/clearInterval i)))))
       [:div {:style {:color time-color}} (-> timer
                                              .toTimeString
                                              (s/split " ")
                                              first)])
     [:div.color-input
      "Time color: "
      [:input {:type "text"
               :value time-color
               :on-change (comp
                           update-time-color
                           (fn [x] (.-value x))
                           (fn [x] (.-target x)))}]]]))

(defn right [db-vals set-view]
  [:div
   [:f> simple-example]
   [Tab {:panes
         [{:menuItem "Tab 1" :render
           (fn []
             ((comp
               reagent/as-element
               (partial vector :div {:class "ui attached segment active tab"})
               (partial vector :div {:class "sidebar-content ng-tns-c14-0"})
               (partial vector :div {:class "association-entries ng-star-inserted"})
               (partial
                map
                (fn [[k name addr _ _]]
                  [:span {:key k :on-click (fn [e]
                                             (set-view
                                              ((comp
                                                clj->js
                                                (partial hash-map :zoom 11 :center)
                                                fromLonLat)
                                               [10.163174 48.774901])))}
                   [:div {:class "association-entry ng-star-inserted"}
                    [:a
                     [:div {:class "icon"}
                      ((comp
                        #_(partial vector :div {:class "icon"})
                        (partial vector :i)
                        (partial hash-map :class)
                        (partial s/join " ")
                        (fn [c] (conj c (if (public-address? addr)
                                          "pubAddr" "noPubAddr"))))
                       ["icon-padding" "pi" "pi-map-marker" "ng-star-inserted"])
                      name]]]])))
              db-vals))}
          {:menuItem "Tab 2" :render
           (fn []
             ((comp
               reagent/as-element
               (partial vector :div {:class "ui attached segment active tab"})
               #_(partial take 3)
               (partial map (fn [[k v]] [:span {:key k} [:div v]])))
              db-vals))}
          #_{:menuItem "Tab 3" :render
             (when-let [db-vals @(re-frame/subscribe [:db-vals])]
               (fn []
                 ((comp
                   reagent/as-element
                   (partial vector :div {:class "ui attached segment active tab"})
                   (partial take 4)
                   (partial map (fn [[k v]] [:span {:key k} [:div v]])))
                  db-vals)))}]}]])

(defn rlayers-map [db-vals view set-view]
  ((comp
    (partial conj
             [RMap {#_#_:width "50%" :height #_"90vh" "100%"
                    :initial view :view [view set-view]}
              #_(let [this (reagent/current-component)]
                (js/console.log "this" this))
              [ROSM]])
    (partial into [RLayerVector {:zIndex 10}])
    (partial
     mapv (fn [[_ name addr lat lng]]
            [RFeature
             {:geometry (new geom/Point
                             (fromLonLat [lng lat]))}
             [RStyle
              [RIcon {:src
                      (str "/img/" (if (public-address? addr)
                                     "pub-addr.svg" "priv-addr.svg") )
                      :anchor [0.5 0.8]}]]
             [RPopup {:trigger
                      "click"
                      #_"hover"
                      :class "example-overlay"}
              [:div {:class "card"}]
              [:p {:class "card-header"} name]
              #_[:p {:class "card-body text-center"} "Popup on click"]]])))
   db-vals))

(defn go [db-vals]
  (let [[view set-view] ((comp
                         react/useState
                         clj->js
                         (partial hash-map :zoom 11 :center)
                         fromLonLat)
                        ;; TODO recenter map to Stuttgart city center
                        [9.163174 48.774901])]
    ((comp
      #_(partial conj [:div {:class (styles/ex-container)}])
      (partial into [:div {:class (styles/wrapper)}]))
     [
      #_[:div {:class [(styles/header)]}]
      #_[:div {:class [(styles/left)]} "left"]
      [:div {:class [(styles/center)]} [:f> rlayers-map db-vals view set-view]]
      [:div {:class [(styles/right)]} [right db-vals set-view]]
      [:div {:class [(styles/footer)]}
       (str @(re-frame/subscribe [::subs/name]) " v" config/version)]])))

(defn main-panel []
  (when-let [db-vals @(re-frame/subscribe [:db-vals])]
    [:f> go db-vals]))
