(ns cmap.react-components
  "Third party react components"
  (:require
   [reagent.core :as reagent]
   #_["ol/proj" :as proj]
   #_["ol/geom" :as geom]

   ["rlayers" :as rl]
   ["rlayers/style" :as style]
   ["semantic-ui-react" :as rsu]
   ))

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

