(ns fdk.cmap.views
  (:require
   [re-frame.core :as re-frame]
   [fdk.cmap.styles :as styles :refer [pxu]]
   [fdk.cmap.subs :as subs]
   [fdk.cmap.data :as data]
   [fdk.cmap.lang :refer [de]]
   [fdk.cmap.config :as config]
   [fdk.cmap.react-components :as rc]
   [reagent.core :as reagent]
   [reagent.dom :as rdom]
   [reagent.dom.server :as rserver]
   [reagent.impl.component :as ric]
   [clojure.string :as s] ;; for s/join
   [goog.string :as gstr]
   [cljs.pprint :as pp]
   ["react-leaflet" :as rle]
   ["leaflet.markercluster"]
   ;; TODO use import instead of <link rel="stylesheet" ...>
   ;; ["semantic-ui-css/components/tab" :as csu]
   ["react" :as react]
   ))

(enable-console-print!)

(declare update-markers)
(declare click-on-association)

(def markers-layer-atom (reagent/atom nil))
(def db-vals-atom (reagent/atom nil))
(def db-vals-init-atom (reagent/atom nil))
(def map-atom (reagent/atom nil))
(def active-atom (reagent/atom nil))
(def pattern-atom (reagent/atom nil))

(def zoom 17)

(defn mark-string [s]
  (if-let [pattern-orig @pattern-atom]
    (let [pattern (s/lower-case pattern-orig)]
      ((comp
        (partial remove empty?)
        (partial map (fn [el] (if (= (s/lower-case el) pattern)
                                [:mark el]
                                el)))
        (partial s/split s)
        ;; i - case insensitive, u - unicode
        (fn [regex] (js/RegExp. regex "iu"))
        (partial gstr/format "(%s)"))
       pattern))
    s))

(defn popup-content
  "addr has only 'keine öffentliche Anschrift'
  (popup-content prm)
  "
  [{:keys [k name addr street postcode-city districts email activities goals
           imageurl links socialmedia] :as prm}]
  (when (=
         ;; Deutsch-Türkisches Forum Stuttgart
         ;; "85e9a6f1-1688-490d-abd8-e5310b351df6"
         ;; "Afro Deutsches Akademiker Netzwerk ADAN"
         "a4be69a3-e758-456c-a6e2-f207c8df1a94"
         k)
    #_(.log js/console "links" links))
  [:div
   {:class
         "association-container osm-association-container"
         #_"association-container"
         #_"osm-association-container"
    }
   [:div {:class "osm-association-inner-container"}
    [:div {:class "association-title"} (into [:h2] (mark-string name))]
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
     [:h3 (de :fdk.cmap.lang/goals)] goals]
    [:div {:class "association-description"}
     [:h3 (de :fdk.cmap.lang/activities)] activities]
    [:div {:class "association-active-in"}
     [:h3 (de :fdk.cmap.lang/activity-areas)]
     [:div {:class "association-chips-container"}
      (map-indexed (fn [idx elem]
                     (vector :div (conj {:key idx}
                                        {:class "association-chips"})
                             elem))
                   districts)]]
    [:div {:class "association-links"}
     [:h3 (de :fdk.cmap.lang/links)]
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
      (range (count (:ids socialmedia))))]]]
#_
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
    [:h3 (de :fdk.cmap.lang/goals)] goals]
   [:div {:class "association-description"}
    [:h3 (de :fdk.cmap.lang/activities)] activities]
   [:div {:class "association-active-in"}
    [:h3 (de :fdk.cmap.lang/activity-areas)]
    [:div {:class "association-chips-container"}
     (map-indexed (fn [idx elem]
                    (vector :div (conj {:key idx}
                                       {:class "association-chips"})
                            elem))
                  districts)]]
   [:div {:class "association-links"}
    [:h3 (de :fdk.cmap.lang/links)]
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

(defn public-address?
  "TODO public-address? computation should be done elsewhere."
  [norm-addr]
  (not (re-find #"(?i).*keine|Postfach.*" norm-addr)))

(def cluster-config
  #js {
       :disableClusteringAtZoom 17
       #_#_
       :iconCreateFunction
       (fn [cluster]
         (js/L.divIcon
          #js
          {:html (rserver/render-to-string [:b (.getChildCount cluster)])
           :className "marker-cluster-small"
           :iconSize (new js/L.Point 40 40)}))})

;; TODO keep the popup opened when zooming out
;; TODO popup 'Afro Deutsches Akademiker Netzwerk ADAN': repeating links
(defn update-markers
  "Executed 2x with react/StrictMode and 3x w/o react/StrictMode"
  [re-zoom]
  (let [active @active-atom
        map-instance @map-atom
        db-vals @db-vals-atom
        markers-layer (or @markers-layer-atom
                          (js/L.markerClusterGroup cluster-config))]
    #_
    (.on markers-layer "clusterclick"
         (fn [c]
           (js/console.log "clusterclick"
                           (-> c .-layer .getAllChildMarkers .-length))))
    (doall
     (for [marker-data db-vals]
       (let [[longitude latitude] (:coords marker-data)
             k (:k marker-data)
             click-on-association-k (click-on-association k)
             marker
;;; No need to recreate the whole map. It's enough to call the marker as a
;;; function parameter and call .openPopup / .closePopup
             (-> (js/L.marker
                  (array latitude longitude)
                  #js {:title (:name marker-data)
                       :icon
                       (js/L.icon
                        (clj->js
                         {:iconUrl
                          (if (public-address? (:addr marker-data))
                            "/icon/map_markers/pinActivePublic.png"
                            "/icon/map_markers/pinActivePrivate.png")
                          :iconSize [30 42]
                          :iconAnchor [15 41]
                          :popupAnchor [0 -31]}))})
                 (.addTo markers-layer)
                 (.on "click" click-on-association-k))]
         (when (=
                ;; Deutsch-Türkisches Forum Stuttgart
                ;; "85e9a6f1-1688-490d-abd8-e5310b351df6"
                ;; "Afro Deutsches Akademiker Netzwerk ADAN"
                "a4be69a3-e758-456c-a6e2-f207c8df1a94"
                k)
           (js/console.log "active" active "openPopup" (= k active)))
         (when (= k active)
           (.setView map-instance (array latitude longitude) zoom)
           (.bindPopup marker (js/L.popup
                               #js {:content (rserver/render-to-string
                                              [popup-content marker-data])}))
           (.openPopup marker)))))

    (reset! markers-layer-atom markers-layer)
    (.addTo @markers-layer-atom map-instance)))

(defn click-on-association [k]
  (fn [_]
    (let [old-active @active-atom]
      #_(js/console.log "on-click" "old-active" old-active "k" k)
      (js/console.log "markers-layer" "click" "active" @active-atom)
      (reset! active-atom k)
      #_(println "on-click" "new-active" @active-atom)
      (let [re-zoom (and @active-atom (not= old-active @active-atom))]
        #_(println "on-click" "re-zoom" re-zoom)
        (update-markers re-zoom)))))

(defn list-elem [pi-icon {:keys [k name addr coords]}]
  [:span {:key k :on-click (click-on-association k)}
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

(defn tab1 [db-vals]
  (let [active @active-atom]
    ((comp
      reagent/as-element
      (partial vector :div
               {:id "tab1-content"
                :class (s/join " " [(styles/tab-content)
                                    "ui" "attached" "segment" "active" "tab"])})
      #_(partial vector :div {:class "sidebar-content ng-tns-c14-0"})
      #_(partial vector :div {:class "association-entries ng-star-inserted"})
      (partial map (partial apply (partial list-elem)))
      doall
      (partial map (fn [{:keys [k] :as db-val}]
                     [(if (= active k)
                        "pi-map"        ;; the map icon
                        "pi-map-marker" ;; the pointy-ball icon
                        )
                      db-val])))
     db-vals)))

(defn filter-db-vals
  "Return a list of pattern-filtered db-vals."
  [pattern]
  (let [match-indexes
        ((comp
          (partial
           map
           (fn [db-val]
             ((comp
               (fn [r] (when r true)) ;; (when r db-val)
               (partial some (fn [v] (s/includes? v pattern)))
               (partial map (comp s/lower-case s/trim))
               (partial remove s/blank?)
               vals
               (fn [v]
                 (select-keys v
                              [
                               :name
                               ;; :shortName

                               ;; :addr
                               :street
                               :postcode-city
                               :city
                               :country

                               :goals
                               :activities

                               ;; :contacts    ;; :name :pobox :phone :fax :email
                               :email

                               ;; :imageurl    ;; :url :alttext
                               ;; :links       ;; :url :linkText
                               ;; :socialmedia ;; :url :linkText :platform

                               ;; :districts   ;; TODO
                               ])))
              db-val))))
         @db-vals-init-atom)]
;;; `match-indexes` contains e.g. `[nil nil true nil nil]`. I.e. if an element
;;; is true it means a corresponding element `@db-vals-atom` should belong to
;;; the result. This filtering can't be done above. `(when r db-val)` doesn't
;;; work. I guess the value of `db-val` gets somehow altered.
    ((comp
      (partial remove nil?)
      (partial map (fn [m v] (when m v))))
     match-indexes @db-vals-init-atom)))

(defn tab-panes [db-vals]
  [rc/Tab
   {:id "tab-panes"
    :panes
    [
     (let [tab-items      db-vals
           tab-items-init @db-vals-init-atom]
       {:menuItem
        (str (de :fdk.cmap.lang/associations-tab-name)
             (let [count-vals      (count tab-items)
                   count-vals-init (count tab-items-init)]
               (when-not (= count-vals count-vals-init)
                 (gstr/format " (%s/%s)" count-vals count-vals-init))))
        :render (fn [] (tab1 db-vals))})

     (let [tab-items
           ((comp
             (partial filter
                      (fn [m]
                        (subs/in?
                         ["Kalimera Deutsch-Griechische Kulturinitiative"
                          #_"Afro Deutsches Akademiker Netzwerk ADAN"
                          "Schwedischer Schulverein Stuttgart"]
                         (:name m))))
             #_(partial take 2))
            db-vals)

           tab-items-init tab-items
           ]
       {:menuItem
        (str (de :fdk.cmap.lang/rooms-tab-name)
             (let [count-vals      (count tab-items)
                   count-vals-init (count tab-items-init)]
               (when-not (= count-vals count-vals-init)
                 (gstr/format " (%s/%s)" count-vals count-vals-init))))
        :render
        (fn []
          ((comp
            (partial tab1)
            #_(partial take 2))
           tab-items))})]}])

(defn right []
  [:div
   [:div.color-input
    [:input {:type "text"
             ;; :value time-color
             :placeholder (de :fdk.cmap.lang/search-hint)
             :on-change (comp
                         (partial reset! db-vals-atom)
                         (fn [pattern] (if (>= (count pattern) 3)
                                         (do
                                           (reset! pattern-atom pattern)
                                           (filter-db-vals pattern))
                                         (do
                                           (reset! pattern-atom nil)
                                           @db-vals-init-atom)))
                         s/lower-case
                         (fn [x] (.-value x))
                         (fn [x] (.-target x)))}]]
   (tab-panes @db-vals-atom)])

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

(def isResizing (atom false))

(defonce chromium? (boolean (.match js/navigator.userAgent
                                    (js/RegExp. "chrome|chromium|crios" "i"))))

(defn on-popup-open-event-fn [map]
  (fn [event]
    ;; (js/console.log "[on-popup-open-event-fn]" "event" event)
    (let [
          ;; pixel location on the map where the popup anchor is
          position (.project map (.-_latlng (.-_popup (.-target event))))
          old-pos-y (-> position .-y)
          ;; height of the popup container, divide by 2, subtract from the Y
          ;; axis of marker location
          full-popup-height
          (-> event .-popup .-_container .-clientHeight)
          ;; (-> event .-target .-_container .-clientHeight)
          ;; (-> event .-sourceTarget .-_container .-clientHeight)
          popup-height (/ full-popup-height 2)
          ]
      ;; (js/console.log "full-eopup-height" full-popup-height)

      ;; XXX: Leaflet bug: full-popup-height is not the same on every browser
      ;; and moreover on the first call it's value is bigger then on the
      ;; consequent calls
      (let [new-pos-y (- old-pos-y popup-height (if chromium? 76 0))]
        (set! (-> position .-y) new-pos-y)
        (.panTo map (.unproject map position) #js {:animate true})))))

(defn on-mouse-move [e]
  (when @isResizing
    (let [
          ;; c (.getElementById js/document "c")
          l (.getElementById js/document "l")
          r (.getElementById js/document "r")]
      (let [ro (str (- (+ (.-offsetLeft r) #_1147
                          (.-offsetWidth r) #_400)
                       (.-clientX e))
                    "px")]
        (set! (-> l .-style .-right) ro)
        (set! (-> r .-style .-width) ro)))))

;;; from https://stackoverflow.com/questions/26233180/resize-a-div-on-border-drag-and-drop-without-adding-extra-markup
(defn resizable [params center-map]
  (let [ref (react/createRef)
        re-zoom false]
    (reagent/create-class
     {
      :component-did-mount
      (fn [_this]
        ;; (js/console.log "[:component-did-mount]" "ref" ref)
        ;; (js/console.log "[:component-did-mount]" "_this" _this)
        (let [
              node-ref       (.-current ref)
              ;; TODO find header, center, footer
              node-header    (.item (-> node-ref .-children) 0)
              node-center    (.item (-> node-ref .-children) 1)
              node-footer    (.item (-> node-ref .-children) 3)
              ]
          (let [node-map-style (-> node-center .-style)]
            (set! (-> node-map-style .-width)
                  (str (.-clientWidth node-center) pxu))
            #_
            (js/console.log
             "[: did-mount]"
             "(.-clientHeight node-ref)" (.-clientHeight node-ref)
             "(.-clientHeight node-header)" (.-clientHeight node-header)
             "(.-clientHeight node-center)" (.-clientHeight node-center)
             "(.-clientHeight node-footer)" (.-clientHeight node-footer))
            (set! (-> node-map-style .-height)
                  (str (- (.-clientHeight node-center)
                          ;; '* 2' b/c padding top and bottom is the same
                          (* 2 styles/padding)) pxu)))
          (let [leaflet-map (-> node-center js/L.map)]
            (reset! map-atom leaflet-map)
            (.setView leaflet-map (let [[longitude latitude] center-map]
                                    ;; initial zoom needed
                                    (array latitude longitude)) zoom)
            (.on leaflet-map "click" (fn [_]
                                       (when @active-atom
                                         (reset! active-atom nil))))
            (.on leaflet-map "popupopen"
                 (on-popup-open-event-fn leaflet-map))

            (.addTo (js/L.tileLayer
                     "https://{s}.tile.OpenStreetMap.org/{z}/{x}/{y}.png"
                     ;; #js {:attribution
                     ;;      (gstr/format
                     ;;       "&copy; <a href=\"%s\">%s</a> contributors"
                     ;;       "http://osm.org/copyright"
                     ;;       "OpenStreetMap")}
                     )
                    leaflet-map))))

      :component-did-update
      (fn [_this _old-argv _old-state _snapshot]
        ;; (js/console.log "[:component-did-update]" "_this" _this)
        ;; (js/console.log "[:component-did-update]" "_old-argv" _old-argv)
        ;; (js/console.log "[:component-did-update]" "_old-state" _old-state)
        ;; (js/console.log "[:component-did-update]" "_snapshot" _snapshot)
        ((comp
          #_(fn [v] (js/console.log "[:component-did-update]" "v" v) v)
          (partial update-markers re-zoom)
          (fn [v] (nth v 2))
          (fn [v] (get v "argv"))
          js->clj
          (fn [v] (.-props v))
          #_(fn [v] (js/console.log "[:component-did-update]" "v" v) v))
         _this)
        )

      :display-name "My Leaflet Map"

      :reagent-render
      (fn [params center-map]
        (when @map-atom
          (update-markers re-zoom))
        [:div#c {:ref ref
                 :class [(styles/c)]}
         [:div {:class [(styles/header)]} #_"header"]
         [:div#l {:class [(styles/l) (styles/center)]
                  :on-mouse-move on-mouse-move} #_"left"]
         [:div#r {:class [(styles/r) (styles/right)]
                  :on-mouse-move on-mouse-move}
          [:div#d {:class [(styles/d)]
                   :on-mouse-down (fn [e]
                                    (js/console.log "start")
                                    (reset! isResizing true))
                   :on-mouse-up   (fn [e]
                                    (js/console.log "stop")
                                    (reset! isResizing false))}]
          (right)]
         [:div {:class [(styles/footer)]}
          (str @(re-frame/subscribe [::subs/name])
               " v"
               ;; output of `git describe --tags --dirty=-SNAPSHOT`
               ;; See :shadow-git-inject/version
               config/version)]])})))

(defn map-with-list [params center-map]
  (let [ref (react/createRef)
        re-zoom false]
    (reagent/create-class
     {:component-did-mount
      (fn [_this]
        ;; (js/console.log "[:component-did-mount]" "ref" ref)
        ;; (js/console.log "[:component-did-mount]" "_this" _this)
        (let [
              node-ref       (.-current ref)
              node-header    (.item (-> node-ref .-children) 0)
              node-center    (.item (-> node-ref .-children) 1)
              node-footer    (.item (-> node-ref .-children) 2)]
          (js/console.log "[:component-did-mount]" "node-ref" node-ref)
          (let [node-map-style (-> node-center .-children first .-style)]
            (set! (-> node-map-style .-width)
                  (str (.-clientWidth node-center) pxu))
            #_
            (js/console.log
             "[: did-mount]"
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
            (.setView leaflet-map (let [[longitude latitude] center-map]
                                    ;; initial zoom needed
                                    (array latitude longitude)) zoom)
            (.on leaflet-map "click" (fn [_]
                                       (when @active-atom
                                         (reset! active-atom nil))))
            (.on leaflet-map "popupopen"
                 (on-popup-open-event-fn leaflet-map))

            (.addTo (js/L.tileLayer
                     "https://{s}.tile.OpenStreetMap.org/{z}/{x}/{y}.png"
                     ;; #js {:attribution
                     ;;      (gstr/format
                     ;;       "&copy; <a href=\"%s\">%s</a> contributors"
                     ;;       "http://osm.org/copyright"
                     ;;       "OpenStreetMap")}
                     )
                    leaflet-map))))
      :component-did-update
      (fn [_this _old-argv _old-state _snapshot]
        ;; (js/console.log "[:component-did-update]" "_this" _this)
        ;; (js/console.log "[:component-did-update]" "_old-argv" _old-argv)
        ;; (js/console.log "[:component-did-update]" "_old-state" _old-state)
        ;; (js/console.log "[:component-did-update]" "_snapshot" _snapshot)
        #_
        ((comp
          #_(fn [v] (js/console.log "[:component-did-update]" "v" v) v)
          #_(partial update-markers re-zoom)
          (fn [v] (nth v 2))
          (fn [v] (get v "argv"))
          js->clj
          (fn [v] (.-props v))
          #_(fn [v] (js/console.log "[:component-did-update]" "v" v) v))
         _this))

      :display-name "My Leaflet Map"

      :reagent-render
      ;; params is {}; (reagent/props params) throws error;
      ;; (.-props params) is undefined
      (fn [params center-map]
        ;; (js/console.log "[:reagent-render]" "params" params)
        ;; (js/console.log "[:reagent-render]" "center-map" center-map)
        (when @map-atom
          (update-markers re-zoom))
        [:div
         {:ref ref
          :class (styles/wrapper)}
         ;; 'header' must be displayed so that the ':grid-template-rows ...'
         ;; kicks in and the height of the 'center' is maximized
         [:div {:class [(styles/header)]} #_"header"]
         #_[:div {:class [(styles/left)]} #_"left"]
         [:div {:class [(styles/center)]} #_"center"
          [:div#map {:style {:height 0 :width 0}}]]
         [:div {:class [(styles/right)]} (right)]
         [:div {:class [(styles/footer)]}
          (str @(re-frame/subscribe [::subs/name])
               " v"
               ;; output of `git describe --tags --dirty=-SNAPSHOT`
               ;; See :shadow-git-inject/version
               config/version)]])})))

(defn main-panel []
  ;; re-frame/subscribe must be called multiple times, otherwise the
  ;; db-vals is empty
  (when-let [db-vals @(re-frame/subscribe [:db-associations])]
    (reset! db-vals-atom      db-vals)
    (reset! db-vals-init-atom db-vals)
    (when-let [center-map
               #_[9.177591 48.775471]
               @(re-frame/subscribe [:center-map])]
      #_[resizable {} center-map]
      [map-with-list {} center-map])))
