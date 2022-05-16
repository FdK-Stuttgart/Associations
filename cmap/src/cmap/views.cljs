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

(def props
  {
   ;; :width "50%"
   :height #_"90vh" "100%"
   ;; TODO recenter map to Stuttgart city center
   :initial {:center (js->clj (.fromLonLat proj #js [9.163174 48.774901]))
             :zoom 11}})

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

(defn right [t]
  [Tab {:panes
        [{:menuItem "Tab 1" :render
          (fn []
              ((comp
                reagent/as-element
                (partial vector :div {:class "ui attached segment active tab"})
                (partial vector :div {:class "sidebar-content ng-tns-c14-0"})
                (partial vector :div {:class "association-entries ng-star-inserted"})
                #_(partial take 2)
                (partial
                 map
                 (fn [[k name addr _ _]]
                   [:span {:key k :on-click (fn [e] (println "on-click" e))}
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
               t))}
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

(defn greeting [message]
  [:h1 message])

(defn clock [time-color]
  (let [[timer update-time] (react/useState (js/Date.))
        time-str (-> timer .toTimeString (s/split " ") first)]
    (react/useEffect
     (fn []
       (let [i (js/setInterval #(update-time (js/Date.)) 1000)]
         (fn []
           (js/clearInterval i)))))
    [:div.example-clock
     {:style {:color time-color}}
     time-str]))

(defn color-input [time-color update-time-color]
  [:div.color-input
   "Time color: "
   [:input {:type "text"
            :value time-color
            :on-change #(update-time-color (-> % .-target .-value))}]])

(defn simple-example []
  (let [[time-color update-time-color] (react/useState "#f34")]
    [:div
     #_(println "view" view "setView" setView)
     #_[greeting "Hello world, it is now"]
     #_[clock time-color]
     #_[color-input time-color update-time-color]

     ;; Or with the default options you can create function components using :f> shortcut:
     [greeting "Hello world, it is now"]
     [:f> clock time-color]
     [:f> color-input time-color update-time-color]
     ]))

(defn main-panel []
  (let [[view setView] [] #_(react/useState (clj->js {:center "origin" :zoom 11}))]
    (println "view" view "setView" setView)
    (let [name (re-frame/subscribe [::subs/name])]
      (when-let [t @(re-frame/subscribe [:db-vals])]
        [:div {:class (styles/ex-container)}
         [:div {:class (styles/wrapper)}
          [:div {:class [(styles/header)]}
           [:f> simple-example]]
          #_[:div {:class [(styles/left)]} "left"]
          [:div {:class [(styles/center)]}
           [RMap props [ROSM]
            ((comp
              (partial into [RLayerVector {:zIndex 10}])
              (partial
               mapv (fn [[_ name addr lat lng]]
                      [RFeature
                       {:geometry (new geom/Point
                                       (.fromLonLat proj (clj->js [lng lat])))}
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
             t)]]
          [:div {:class [(styles/right)]} [right t]]
          [:div {:class [(styles/footer)]} @name" v"config/version]]]))))
