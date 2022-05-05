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

   ))

(def props
  {
   ;; :width "50%"
   :height "90vh"
   :initial {:center (js->clj (.fromLonLat proj #js [2.364 48.82]))
             :zoom 11}})

;; import { RMap, ROSM, RLayerVector, RFeature, RPopup } from "rlayers";
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

(def coords {:origin        #js [2.364 48.82]
             :ArcDeTriomphe #js [2.295 48.8737]
             :PlaceDItalie  #js [2.355 48.831]
             :Bastille      #js [2.369 48.853]
             :TourEiffel    #js [2.294 48.858]
             :Montmartre    #js [2.342 48.887]
             })
;; primeNgPubAddr           = 'pi pi-map-marker pubAddr';
;; primeNgNoPubAddr         = 'pi pi-map-marker noPubAddr';

;; primeNgPubAddrSelected   = 'pi pi-map        pubAddr';
;; primeNgNoPubAddrSelected = 'pi pi-map        noPubAddr';


;; primeNgNoPubAddr          icon-padding" *ngIf="noPubAddrAssocIds.includes(association.id) === true  && association[identifiedByFieldName] !== selectedAssociationField"
;; primeNgPubAddr            icon-padding" *ngIf="noPubAddrAssocIds.includes(association.id) === false && association[identifiedByFieldName] !== selectedAssociationField"
;; primeNgNoPubAddrSelected  icon-padding" *ngIf="noPubAddrAssocIds.includes(association.id) === true  && association[identifiedByFieldName] === selectedAssociationField"
;; primeNgPubAddrSelected    icon-padding" *ngIf="noPubAddrAssocIds.includes(association.id) === false && association[identifiedByFieldName] === selectedAssociationField"

(defn right []
  [Tab {:panes
        [{:menuItem "Tab 1" :render
          (when-let [t @(re-frame/subscribe [:db-vals])]
            (fn []
              ((comp
                reagent/as-element
                (partial vector :div {:class "ui attached segment active tab"})
                (partial vector :div {:class "sidebar-content ng-tns-c14-0"})
                (partial vector :div {:class "association-entries ng-star-inserted"})
                #_(partial take 2)
                (partial
                 map
                 (fn [[k v]]
                   [:span {:key k}
                    [:div {:class "association-entry ng-star-inserted"}
                     [:a
                      [:div {:class "icon"}
                       [:i {:class "icon-padding pi pi-map-marker pubAddr ng-star-inserted"}]
                       v]]]])))
               t)))}
         {:menuItem "Tab 2" :render
          (when-let [t @(re-frame/subscribe [:db-vals])]
            (fn []
              ((comp
                reagent/as-element
                (partial vector :div {:class "ui attached segment active tab"})
                (partial take 3)
                (partial map (fn [[k v]] [:span {:key k} [:div v]])))
               t)))}
         #_{:menuItem "Tab 3" :render
            (when-let [t @(re-frame/subscribe [:db-vals])]
              (fn []
                ((comp
                  reagent/as-element
                  (partial vector :div {:class "ui attached segment active tab"})
                  (partial take 4)
                  (partial map (fn [[k v]] [:span {:key k} [:div v]])))
                 t)))}]}])
(defn main-panel []
  (let [name (re-frame/subscribe [::subs/name])]
    [:div
     [:div {:class (styles/row)}
      [:div {:class [(styles/column) (styles/left)]}
       ;; "left"
       [RMap props [ROSM]
        [RLayerVector {:zIndex 10}
         [RFeature {:geometry (new geom/Point (.fromLonLat proj (:ArcDeTriomphe coords)))}
          [RStyle
           [RIcon {:src "/img/location.svg" :anchor [0.5 0.8]}]]]]]]
      [:div {:class [(styles/column) (styles/right)]} [right]]]
     [:div {:class (styles/level1)} @name" v"config/version]]))
