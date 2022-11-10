(ns cmap.views
  (:require
   [re-frame.core :as re-frame]
   [cmap.styles :as styles]
   [cmap.subs :as subs]
   [cmap.data :as data]
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
   [cljs.pprint :as pp]
   ))

(enable-console-print!)


(defn popup
  "addr has only 'keine öffentliche Anschrift'"
  [{:keys [k name addr street postcode-city districts email activities goals
           imageurl links socialmedia] :as prm}]
  #_
  (js/console.log
   (pp/pprint
    (select-keys prm [:k :name :addr :street :postcode-city :districts :email
                      :activities :goals :imageurl :links :socialmedia])))
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
                           :title (get-in data/social-media [sm-name :title])}
                       [:div {:class "social-media-icon mini-icon"}
                        [:img (get-in data/social-media [sm-name :img])]]])])))
       (range (count (:ids socialmedia))))]]]])

(def markers-layer-atom (reagent/atom nil))
;; Reload webpage when changed
(defonce app-state (atom data/leaflet-data))

(defn re-leaflet-update-markers [active mapatom markers]
  (let [mapinst @mapatom
        markerslayer (if (nil? @markers-layer-atom)
                       (js/L.layerGroup)
                       @markers-layer-atom)]
    #_(js/console.log "[re-leaflet-update-markers]" "markerslayer" markerslayer)
    #_(js/console.log "[re-leaflet-update-markers]" "mapinst" mapinst)
    #_(js/console.log "[re-leaflet-update-markers]" "markers" markers)
    #_(.clearLayers markerslayer)
    (doall
     (for [marker markers]
       (do
         (let [map-with-marker-and-popup
               (-> (js/L.marker
                    (array (:lat marker) (:long marker))
                    #js {:icon (js/L.icon (clj->js
                                           {:iconUrl
                                            "/icon/map_markers/green_new.png"
                                            :iconSize [30 42]
                                            :iconAnchor [15 41]
                                            :popupAnchor [0 -31]}))})
                   (.addTo markerslayer)
                   (.bindPopup
                    (rserver/render-to-string [popup (:prm marker)])))]
           #_
           (js/console.log "active" @active "open-popup?"
                           (-> marker :prm :k) (= (-> marker :prm :k) @active))
           (if (= (-> marker :prm :k) @active)
             (.openPopup map-with-marker-and-popup)
             map-with-marker-and-popup)))))
    (reset! markers-layer-atom markerslayer)
    (.addTo @markers-layer-atom mapinst)
    (reset! mapatom mapinst)))

(defn fromLonLat [[lon lat]] (.fromLonLat proj (clj->js [lon lat])))

;; TODO public-address? computation should be done elsewhere
(defn public-address? [norm-addr]
  (not (re-find #"(?i).*keine|Postfach.*" norm-addr)))

(defn list-elem [active mapatom markers {:keys [k name addr coords] :as prm}]
  [:span {:key k :on-click (fn [e]
                             (js/console.log "on-click" "old-active" @active "k" k)
                             (reset! active (if (= @active k) nil k))
                             (js/console.log "on-click" "new-active" @active)
                             (re-leaflet-update-markers active mapatom markers)
                             )}
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

(defn tab1 [active mapatom markers db-vals]
  ((comp
    reagent/as-element
    (partial vector :div
             {:id "tab1-content"
              :class (s/join " " [(styles/tab-content)
                                  "ui" "attached" "segment" "active" "tab"])})
    #_(partial vector :div {:class "sidebar-content ng-tns-c14-0"})
    #_(partial vector :div {:class "association-entries ng-star-inserted"})
    (partial map (partial list-elem active mapatom markers)))
   db-vals))

(defn right [active mapatom markers db-vals]
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
       (fn [] (tab1 active mapatom markers db-vals))}
      {:menuItem "Tab 2" :render
       (fn []
         ((comp
           (partial tab1 active mapatom markers)
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

(defn center [active db-vals]
  #_(js/console.log "[center]" "active" active)
  (let [
        dn (reagent/atom nil)
        mapatom (reagent/atom nil)
        params
        {:active active
         :mapname "my=map"
         :latitude 35.99599
         :longitude -78.90131
         :zoom-level 17
         :height 650
         :markers (:markers-pta @app-state)}
        mn (:mapname params)
        lt (:latitude params)
        lg (:longitude params)
        z (:zoom-level params)
        producer-markers (:markers params)]
    (reagent/create-class
     {:component-did-mount
      (fn [ref] ;; originally ref
        #_(js/console.log ":component-did-mount" "ref" ref)
        (let [node-ref       (-> ref rdom/dom-node)
              node-center    (-> node-ref .-children first)
              node-map       (-> node-center .-children first)
              node-map-style (-> node-center .-children first .-style)]
          (set! (-> node-map-style .-width) (str (.-clientWidth node-center) "px"))
          (set! (-> node-map-style .-height) (str (.-clientHeight node-ref) "px"))
          (reset! dn node-map))
        (let [lmap (js/L.map @dn)
              mappositioned (-> lmap (.setView (array lt lg) z))
              tl (-> (js/L.tileLayer
                              "https://{s}.tile.OpenStreetMap.org/{z}/{x}/{y}.png"))]
          (.addTo tl mappositioned)
          (reset! mapatom mappositioned)))
      :component-did-update
      (fn [this]
        #_(js/console.log ":component-did-update" "this" this)
        (let [newparams (reagent/props this)
              lmap @mapatom
              mappositionednew (-> lmap
                                   (.panTo
                                    (array
                                     lt #_(:latitude newparams)
                                     lg #_(:longitude newparams))
                                    (:zoom-level newparams)))]
          (re-leaflet-update-markers active mapatom (:markers params))
          (reset! mapatom mappositionednew)))
      ;; :display-name (str "Leaflet Map - " mn)
      :reagent-render
      (fn [params]
        #_(js/console.log "params" params)
        (when @mapatom
          (re-leaflet-update-markers active mapatom (:markers params)))
        [:div
         {:class (styles/wrapper)}
         #_[:div {:class [(styles/header)]} #_"header"]
         #_[:div {:class [(styles/left)]} #_"left"]
         [:div {:class [(styles/center)]}
          [:div#map {:style {:height 0 :width 0}}]]
         [:div {:class [(styles/right)]} [right active db-vals]]
         #_[:div {:class [(styles/footer)]}
            (str @(re-frame/subscribe [::subs/name]) " v" config/version)]])})))

(defn go [db-vals center-map]
  (fn [params]
    (let [
          active (reagent/atom nil)
          dn (reagent/atom nil)
          mapatom (reagent/atom nil)
          params {:active active
                  :mapname "my=map"
                  :latitude 35.99599
                  :longitude -78.90131
                  :zoom-level 17
                  :height 650
                  :markers (:markers-pta @app-state)}
          mn (:mapname params)
          lt (:latitude params)
          lg (:longitude params)
          z (:zoom-level params)
          markers (:markers params)]
      (reagent/create-class
       {:component-did-mount
        (fn [ref] ;; originally ref
          #_(js/console.log ":component-did-mount" "ref" ref)
          (let [node-ref       (-> ref rdom/dom-node)
                node-center    (-> node-ref .-children first)
                node-map       (-> node-center .-children first)
                node-map-style (-> node-center .-children first .-style)]
            (set! (-> node-map-style .-width) (str (.-clientWidth node-center) "px"))
            (set! (-> node-map-style .-height) (str (.-clientHeight node-ref) "px"))
            (reset! dn node-map))
          (let [lmap (js/L.map @dn)
                mappositioned (-> lmap (.setView (array lt lg) z))
                tl (-> (js/L.tileLayer
                        "https://{s}.tile.OpenStreetMap.org/{z}/{x}/{y}.png"))]
            (.addTo tl mappositioned)
            (reset! mapatom mappositioned)))
        :component-did-update
        (fn [this]
          #_(js/console.log ":component-did-update" "this" this)
          (let [newparams (reagent/props this)
                lmap @mapatom
                mappositionednew (-> lmap
                                     (.panTo
                                      (array
                                       lt #_(:latitude newparams)
                                       lg #_(:longitude newparams))
                                      (:zoom-level newparams)))]
            (re-leaflet-update-markers active mapatom markers)
            (reset! mapatom mappositionednew)))
        :display-name (str "Leaflet Map - " mn)
        :reagent-render
        (fn [params]
          #_(js/console.log "params" params)
          (when @mapatom
            (re-leaflet-update-markers active mapatom markers))
          [:div
           {:class (styles/wrapper)}
           #_[:div {:class [(styles/header)]} #_"header"]
           #_[:div {:class [(styles/left)]} #_"left"]
           [:div {:class [(styles/center)]}
            [:div#map {:style {:height 0 :width 0}}]]
           [:div {:class [(styles/right)]} [right active mapatom markers db-vals]]
           [:div {:class [(styles/footer)]}
            (str @(re-frame/subscribe [::subs/name])
                 " v"
                 ;; output of `git describe --tags --dirty=-SNAPSHOT`
                 ;; See :shadow-git-inject/version
                 config/version)]])}))))

(defn main-panel []
  (when-let [db-associations @(re-frame/subscribe [:db-associations])]
    [:f> go db-associations @(re-frame/subscribe [:center-map])]))
