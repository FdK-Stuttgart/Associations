(ns cmap.views
  (:require
   [re-frame.core :as re-frame]
   [cmap.styles :as styles]
   [cmap.subs :as subs]
   [cmap.lang :refer [de]]
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

(defn fromLonLat [[lon lat]] (.fromLonLat proj (clj->js [lon lat])))

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

(defn list-elem [set-view {:keys [k name addr coords]}]
  [:span {:key k :on-click (fn [e]
                             (set-view
                              ((comp
                                clj->js
                                (partial hash-map :zoom (+ 4 11) :center)
                                fromLonLat)
                               coords)))}
   [:div {:class (s/join " " ["association-entry" "ng-star-inserted"])}
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
      name]]]])

(defn tab1 [set-view db-vals]
  ((comp
    reagent/as-element
    (partial vector :div
             {:id "tab1-content"
              :class (s/join " " [
                                  (styles/tab-content)
                                  "ui"
                                  "attached"
                                  "segment"
                                  "active"
                                  "tab"])})
    #_(partial vector :div {:class "sidebar-content ng-tns-c14-0"})
    #_(partial vector :div {:class "association-entries ng-star-inserted"})
    (partial map (partial list-elem set-view)))
   db-vals))

(defn right [set-view db-vals]
  ((comp
    (partial vector :div {:id "right"} [:f> simple-example]))
   #_[:div (map (partial list-elem set-view) db-vals)]
   [Tab {:id "tab-panes"
         :panes
         [{:menuItem "Tab 1" :render
           (fn [] (tab1 set-view db-vals))}
          {:menuItem "Tab 2" :render
           (fn []
             ((comp
               reagent/as-element
               (partial vector :div {:class "ui attached segment active tab"})
               #_(partial take 3)
               (partial map (fn [[k v]] [:span {:key k} [:div v]])))
              db-vals))}
          #_{:menuItem "Tab 3" :render
             (when-let [db-associations
                        @(re-frame/subscribe [:db-associations])]
               (fn []
                 ((comp
                   reagent/as-element
                   (partial vector
                            :div {:class "ui attached segment active tab"})
                   (partial take 4)
                   (partial map (fn [[k v]] [:span {:key k} [:div v]])))
                  db-vals)))}]}]))

(defn popup
  "addr has only 'keine öffentliche Anschrift'"
  [{:keys [name addr districts email activities goals
           imageurl linkurl linktext]}]
  [:div
   #_{:class "on-top"
      :style "position: absolute; pointer-events: auto; transform: translate(-50%, -100%) translate(510px, 603px);"}
   [:div
    ;; _ngcontent-ugm-c34=""
    #_#_{:class "association-container osm-association-container"}
    [:a
     ;; _ngcontent-ugm-c34=""
     #_{:class "association-container-close-icon" :id "popup-close"
        :style "cursor: pointer;"}
     [:i #_{:class "pi pi-times"}]]
    [:div #_{:class "osm-association-inner-container"}
     [:div #_{:class "association-title"}
      [:h2 name]]
     [:div #_{:class "association-images"}
      [:div #_{:class "association-image"}
       [:img {:src imageurl :alt ""}]]]
     [:div #_{:class "association-address"}
      [:p #_{:class "name"} [:strong addr]]]
     [:div #_{:class "association-contacts"}
      [:div #_{:class "association-contact"}]
      [:div #_{:class "association-contact"}]
      [:div #_{:class "association-contact"}]
      [:div #_{:class "association-contact"}
       [:div #_{:class "association-contact"}
        [:div #_{:class "association-contact-row"}
         [:div #_{:class "social-media-icon mini-icon"}
          [:img {:src "assets/mail.png" :alt ""}]]
         [:p #_{:class "mail"}
          [:a {:href (str "mailto:" email)} email]]]]]]
     [:div #_{:class "association-description"}
      [:h3 (de :cmap.lang/goals)] goals]
     [:div #_{:class "association-description"}
      [:h3 (de :cmap.lang/activities)] activities]
     [:div #_{:class "association-active-in"}
      [:h3 (de :cmap.lang/activity-areas)]
      [:div #_{:class "association-chips-container"}
       (map-indexed (fn [idx elem]
                      (vector :div {:key idx} #_{:class "association-chips"}))
                    districts)]]
     [:div #_{:class "association-links"}
      [:h3 "Links"]
      [:ul
       [:li [:a {:href linkurl
                 :title linktext :target "_blank"}
             (if (empty? linktext) linkurl linktext)]]]]
     [:div #_{:class "association-social-media"}
      [:div #_{:class "social-media-link"}
       [:a {:href "https://www.facebook.com/adanetzwerk"
            :title (de :cmap.lang/facebook) :target "_blank"}
        [:div #_{:class "social-media-icon mini-icon"}
         [:img {:src "assets/facebook.png" :alt (de :cmap.lang/facebook)}]]]]
      [:div #_{:class "social-media-link"}
       [:a {:href "https://www.instagram.com/adanetzwerk/?hl=de"
            :title (de :cmap.lang/instagram) :target "_blank"}
        [:div #_{:class "social-media-icon mini-icon"}
         [:img {:src "assets/instagram.png" :alt (de :cmap.lang/instagram)}]]]]]]]])

(defn rlayers-map [view set-view db-vals ]
  ((comp
    (partial conj
             [RMap {:height "100%" :initial view :view [view set-view]}
              #_(let [this (reagent/current-component)]
                (js/console.log "this" this))
              [ROSM]])
    (partial into [RLayerVector {:zIndex 10}])
    (partial
     mapv (fn [{:keys [addr coords] :as prm}]
            [RFeature
             {:geometry (new geom/Point
                             (fromLonLat coords))}
             [RStyle
              [RIcon {:src
                      (str "/img/" (if (public-address? addr)
                                     "pub-addr.svg" "priv-addr.svg") )
                      :anchor [0.5 0.8]}]]
             ;; TODO RPopup toggle - i.e. max one popup can be displayed at the time
             [RPopup {:trigger "click" #_"hover"
                      :class [(styles/example-overlay)]}
              [:div {:class [(styles/card)]}
               [:div {:class [(styles/card-header)]}
                [popup prm]]
               #_[:p {:class "card-body text-center"} "Popup on click"]]]])))
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
      (partial into [:div {:class (styles/wrapper)}]))
     [
      [:div {:class [(styles/header)]} #_"header"]
      #_[:div {:class [(styles/left)]} #_"left"]
      [:div {:class [(styles/center)]} [:f> rlayers-map view set-view db-vals]]
      [:div {:class [(styles/right)]}  [right set-view db-vals]]
      [:div {:class [(styles/footer)]}
       (str @(re-frame/subscribe [::subs/name]) " v" config/version)]])))

(defn main-panel []
  (when-let [db-associations @(re-frame/subscribe [:db-associations])]
    [:f> go db-associations]))
