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
   #_["ol/css" :as css] ;; TODO use ol/css instead of <link rel="stylesheet" ...>
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

(def coords {:origin        #js [2.364 48.82]
             :ArcDeTriomphe #js [2.295 48.8737]
             :PlaceDItalie  #js [2.355 48.831]
             :Bastille      #js [2.369 48.853]
             :TourEiffel    #js [2.294 48.858]
             :Montmartre    #js [2.342 48.887]
             })

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
      [:div {:class [(styles/column) (styles/right)]} "right"]
      ]
     [:div {:class (styles/level1)} @name" v"config/version]]
    ))
