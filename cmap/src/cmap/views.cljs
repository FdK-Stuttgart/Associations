(ns cmap.views
  (:require
   [re-frame.core :as re-frame]
   [cmap.styles :as styles]
   [cmap.subs :as subs]
   [cmap.lang :refer [de]]
   [cmap.config :as config]
   [cmap.react-components :as rc]
   [reagent.core :as reagent]
   [reagent.dom :as rdom]
   [reagent.dom.server :as rserver]

   [reagent.impl.component :as ric]

   ["ol/proj" :as proj]
   ["ol/geom" :as geom]

   ["react-leaflet" :as rle]
   [oops.core :refer [oget oset! ocall oapply ocall! oapply!
                      oget+ oset!+ ocall+ oapply+ ocall!+ oapply!+]]

   ;; TODO use import instead of <link rel="stylesheet" ...>
   ;; ["semantic-ui-css/components/tab" :as csu]
   ;; ["ol/css" :as css]

   [clojure.string :as s]
   ;; ["react" :as react]

   [goog.string :as gstr]
   ))

(enable-console-print!)

(def cs  (atom nil))
(def js  (atom nil))
(def css (atom nil))

(def active-popup (reagent/atom nil))

(defn fromLonLat [[lon lat]] (.fromLonLat proj (clj->js [lon lat])))

;; TODO public-address? computation should be done elsewhere
(defn public-address? [norm-addr]
  (not (re-find #"(?i).*keine|Postfach.*" norm-addr)))


(defn list-elem
  [{:keys [k name addr coords] :as prm}]
  [:span {:key k :on-click (fn [e]
                             (js/console.log "list-elem - on-click current:"
                                             (:k @active-popup) "clicked:" k)
                             (swap! active-popup (fn [_]
                                                   (if (= (:k @active-popup) k)
                                                     nil
                                                     prm)))
                             #_(re-leaflet-update-markers  ))
          }
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

(defn tab1 [db-vals]
  ((comp
    reagent/as-element
    (partial vector :div
             {:id "tab1-content"
              :class (s/join " " [(styles/tab-content)
                                  "ui" "attached" "segment" "active" "tab"])})
    #_(partial vector :div {:class "sidebar-content ng-tns-c14-0"})
    #_(partial vector :div {:class "association-entries ng-star-inserted"})
    (partial map (partial list-elem)))
   db-vals))

(defn right [db-vals]
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
       (fn [] (tab1 db-vals))}
      {:menuItem "Tab 2" :render
       (fn []
         ((comp
           (partial tab1)
           (partial filter
                    (fn [m]
                      (subs/in?
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
              db-vals)))}]}]])

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
  [{:keys [k name addr street postcode-city districts email activities goals
           imageurl links socialmedia] :as prm}]
  [:div
   {:id k
    :class ["on-top" #_(styles/pos)]
    #_#_:style {:transform (str "translate(-50%, -" (translate name) "%)")}
    }
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
                        [:img (get-in social-media [sm-name :img])]]])])))
       (range (count (:ids socialmedia))))]]]])

(defonce app-state (atom {:markers-pta [{:name "Lucky's Deli"
                                         :lat 35.996834
                                         :long -78.904467
                                         :icon "green"}
                                        {:name "Bull City Burgers and Brewery"
                                         :lat 35.995602
                                         :long -78.899779
                                         :icon "green"}
                                        {:name "Béyu Café"
                                         :lat 35.996699
                                         :long -78.903862
                                         :icon "green"}
                                        {:name "M Sushi"
                                         :lat 35.997252
                                         :long -78.901172
                                         :icon "green"}
                                        {:name "M Tempura"
                                         :lat 35.996159
                                         :long -78.900400
                                         :icon "green"}]}))

(def markers-layer-atom (reagent/atom nil))

(defn re-leaflet-update-markers
  [mapatom markers]
  (let [mapinst @mapatom
        markerslayer (if (nil? @markers-layer-atom)
                       (js/L.layerGroup)
                       @markers-layer-atom)]
    (.clearLayers markerslayer)
    (doall
    (for [marker markers]
      (-> (js/L.marker
          (array
            (:lat marker)
            (:long marker))
          #js {:icon (case (:icon marker)
                       "dark" (js/L.icon (clj->js
                                          {:iconUrl
                                           "/icon/map_markers/dark_new.png"
                                           :iconSize [30 42]
                                           :iconAnchor [15 41]
                                           :popupAnchor [0 -31]}))
                       "red" (js/L.icon (clj->js
                                         {:iconUrl
                                          "/icon/map_markers/red_new.png"
                                          :iconSize [30 42]
                                          :iconAnchor [15 41]
                                          :popupAnchor [0 -31]}))
                       "orange" (js/L.icon (clj->js
                                            {:iconUrl
                                             "/icon/map_markers/orange_new.png"
                                             :iconSize [30 42]
                                             :iconAnchor [15 41]
                                             :popupAnchor [0 -31]}))
                       "green" (js/L.icon (clj->js
                                           {:iconUrl
                                            "/icon/map_markers/green_new.png"
                                            :iconSize [30 42]
                                            :iconAnchor [15 41]
                                            :popupAnchor [0 -31]}))
                       (js/L.icon (clj->js
                                   {:iconUrl
                                    "/icon/map_markers/green_new.png"
                                    :iconSize [30 42]
                                    :iconAnchor [15 41]
                                    :popupAnchor [0 -31]})))})
         (.addTo markerslayer)
         (.bindPopup
          (if @active-popup
            (rserver/render-to-string [popup @active-popup])
            (:name marker))))))
    (reset! markers-layer-atom markerslayer)
    (.addTo @markers-layer-atom mapinst)
    (reset! mapatom mapinst)))

(defn get-status-colour
  [status]
  (case status
    1 "#66B92E"
    0 "#66B92E"
    -1 "#DA932C"
    -2 "#D65B4A"
    "#657B93"))

;;; Map Component

(defn re-leaflet
  [params]
  (js/console.log "[re-leaflet] params" params)
  (let [dn (reagent/atom nil)
        mapatom (reagent/atom nil)
        mn (:mapname params)
        lt (:latitude params)
        lg (:longitude params)
        z (:zoom-level params)
        producer-markers (:markers params)]
    (reagent/create-class
     {:component-did-mount
      (fn [ref]
        (reset! dn (rdom/dom-node ref))
        (let [lmap (js/L.map @dn)
              mappositioned (-> lmap (.setView (array lt lg) z))]
          (.addTo (js/L.tileLayer
                   "https://{s}.tile.OpenStreetMap.org/{z}/{x}/{y}.png")
                  mappositioned)
          (reset! mapatom mappositioned)))
      :component-did-update
      (fn [this]
        (let [newparams (reagent/props this)
              lmap @mapatom
              mappositionednew (-> lmap
                                   (.panTo
                                    (array
                                     (:latitude newparams)
                                     (:longitude newparams))
                                    (:zoom-level newparams)))]
          (re-leaflet-update-markers mapatom (:markers params))
          (reset! mapatom mappositionednew)))
      :display-name (str "Leaflet Map - " mn)
      :reagent-render
      (fn [params]
        (when @mapatom
          (re-leaflet-update-markers mapatom (:markers params)))
        [:div {:style {:height (:height params)}}])})))

(defn center [db-vals]
  [:div#map {:style {:height "360px"}}
   [re-leaflet
    {:mapname "my=map"
     :latitude 35.99599
     :longitude -78.90131
     :zoom-level 17
     :height 650
     :markers (:markers-pta @app-state)}]])

(defn go [db-vals center-map]
  ((comp
    (partial into [:div {:class (styles/wrapper)}]))
   [[:div {:class [(styles/header)]} #_"header"]
    #_[:div {:class [(styles/left)]} #_"left"]
    [:div {:class [(styles/center)]} [center db-vals]]
    [:div {:class [(styles/right)]}  [right db-vals]]
    [:div {:class [(styles/footer)]}
     (str @(re-frame/subscribe [::subs/name]) " v" config/version)]]))

(defn main-panel []
  (when-let [db-associations @(re-frame/subscribe [:db-associations])]
    [:f> go db-associations @(re-frame/subscribe [:center-map])]))
