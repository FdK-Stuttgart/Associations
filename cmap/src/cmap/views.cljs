(ns cmap.views
  (:require
   [re-frame.core :as re-frame]
   [cmap.styles :as styles]
   [cmap.subs :as subs]
   [cmap.config :as config]
   [reagent.core :as reagent]
   ["ol/proj" :as ol]
   ["rlayers" :as rl]
   #_["ol/css"] ;; TODO use ol/css instead of <link rel="stylesheet" ...>
   ))

(def props
  {:width "50%"
   :height "90vh"
   :initial {:center (js->clj (.fromLonLat ol #js [2.364 48.82]))
             :zoom 11}})

(def RMap (reagent/adapt-react-class rl/RMap))
(def ROSM (reagent/adapt-react-class rl/ROSM))

;; (.log js/console "RMap" RMap)
;; (.log js/console "ROSM" ROSM)

(defn main-panel []
  (let [name (re-frame/subscribe [::subs/name])]
    [:div
     [RMap props [ROSM]]
     [:div {:class (styles/level1)} @name" v"config/version]]))
