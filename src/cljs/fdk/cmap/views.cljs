(ns fdk.cmap.views
  (:require
   [re-frame.core :as re-frame]
   [fdk.cmap.styles :as styles :refer [pxu]]
   [fdk.cmap.subs :as subs]
   [fdk.cmap.data :as data]
   [fdk.cmap.lang :refer [de]]
   [fdk.cmap.config :as config]
   [fdk.cmap.popup :as popup]
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
   ["leaflet.control.resizer"]
   ;; TODO use import instead of <link rel="stylesheet" ...>
   ;; ["semantic-ui-css/components/tab" :as csu]
   ["react" :as react]
   ))

;; German map see
;; https://kau-boys.de/4664/webentwicklung/cluster-markers-by-state-on-a-leaflet-map

(enable-console-print!)

(declare update-markers)
(declare click-on-association)

(def markers-layer-atom (reagent/atom nil))
(def db-vals-atom (reagent/atom nil))
(def db-vals-init-atom (reagent/atom nil))
(def map-atom (reagent/atom nil))
(def active-atom (reagent/atom nil))
(def old-active-atom (reagent/atom nil))

(def zoom 17)

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

(def inactive-private
  (js/L.icon
   (clj->js ;; can't use #js
    {:iconUrl "/icon/map_markers/pinInactivePrivate.png"
     :iconSize [30 42]
     :iconAnchor [15 41]
     :popupAnchor [0 -31]})))
(def active-public
  (js/L.icon
   (clj->js ;; can't use #js
    {:iconUrl "/icon/map_markers/pinActivePublic.png"
     :iconSize [30 42]
     :iconAnchor [15 41]
     :popupAnchor [0 -31]})))
(def active-private
  (js/L.icon
   (clj->js ;; can't use #js
    {:iconUrl "/icon/map_markers/pinActivePrivate.png"
     :iconSize [30 42]
     :iconAnchor [15 41]
     :popupAnchor [0 -31]})))

;; TODO keep the popup opened when zooming out
(defn update-markers
  "Executed 2x with react/StrictMode and 3x w/o react/StrictMode"
  [markers db-vals re-zoom]
  (let [active @active-atom
        db-vals @db-vals-atom
        markers-group (js/L.markerClusterGroup cluster-config)]
    #_
    (.on markers-group "clusterclick"
         (fn [c]
           (js/console.log "clusterclick"
                           (-> c .-layer .getAllChildMarkers .-length))))

    (.addLayers markers-group (to-array (vals markers)))
    (map (fn [marker-data]
           (let [k (:k marker-data)]
             (when (=
                    ;; Deutsch-Türkisches Forum Stuttgart
                    ;; "85e9a6f1-1688-490d-abd8-e5310b351df6"
                    ;; "Afro Deutsches Akademiker Netzwerk ADAN"
                    "a4be69a3-e758-456c-a6e2-f207c8df1a94"
                    k)
               (js/console.log "active" active "openPopup" (= k active)))
             (when (= k active)
               ;; completely removing the (.setView ...) fixes jumpy marker but
               ;; it causes causes among others the 'ABADÁ Capoeira' popup not
               ;; to get displayed. Doesn't work
               (when-not (= @old-active-atom active)
                 (.setView @map-atom
                           (apply array (reverse (:coords marker-data)))
                           zoom)
                 (reset! old-active-atom k))
               (js/console.log "(get markers k)" (get markers k))
               (.openPopup (get markers k)))))
         db-vals)
    (.addLayer @map-atom markers-group)))


(defonce chromium? (boolean (.match js/navigator.userAgent
                                    (js/RegExp. "chrome|chromium|crios" "i"))))

(defn popupopen-fn [map]
  (fn [event]
    ;; (js/console.log "[popupopen-fn]" "event" event)
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

(defn center-leaflet-map-on-marker [marker]
  (let [lat-lngs #js [(.getLatLng marker)]]
    (js/console.log "[center-leaflet-map-on-marker]" "lat-lngs" lat-lngs)
    (let [marker-bounds (js/L.latLngBounds lat-lngs)]
      (js/console.log "[center-leaflet-map-on-marker]"
                      "marker-bounds" marker-bounds)
      (.flyTo @map-atom (.getLatLng marker)
              ;; zoom options
              )
      #_(.fitBounds @map-atom marker-bounds))))

(defn click-on-association [marker marker-data k]
  (fn [_]
    (let [old-active @active-atom]
      (reset! active-atom k)
      #_(js/console.log "[click-on-association]" "new-active" @active-atom)
      (let [re-zoom (and @active-atom (not= old-active @active-atom))]
        #_(js/console.log "[click-on-association]" "re-zoom" re-zoom)
        #_(js/console.log "[click-on-association]" "marker-data" marker-data)
        (when-not (= @old-active-atom k)
          ;; .flyTo prevents popup from opening
          ;; (.flyTo @map-atom (.getLatLng marker))

          ;; both panTo, and setView work fine in Firefox, but are buggy in
          ;; Chrome
          (let [coords (apply array (reverse (:coords marker-data)))]
            #_(.panTo @map-atom coords)
            (.setView @map-atom coords zoom))
          (reset! old-active-atom k))
        (-> marker
            (.bindPopup (js/L.popup
                         #js {:content
                              (rserver/render-to-string
                               (popup/popup-content-with-marks marker-data))}))
            (.openPopup))))))

(defn list-elem [marker pi-icon {:keys [k name addr coords] :as marker-data}]
  [:span {:key k :on-click (click-on-association marker marker-data k)}
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

(defn tab1 [markers db-vals]
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
                     [(get markers k)
                      (if (= active k)
                        "pi-map"        ;; the map icon
                        "pi-map-marker" ;; the pointy-ball icon
                        )
                      db-val])))
     db-vals)))

(defn tab-panes [markers]
  ;; the change of the value @db-vals-atom doesn't get propagated to this
  ;; invocation
  (let [db-vals @db-vals-atom]
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
          :render (fn [] (tab1 markers db-vals))})

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
             tab-items))})]}]))

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
               (fn [v] (select-keys v popup/filter-keys)))
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

(defn on-change-fn [markers]
  (comp
   ;; (partial reset! db-vals-atom)
   (fn [new-db-vals]
     (reset! db-vals-atom new-db-vals)
     new-db-vals)
   (fn [new-db-vals]
     (run! (comp
            (fn [marker]
              (.setIcon marker inactive-private))
            (partial get markers)
            :k)
           ((comp
             (partial reduce clojure.set/difference)
             (partial map set))
            [@db-vals-init-atom new-db-vals]))
     new-db-vals)
   (fn [pattern] (if (>= (count pattern) 3)
                   (do
                     (reset! popup/pattern-atom pattern)
                     (filter-db-vals pattern))
                   (do
                     (reset! popup/pattern-atom nil)
                     @db-vals-init-atom)))
   s/lower-case
   (fn [x] (.-value x))
   (fn [x] (.-target x))))

(defn right [markers]
  [:div
   [:div.color-input
    [:input {:type "text"
             :placeholder (de :fdk.cmap.lang/search-hint)
             :on-change (on-change-fn markers)}]]
   (tab-panes markers)])

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

(defn create-markers [db-vals]
  ((comp
    (partial reduce into {})
    (partial
     map (fn [marker-data]
           (let [k (get marker-data :k)
                 marker
                 (js/L.marker
                  ;; latitude longitude
                  (apply array (reverse (:coords marker-data)))
                  #js {:title (:name marker-data)
                       :icon (if (public-address? (:addr marker-data))
                               active-public
                               active-private)})]
             (.on marker "click" (click-on-association marker marker-data k))
             (hash-map k marker)))))
   db-vals))

(def map-size-x-atom (reagent/atom nil))
(def map-size-y-atom (reagent/atom nil))
(defn create-map [map-elem center-map]
  (let [leaflet-map (-> map-elem
                        (.setView (let [[longitude latitude] center-map]
                                    ;; initial zoom needed
                                    (array latitude longitude)) zoom)
                        (.on "click" (fn [_] (when @active-atom
                                               (reset! active-atom nil))))
                        ;; This moves the map a bit to the bottom so that the
                        ;; popup is displayed more in the center
                        (.on "popupopen" (popupopen-fn map-elem)))]
    (.addTo (js/L.tileLayer
             "https://{s}.tile.OpenStreetMap.org/{z}/{x}/{y}.png"
             #_
             #js {:attribution
                  (gstr/format
                   "&copy; <a href=\"%s\">%s</a> contributors"
                   "http://osm.org/copyright"
                   "OpenStreetMap")})
            leaflet-map)
    ;; defining `east` and `south` as a local bindings enables local to
    ;; differentiate using the js/L.DomEvent.on
    (let [east  (.addTo (js/L.control.resizer #js {:direction "e"
                                                   :pan true
                                                   #_#_
                                                   :onlyOnHover true})
                        leaflet-map)
          south (.addTo (js/L.control.resizer #js {:direction "s"
                                                   :pan true})
                        leaflet-map)
          south-east (.addTo (js/L.control.resizer #js {:direction "se"
                                                   :pan true
                                                   #_#_
                                                   :onlyOnHover false})
                        leaflet-map)]
      #_
      (js/setTimeout (fn [] (.fakeHover east 1000)) 1000)
;;; down       Event         Fired when a drag is about to start.
;;; dragstart  Event         Fired when a drag starts
;;; predrag    Event         Fired continuously during dragging before each corresponding update of the element's position.
;;; drag       Event         Fired continuously during dragging.
;;; dragend    DragEndEvent  Fired when the drag ends .
;;; #_
      (let [store-map-size-x-fn
            (fn [_]
              (reset! map-size-x-atom (-> map-elem .getSize .-x)))
            store-map-size-y-fn
            (fn [_]
              (reset! map-size-y-atom (-> map-elem .getSize .-y)))


            resize-r-x-fn
            (fn [_]
              (let [r (.getElementById js/document "r")
                    diff-x (- (-> map-elem .getSize .-x)
                              @map-size-x-atom)]
                #_
                (js/console.log "x"
                                "(-> r .-clientWidth)" (-> r .-clientWidth)
                                "diff-x" diff-x)
                (set! (-> r .-style .-width)
                      (str (+ (-> r .-offsetWidth #_.-clientWidth)
                              (- diff-x)) "px"))))
            resize-r-y-fn
            (fn [_]
              (let [r (.getElementById js/document "r")
                    diff-y (- (-> map-elem .getSize .-y)
                              @map-size-y-atom)]
                #_
                (js/console.log "y"
                                "(-> r .-clientHeight)" (-> r .-clientHeight)
                                "diff-y" diff-y)
                (set! (-> r .-style .-height)
                      (str (+ (-> r .-offsetHeight #_.-clientHeight)
                              (+ diff-y)) "px"))))]
        (js/L.DomEvent.on south-east "down"    (fn [e]
                                                 (store-map-size-x-fn e)
                                                 (store-map-size-y-fn e)))
        (js/L.DomEvent.on south-east "dragend" (fn [e]
                                                 (resize-r-x-fn e)
                                                 (resize-r-y-fn e)))

        (js/L.DomEvent.on east  "down"    store-map-size-x-fn)
        (js/L.DomEvent.on east  "dragend" resize-r-x-fn)

        (js/L.DomEvent.on south "down"    store-map-size-y-fn)
        (js/L.DomEvent.on south "dragend" resize-r-y-fn)
        ))
    (reset! map-atom leaflet-map)))

(defn map-with-list [params markers center-map]
  (let [ref (react/createRef)
        re-zoom false]
    (reagent/create-class
     {:component-did-mount
      (fn [_this]
        ;; (js/console.log "[:component-did-mount]" "ref" ref)
        ;; (js/console.log "[:component-did-mount]" "_this" _this)
        (let [node-ref       (.-current ref)
              #_#_
              node-header    (.item (-> node-ref .-children) 0)
              node-center    (.item (-> node-ref .-children) 1)
              #_#_
              node-footer    (.item (-> node-ref .-children) 2)]
          (create-map (-> node-center js/L.map) center-map)
          (update-markers markers @db-vals-atom re-zoom)
          ))

      :component-did-update
      (fn [_this _old-argv _old-state _snapshot]
        ;; (js/console.log "[:component-did-update]" "_this" _this)
        ;; (js/console.log "[:component-did-update]" "_old-argv" _old-argv)
        ;; (js/console.log "[:component-did-update]" "_old-state" _old-state)
        ;; (js/console.log "[:component-did-update]" "_snapshot" _snapshot)
        #_
        ((comp
          #_(fn [v] (js/console.log "[:component-did-update]" "v" v) v)
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
          (update-markers markers @db-vals-atom re-zoom))
        [:div#c {:ref ref :class [(styles/c)]}
         [:div {:class [(styles/header)]} #_"header"]
         [:div#l {:class [(styles/l) (styles/center)]} #_"left"]
         [:div#r {:class [(styles/r) (styles/right)]}
          [:div#d {:class [(styles/d) (styles/fill)]} (right markers)]]
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
    #_(js/console.log "0 [main-panel]" (count db-vals))
    (let [markers (create-markers db-vals)]
      (when-let [center-map
                 #_[9.177591 48.775471]
                 @(re-frame/subscribe [:center-map])]
        #_[resizable {} center-map]
        [map-with-list {} markers center-map]))))
