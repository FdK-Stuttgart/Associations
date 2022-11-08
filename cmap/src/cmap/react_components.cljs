(ns cmap.react-components
  "Third party react components"
  (:require
   [reagent.core :as reagent]
   ["semantic-ui-react" :as rsu]
   #_["react-leaflet" :as rle]
   ))

(def Tab (reagent/adapt-react-class rsu/Tab))

;; (def MapContainer (reagent/adapt-react-class rle/MapContainer))
;; (def TileLayer (reagent/adapt-react-class rle/TileLayer))
;; (def Marker (reagent/adapt-react-class rle/Marker))
;; (def Popup (reagent/adapt-react-class rle/Popup))
;; (def useMap (reagent/adapt-react-class rle/useMap))
