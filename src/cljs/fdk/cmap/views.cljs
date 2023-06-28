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

;; German map:
;; https://www.amcharts.com/svg-maps/?map=germany
;; Simpler maps:
;; https://leaflet-extras.github.io/leaflet-providers/preview/
;; commercial services also offer free plans: mapbox, MapQuest, etc.

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
          :render (fn [] (tab1 markers tab-items))})

       (let [tab-items
             ((comp
               #_
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
          :render (fn [] (tab1 markers tab-items))})]}]))

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

(defn handle-upload [e]
;;; for (const file of event.files) {
;;;   this.uploadedFiles.push(file);
;;;   const reader: FileReader = new FileReader();
;;;   const bs = reader.readAsBinaryString(file);
;;;   reader.onload = (e) => {
;;;     const binaryResult = reader.result;
;;;     const wb: XLSX.WorkBook = XLSX.read(binaryResult, {type: 'binary'});
;;;     const wsname: string = wb.SheetNames[0];
;;;     const ws: XLSX.WorkSheet = wb.Sheets[wsname];
;;;     const assocs: Association[] = getAssociations(this.districtOptions, ws);
;;;   };
;;; }
  (let [file
        ;; get the file from the event
        ;; two dots: clojurescript interop
        (.. e -target -files (item 0))
        ;; (-> e .-target .-files (.item 0))

        reader (js/FileReader.)]
    ;; (.readAsText reader file)
    (.readAsBinaryString reader file)
    (.addEventListener reader "load"
                       (fn [load-event]
                         (let [file-contents
                               ;; get the result from the reader, not the event
                               ;; (-> e .-target .-result)
                               (.-result reader)]
                           #_(js/console.log "file-contents" file-contents))))))

;; #+BEGIN_SRC bash :results output :exports both
;; # evaluate: ~C-c C-C~
;; rg --no-ignore-vcs -g '*.{clj,cljs}' "POST" $dec
;; #+END_SRC

;; #+RESULTS:
;; #+begin_example
;; /home/bost/dec/corona_cases/src/corona/web/core.clj:  (cjc/POST
;; /home/bost/dec/corona_cases/src/corona/web/core.clj:               ;; (POST "..." {body :body} ...)
;; /home/bost/dec/covid-survey/src/shouter/controllers/shouts.clj:  (:require [compojure.core :refer [defroutes GET POST]]
;; /home/bost/dec/covid-survey/src/shouter/controllers/shouts.clj:  (POST "/survey/beec7b5ea3f0fdbc95d0dd47f3c5bc27" [shout] (hello-user {:name ""})))
;; /home/bost/dec/maps/reagent-openlayers/out/clojure/browser/repl.cljs:  (net/transmit connection url "POST" data nil 0))
;; /home/bost/dec/maps/reagent-openlayers/out/clojure/browser/repl.cljs:     (net/transmit conn url "POST" data nil 0))))
;; /home/bost/dec/maps/openlayers-lipas/webapp/src/clj/lipas/backend/middleware.clj:(def allow-methods "GET, PUT, PATCH, POST, DELETE, OPTIONS")
;; /home/bost/dec/ufo/src/clj/ufo/server.clj:  (POST "/"    [] "Create something")
;; #+end_example


(defn file-upload []
  (fn []
    [:div {:style {:color "black"}}
     "Select an ODS file: "
     [:form {:action "/api/import" :enc-type "multipart/form-data" :method "POST"}
      #_(anti-forgery-field)
      [:input {:id "file"
               :name "file"
               :type "file"
               :accept ".ods"
               :title "some-title"
               :on-change handle-upload
               }]
      [:input {:type "submit" :value "upload"}]]]))

(defn right [markers]
  [:div
   [:div.color-input
    [file-upload]
    [:input {:type "text"
             :placeholder (de :fdk.cmap.lang/search-hint)
             :on-change (on-change-fn markers)
             ;; TODO move the style to a css-file
             :style {
                     :padding ".5rem"
                     :border "1px solid"
                     :border-radius "3px"
                     ;; :width "282px"
                     }
             }]]
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

(defn max-size-x [map-elem] (-> map-elem .getSize .-x))
(defn max-size-y [map-elem] (-> map-elem .getSize .-y))

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

(def copyright-osm
  (gstr/format "&copy; <a href=\"%s\">%s</a> contributors"
               "https://www.openstreetmap.org/copyright"
               "OpenStreetMap"))

(defn create-map [map-elem center-map]
  (let [map (-> map-elem
                        (.setView (let [[longitude latitude] center-map]
                                    ;; initial zoom needed
                                    (array latitude longitude)) zoom)
                        (.on "click" (fn [_] (when @active-atom
                                               (reset! active-atom nil))))
                        ;; This moves the map a bit to the bottom so that the
                        ;; popup is displayed more in the center
                        (.on "popupopen" (popupopen-fn map-elem)))

        basemaps
        {
         :stadiamaps.OSMBright
         (js/L.tileLayer
          "https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}{r}.png"
          #js {:maxZoom 20
	             :attribution
               (gstr/format
                "%s, %s, %s"
                "&copy; <a href=\"https://stadiamaps.com/\">Stadia Maps</a>"
                "&copy; <a href=\"https://openmaptiles.org/\">OpenMapTiles</a>"
                copyright-osm)})
          :USGS_USTopo
         (js/L.tileLayer
          "https://basemap.nationalmap.gov/arcgis/rest/services/USGSTopo/MapServer/tile/{z}/{y}/{x}"
          #js {:maxZoom 20 :attribution
               (gstr/format "Tiles courtesy of the <a href=\"%s\">%s</a>"
                            "https://usgs.gov/"
                            "U.S. Geological Survey")})

         :OpenStreetMap.Mapnik
         (js/L.tileLayer "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
                         #js {:maxZoom 19 :attribution copyright-osm})

         :OpenStreetMap.DE
         (js/L.tileLayer "https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png"
                         #js {:maxZoom 18 :attribution copyright-osm})

         :stadiamaps.Alidade_Smooth
         (js/L.tileLayer
          "https://tiles-eu.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png"
          #js {:minZoom 00
               :maxZoom 20
               :ext "png"
               :attribution
               (gstr/format "%s, %s, %s"
                            "&copy; <a href=\"https://stadiamaps.com/\" target=\"_blank\">Stadia Maps</a>"
                            "&copy; <a href=\"https://openmaptiles.org/\" target=\"_blank\">OpenMapTiles</a>"
                            "&copy; <a href=\"https://www.openstreetmap.org/about\" target=\"_blank\">OpenStreetMap</a> contributors")})
         }
        ;; The js/L.control.layers doesn't work
        ;; layers (js/L.control.layers basemaps)

        layer (
               :stadiamaps.Alidade_Smooth
               ;; :stadiamaps.OSMBright
               ;; :USGS_USTopo
               ;; :OpenStreetMap.DE
               basemaps)]
    ;; (js/console.log "layers" layers)
    ;; (js/console.log "layer" layer)
    #_(.addTo layers map)
    (.addTo layer map)
    ;; defining `east` and `south` as a local bindings enables local to
    ;; differentiate using the js/L.DomEvent.on
    (let [east  (.addTo (js/L.control.resizer #js {:direction "e"
                                                   :pan true
                                                   #_#_
                                                   :onlyOnHover true})
                        map)
          south (.addTo (js/L.control.resizer #js {:direction "s"
                                                   :pan true})
                        map)
          south-east (.addTo (js/L.control.resizer #js {:direction "se"
                                                   :pan true
                                                   #_#_
                                                   :onlyOnHover false})
                        map)]
      #_
      (js/setTimeout (fn [] (.fakeHover east 1000)) 1000)
;;; down       Event         Fired when a drag is about to start.
;;; dragstart  Event         Fired when a drag starts
;;; predrag    Event         Fired continuously during dragging before each corresponding update of the element's position.
;;; drag       Event         Fired continuously during dragging.
;;; dragend    DragEndEvent  Fired when the drag ends .
;;; #_
      (let [r (.getElementById js/document "r")

            store-map-size-x-fn
            (fn [_] (reset! map-size-x-atom (max-size-x map-elem)))
            store-map-size-y-fn
            (fn [_] (reset! map-size-y-atom (max-size-y map-elem)))

            resize-r-x-fn
            (fn [_]
              (let [diff-x (- (max-size-x map-elem)
                              @map-size-x-atom)

                    nvx ((comp
                          #_(fn [v] (- v 16))
                          #_(fn [v] (js/console.log "1" v) v))
                          (+ (-> r .-offsetWidth #_.-clientWidth)
                             (- diff-x)))]
                #_
                (js/console.log "x"
                                "(-> r .-clientWidth)" (-> r .-clientWidth)
                                "diff-x" diff-x
                                "nvx" nvx)
                (set! (-> r .-style .-width) (str nvx "px"))))

            resize-r-y-fn
            (fn [_]
              (let [diff-y (- (max-size-y map-elem)
                              @map-size-y-atom)
                    nvy ((comp
                          #_(fn [v] (min (.-innerHeight js/window) v))
                          #_(fn [v] (js/console.log "1" v) v))
                         (+ (-> r .-offsetHeight #_.-clientHeight)
                            (+ diff-y)))
                    ]
                #_
                (js/console.log "y"
                                "(-> r .-clientHeight)" (-> r .-clientHeight)
                                "diff-y" diff-y
                                "nvy" nvy)
                (set! (-> r .-style .-height) (str nvy "px"))))]
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
    (reset! map-atom map)))

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
