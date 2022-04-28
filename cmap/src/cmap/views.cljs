(ns cmap.views
  (:require
   [re-frame.core :as re-frame]
   [cmap.styles :as styles]
   [cmap.subs :as subs]
   [cmap.lang :refer [de]]
   [cmap.config :as config]
   [cmap.react-components :as rc]
   [reagent.core :as reagent]

   [reagent.impl.component :as ric]

   ["ol/proj" :as proj]
   ["ol/geom" :as geom]

   ;; TODO use import instead of <link rel="stylesheet" ...>
   ;; ["semantic-ui-css/components/tab" :as csu]
   ;; ["ol/css" :as css]

   [clojure.string :as s]
   ["react" :as react]
   ))

(enable-console-print!)

(def cs  (atom nil))
(def js  (atom nil))
(def css (atom nil))

(defn fromLonLat [[lon lat]] (.fromLonLat proj (clj->js [lon lat])))

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

(defn full-search []
  (let [[time-color update-time-color] (react/useState
                                        ;; #00ff00
                                        "#f34")]
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
      [:input {:type "text"
               ;; :value time-color
               :placeholder (de :cmap.lang/search-hint)
               :on-change (comp
                           update-time-color
                           (fn [x] (.-value x))
                           (fn [x] (.-target x)))}]]]))

(defn list-elem
  "set-view is determined by react/useState"
  [set-view {:keys [k name addr coords]}]
  #_(.log js/console "set-view" set-view)
  [:span {:key k :on-click (fn [e]
                             ((comp
                               set-view
                               clj->js
                               (partial hash-map :zoom (+ 4 11) :center)
                               fromLonLat)
                              coords))}
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
              :class (s/join " " [(styles/tab-content)
                                  "ui" "attached" "segment" "active" "tab"])})
    #_(partial vector :div {:class "sidebar-content ng-tns-c14-0"})
    #_(partial vector :div {:class "association-entries ng-star-inserted"})
    (partial map (partial list-elem set-view)))
   db-vals))

(defn right [set-view set-state db-vals]
  ((comp
    (partial vector :div {:id "btn"}
             [:button
              {:on-click
               (fn [e] ((comp set-state
                              #_clj->js) {:trigger "hover"}))}
              "test"])
    (partial vector :div {:id "full-search"} [:f> full-search]))
   #_[:div (map (partial list-elem set-view) db-vals)]
   [rc/Tab
    {:id "tab-panes"
     :panes
     [{:menuItem "Tab 1" :render
       (fn [] (tab1 set-view db-vals))}
      {:menuItem "Tab 2" :render
       (fn []
         ((comp
           (partial tab1 set-view)
           (partial filter (fn [m] (subs/in?
                                    ["Kalimera e. V. Deutsch-Griechische Kulturinitiative"
                                     "Afro Deutsches Akademiker Netzwerk ADAN"
                                     "Schwedischer Schulverein Stuttgart"]
                                    (:name m))))
           #_(partial take 2))
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

;; TODO better transform & translate. E.g. in the class
(defn translate [name]
  (or (get
       {
        #_"Kalimera e. V. Deutsch-Griechische Kulturinitiative"
        "Afro Deutsches Akademiker Netzwerk ADAN" 106
        "Africa Workshop Organisation" 108
        }
       name)
      105))

(def social-media
  {"YouTube"   {:title (de :cmap.lang/youtube)
                :img {:src "assets/youtube.png"
                      :alt (de :cmap.lang/youtube)}}
   "LinkedIn" {:title (de :cmap.lang/linkedin)
               :img {:src "assets/linkedin.png"
                     :alt (de :cmap.lang/linkedin)}}
   "Messenger" {:title (de :cmap.lang/messenger)
                :img {:src "assets/messenger.png"
                      :alt (de :cmap.lang/messenger)}}
   "Snapchat" {:title (de :cmap.lang/snapchat)
               :img {:src "assets/snapchat.png"
                     :alt (de :cmap.lang/snapchat)}}
   "Twitter" {:title (de :cmap.lang/twitter)
              :img {:src "assets/twitter.png"
                    :alt (de :cmap.lang/twitter)}}
   "WhatsApp" {:title (de :cmap.lang/whatsapp)
               :img {:src "assets/whatsapp.png"
                     :alt (de :cmap.lang/whatsapp)}}
   "Facebook"  {:title (de :cmap.lang/facebook)
                :img {:src "assets/facebook.png"
                      :alt (de :cmap.lang/facebook)}}

   "Instagram" {:title (de :cmap.lang/instagram)
                :img {:src "assets/instagram.png"
                      :alt (de :cmap.lang/instagram)}}})
(defn popup
  "addr has only 'keine öffentliche Anschrift'"
  [idx {:keys [name addr street postcode-city districts email activities goals
               imageurl links socialmedia] :as prm}]
  (let [c (reagent/current-component)]
    #_(js/console.log "c" c))
    [:div
     {:id (str "p" idx)
      :class ["on-top" #_(styles/pos)]
      :style {:transform (str "translate(-50%, -" (translate name) "%)")}}
     [:div {:class "association-container osm-association-container"}
      [:a {:class "association-container-close-icon" :id "popup-close"}
       [:i {:class "pi pi-times"}]]
      [:div {:class "osm-association-inner-container"}
       [:div {:class "association-title"} [:h2 name]]
       [:div {:class "association-images"}
        [:div {:class "association-image"}
         [:img {:src imageurl :alt ""}]]]
       [:div {:class "association-address"}
        [:p {:class "street"} street]
        [:p {:class "postcode-city"} postcode-city]
        [:p {:class "name"} [:strong addr]]]
       [:div {:class "association-contacts"}
        [:div {:class "association-contact"}
         [:div {:class "association-contact"}
          [:div {:class "association-contact-row"}
           [:div {:class "social-media-icon mini-icon"}
            [:img {:src "assets/mail.png" :alt ""}]]
           [:p {:class "mail"}
            [:a {:href (str "mailto:" email)} email]]]]]]
       [:div {:class "association-description"}
        [:h3 (de :cmap.lang/goals)] goals]
       [:div {:class "association-description"}
        [:h3 (de :cmap.lang/activities)] activities]
       [:div {:class "association-active-in"}
        [:h3 (de :cmap.lang/activity-areas)]
        [:div {:class "association-chips-container"}
         (map-indexed (fn [idx elem]
                        (vector :div (conj {:key idx}
                                           {:class "association-chips"})
                                elem))
                      districts)]]
       [:div {:class "association-links"}
        [:h3 (de :cmap.lang/links)]
        [:ul (map (fn [idx url text]
                    [:li {:key idx} [:a {:href url :title text :target "_blank"}
                                     (if (empty? text) url text)]])
                  (range (count (:url links))) (:url links) (:text links))]]
       [:div {:class "association-social-media"}
        ((comp
          (partial map
                   (fn [idx]
                     [:div {:key idx :class "social-media-link"}
                      (let [sm-name (nth (get socialmedia :platforms) idx)]
                        [:a {:href (nth (get socialmedia :urls) idx)
                             :target "_blank"
                             :title (get-in social-media [sm-name :title])}
                         [:div {:class "social-media-icon mini-icon"}
                          [:img (get-in social-media [sm-name :img])]]])]))
          )
         (range (count (:ids socialmedia))))]]]]
  )

(defn feature [idx state {:keys [addr coords] :as prm}]
  (js/console.log "feature state" state)
  [rc/RFeature
   {:geometry (new geom/Point (fromLonLat coords))
    :on-click (fn [e]
                #_(.log js/console "rc/RFeature on-click" e)
                #_
                (let [p (-> js/document
                            (.getElementById (str "p" idx))
                            (.-parentNode)
                            (.-parentNode))
                      c (-> js/window (.getComputedStyle p nil))]
                  (.log js/console "rc/RFeature on-click"
                        c (-> c (.getPropertyValue "-webkit-transform"))
                        (-> c (.getPropertyValue "height")))))}
   [rc/RStyle
    [rc/RIcon
     {#_#_:on-click (fn [e] (.log js/console "rc/RIcon on-click" e))
      :src
      (str "/img/" (if (public-address? addr)
                     "pub-addr.svg" "priv-addr.svg") )
      :anchor [0.5 0.8]}]]
   ;; TODO rc/RPopup toggle - i.e. max one popup can be displayed at the time
   [rc/RPopup state
    [popup idx prm]]])

(defn rlayers-map [view set-view state db-vals]
  ((comp
    (partial conj
             [rc/RMap
              {:height "100%" :initial view :view [view set-view]}
              #_(let [this (reagent/current-component)]
                  (js/console.log "this" this))
              [rc/ROSM]])
    (partial into [rc/RLayerVector {:zIndex 10}])
    (partial map-indexed (fn [i v] (feature i state v))))
   db-vals))

(defn go [db-vals center-map]
  ((comp
    (partial into [:div {:class (styles/wrapper)}]))
   (let [[view set-view] ((comp
                           react/useState
                           clj->js
                           (partial hash-map :zoom 11 :center)
                           fromLonLat)
                          center-map)
         [state set-state] ((comp react/useState
                                  #_clj->js) {:trigger "click" #_"hover"})
         center [:f> rlayers-map view set-view state db-vals]
         ]
     [[:div {:class [(styles/header)]} #_"header"]
      #_[:div {:class [(styles/left)]} #_"left"]
      [:div {:class [(styles/center)]} center]
      [:div {:class [(styles/right)]}  [right set-view set-state db-vals]]
      [:div {:class [(styles/footer)]}
       (str @(re-frame/subscribe [::subs/name]) " v" config/version)]])))

(defn main-panel []
  (when-let [db-associations @(re-frame/subscribe [:db-associations])]
    [:f> go db-associations @(re-frame/subscribe [:center-map])]))
