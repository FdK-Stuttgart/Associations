(ns cmap.views
  (:require
   [re-frame.core :as re-frame]
   [cmap.styles :as styles :refer [pxu]]
   [cmap.subs :as subs]
   [cmap.data :as data]
   [cmap.lang :refer [de]]
   [cmap.config :as config]
   [cmap.react-components :as rc]
   [reagent.core :as reagent]
   [reagent.dom :as rdom]
   [reagent.dom.server :as rserver]
   [reagent.impl.component :as ric]
   [clojure.string :as s] ;; for s/join
   [goog.string :as gstr]
   [cljs.pprint :as pp]
   ["react-leaflet" :as rle]
   ;; TODO use import instead of <link rel="stylesheet" ...>
   ;; ["semantic-ui-css/components/tab" :as csu]
   ;; ["react" :as react]
   ))

(enable-console-print!)

(defn popup
  "addr has only 'keine öffentliche Anschrift'"
  [{:keys [name addr street postcode-city districts email activities goals
           imageurl links socialmedia]}]
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
                         :title (get-in data/social-media [sm-name :title])}
                     [:div {:class "social-media-icon mini-icon"}
                      [:img (get-in data/social-media [sm-name :img])]]])])))
     (range (count (:ids socialmedia))))]])

(def markers-layer-atom (reagent/atom nil))

(defn update-markers [active map-atom db-vals]
  (let [map-instance @map-atom
        markers-layer (if (nil? @markers-layer-atom)
                        (js/L.layerGroup)
                        @markers-layer-atom)]
    ;; (js/console.log "[update-markers]")
    (.clearLayers markers-layer)
    (doall
     (for [marker db-vals]
       (do
         (let [[longitude latitude] (:coords marker)
               k (:k marker)
               ;; No need to recreate the whole map. It's enough to the
               ;; map-with-marker-and-popup as a function parameter and
               ;; call .openPopup / .closePopup
               map-with-marker-and-popup
               (-> (js/L.marker
                    (array latitude longitude)
                    #js {:icon (js/L.icon (clj->js
                                           {:iconUrl
                                            "/icon/map_markers/green_new.png"
                                            :iconSize [30 42]
                                            :iconAnchor [15 41]
                                            :popupAnchor [0 -31]}))})
                   (.on "click" (fn [_]
                                  (reset! active (if (= @active k) nil k))))
                   (.addTo markers-layer)
                   (.bindPopup (rserver/render-to-string [popup marker])))]
           (if (= k @active)
             (.openPopup map-with-marker-and-popup)
             map-with-marker-and-popup)))))
    (reset! markers-layer-atom markers-layer)
    (.addTo @markers-layer-atom map-instance)
    (reset! map-atom map-instance)))

;; TODO public-address? computation should be done elsewhere.
(defn public-address? [norm-addr]
  (not (re-find #"(?i).*keine|Postfach.*" norm-addr)))

(defn list-elem [active map db-vals pi-icon {:keys [k name addr coords]}]
  [:span {:key k
          :on-click (fn [e]
                      ;; (js/console.log "on-click" "old-active" @active "k" k)
                      (reset! active (if (= @active k) nil k))
                      ;; (js/console.log "on-click" "new-active" @active)
                      (update-markers active map db-vals))}
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
       ["icon-padding" "pi" pi-icon "ng-star-inserted"])
      name]]]])

(defn tab1 [active map-atom db-vals]
  ((comp
    reagent/as-element
    (partial vector :div
             {:id "tab1-content"
              :class (s/join " " [(styles/tab-content)
                                  "ui" "attached" "segment" "active" "tab"])})
    #_(partial vector :div {:class "sidebar-content ng-tns-c14-0"})
    #_(partial vector :div {:class "association-entries ng-star-inserted"})
    (partial map (partial apply (partial list-elem active map-atom db-vals))
             #_(fn [[m dbv]] (list-elem active map-atom db-vals m dbv)))
    doall
    (partial map (fn [{:keys [k] :as db-val}]
                   [(if (= @active k)
                      "pi-map"        ;; the map icon
                      "pi-map-marker" ;; the pointy-ball icon
                      )
                    db-val])))
   db-vals))

(defn right [active map-atom db-vals]
  [:div
   [:div.color-input
    [:input {:type "text"
             ;; :value time-color
             :placeholder (de :cmap.lang/search-hint)
             :on-change (comp
                         (fn [x] (js/console.log
                                  (gstr/format "new-val: '%s'" x)))
                         (fn [x] (.-value x))
                         (fn [x] (.-target x)))}]]
   [rc/Tab
    {:id "tab-panes"
     :panes
     [{:menuItem "Tab 1" :render
       (fn [] (tab1 active map-atom db-vals))}
      {:menuItem "Tab 2" :render
       (fn []
         ((comp
           (partial tab1 active map-atom)
           (partial filter
                    (fn [m]
                      (subs/in?
                       ["Kalimera Deutsch-Griechische Kulturinitiative"
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
              db-vals)))}]}]])

;; TODO better transform & translate. E.g. in the class
(defn translate [name]
  (or (get
       {
        #_"Kalimera Deutsch-Griechische Kulturinitiative"
        "Afro Deutsches Akademiker Netzwerk ADAN" 106
        "Africa Workshop Organisation" 108
        }
       name)
      105))

(defn map-with-list [params db-vals center-map]
  (let [active (reagent/atom nil)
        map-atom (reagent/atom nil)
        [lng lat] center-map
        zoom 17]
    (reagent/create-class
     {:component-did-mount
      (fn [ref]
        #_(js/console.log "[: did-mount]" "ref" ref)
        (let [node-ref       (-> ref rdom/dom-node)
              node-header    (.item (-> node-ref .-children) 0)
              node-center    (.item (-> node-ref .-children) 1)
              node-footer    (.item (-> node-ref .-children) 2)]
          (let [node-map-style (-> node-center .-children first .-style)]
            (set! (-> node-map-style .-width)
                  (str (.-clientWidth node-center) pxu))
            #_
            (js/console.log "[: did-mount]"
                            "(.-clientHeight node-ref)" (.-clientHeight node-ref)
                            "(.-clientHeight node-header)" (.-clientHeight node-header)
                            "(.-clientHeight node-center)" (.-clientHeight node-center)
                            "(.-clientHeight node-footer)" (.-clientHeight node-footer))
            (set! (-> node-map-style .-height)
                  (str (- (.-clientHeight node-center)
                          ;; '* 2' b/c padding top and bottom is the same
                          (* 2 styles/padding)) pxu)))
          (let [leaflet-map (-> node-center .-children first js/L.map)]
            (reset! map-atom leaflet-map)
            (.setView leaflet-map (array lat lng) zoom)
            (.on leaflet-map "click" (fn [_]
                                       (when @active
                                         (reset! active nil))))
            (.addTo (js/L.tileLayer
                     "https://{s}.tile.OpenStreetMap.org/{z}/{x}/{y}.png")
                    leaflet-map))))
      :component-did-update
      (fn [this]
        ;; (js/console.log "[: did-update]"
        ;;                 "this" this ".-props" (.-props this))
        #_
        (let [new-params (.-props this) ;; (reagent/props this) is always {}
              ;; here I may need to get the values from the new-params to
              ;; reposition the map
              leaflet-map (-> @map-atom
                              (.panTo (array lat lng) zoom))]
          (update-markers active map-atom db-vals)
          (reset! map-atom leaflet-map)))
      :display-name "My Leaflet Map"
      :reagent-render
      ;; params is {}; (reagent/props params) throws error;
      ;; (.-props params) is undefined
      (fn [params]
        ;; (js/console.log "[:reagent-render]")
        (when @map-atom
          (update-markers active map-atom db-vals))
        [:div
         {:class (styles/wrapper)}
         ;; 'header' must be displayed so that the ':grid-template-rows ...'
         ;; kicks in and the height of the 'center' is maximized
         [:div {:class [(styles/header)]} #_"header"]
         #_[:div {:class [(styles/left)]} #_"left"]
         [:div {:class [(styles/center)]} #_"center"
          [:div#map {:style {:height 0 :width 0}}]]
         [:div {:class [(styles/right)]} (right active map-atom db-vals)]
         [:div {:class [(styles/footer)]}
          (str @(re-frame/subscribe [::subs/name])
               " v"
               ;; output of `git describe --tags --dirty=-SNAPSHOT`
               ;; See :shadow-git-inject/version
               config/version)]])})))

(defn main-panel []
  (when-let [db-associations @(re-frame/subscribe [:db-associations])]
    [map-with-list {} db-associations @(re-frame/subscribe [:center-map])]))
