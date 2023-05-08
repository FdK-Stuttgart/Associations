(ns fdk.cmap.popup
  (:require
   ;; [re-frame.core :as re-frame]
   ;; [fdk.cmap.styles :as styles :refer [pxu]]
   ;; [fdk.cmap.subs :as subs]
   [fdk.cmap.data :as data]
   [fdk.cmap.lang :refer [de]]
   ;; [fdk.cmap.config :as config]
   ;; [fdk.cmap.react-components :as rc]
   [reagent.core :as reagent]
   ;; [reagent.dom :as rdom]
   ;; [reagent.dom.server :as rserver]
   ;; [reagent.impl.component :as ric]
   [clojure.string :as s] ;; for s/join
   [goog.string :as gstr]
   ;; [cljs.pprint :as pp]
   ;; ["react-leaflet" :as rle]
   ;; ["leaflet.markercluster"]
   ;; ["leaflet.control.resizer"]
   ;; ;; TODO use import instead of <link rel="stylesheet" ...>
   ;; ;; ["semantic-ui-css/components/tab" :as csu]
   ;; ["react" :as react]
   ))

;; German map see
;; https://kau-boys.de/4664/webentwicklung/cluster-markers-by-state-on-a-leaflet-map

(enable-console-print!)

(def filter-keys
  [:name
   ;; :shortName

   ;; :addr
   :street
   :postcode-city
   :city
   :country

   :goals
   :activities

   ;; :contacts
   :pobox :phone :fax

   :email

   ;; :imageurl    ;; :url :alttext
   ;; :links       ;; :url :linkText
   ;; :socialmedia ;; :url :linkText :platform

   ;; :districts   ;; TODO
   ])

(def pattern-atom (reagent/atom nil))

(defn mark-string [s]
  #_(js/console.log "[mark-string]" "s" s)
  #_(js/console.log "[mark-string]" "@pattern-atom" @pattern-atom)
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

(defn- popup-content
  "addr has only 'keine öffentliche Anschrift'
  (popup-content marker-data filter-data)
  "
  [{:keys [k name addr street postcode-city districts email activities goals
           imageurl links socialmedia
           pobox phone fax] :as marker-data}
   filter-data]
  #_(js/console.log "(keys marker-data)" (count (keys marker-data)) (keys marker-data))
  [:div
   {:class
         "association-container osm-association-container"
         #_"association-container"
         #_"osm-association-container"
    }
   [:div {:class "osm-association-inner-container"}
    [:div {:class "association-title"}
     [:h2 (:name filter-data)]]
    [:div {:class "association-images"}
     [:div {:class "association-image"}
      [:img {:src imageurl :alt ""}]]]
    [:div {:class "association-address"}
     [:p {:class "street"} (:street filter-data)]
     [:p {:class "postcode-city"} (:postcode-city filter-data)]
     [:p {:class "name"} [:strong addr]]]

    (when (or (seq phone) (seq fax) (seq email))
      [:div {:class "association-contacts"}
       [:div {:class "association-contact"}
        (when (seq phone) ;; i.e. (not (empty? ...))
          [:div {:class "association-contact-row"}
           [:div {:class "social-media-icon mini-icon"}
            [:img {:src "assets/phone.png" :alt ""}]]
           [:p {:class "phone"}
            [:a {:href (str "tel:" phone)} (:phone filter-data)]]])
        (when (seq fax) ;; i.e. (not (empty? ...))
          [:div {:class "association-contact-row"}
           [:div {:class "social-media-icon mini-icon"}
            [:img {:src "assets/fax.png" :alt ""}]]
           [:p {:class "fax"}
            [:a {:href (str "fax:" fax)} (:fax filter-data)]]])
        (when (seq email) ;; i.e. (not (empty? ...))
          [:div {:class "association-contact-row"}
           [:div {:class "social-media-icon mini-icon"}
            [:img {:src "assets/mail.png" :alt ""}]]
           [:p {:class "mail"}
            [:a {:href (str "mailto:" email)} (:email filter-data)]]])]])
    [:div {:class "association-description"}
     [:h3 (de :fdk.cmap.lang/goals)]
     (:goals filter-data)]
    [:div {:class "association-description"}
     [:h3 (de :fdk.cmap.lang/activities)] (:activities filter-data)]
    [:div {:class "association-active-in"}
     [:h3 (de :fdk.cmap.lang/activity-areas)]
     [:div {:class "association-chips-container"}
      (map-indexed (fn [idx elem]
                     (vector :div (conj {:key idx}
                                        {:class "association-chips"})
                             elem))
                   districts)]]
    (when (seq (:url links)) ;; not-empy?
      [:div {:class "association-links"}
       [:h3 (de :fdk.cmap.lang/links)]
       [:ul
        ((comp
          (partial map-indexed
                   (fn [idx [url text]]
                     [:li {:key idx} [:a {:href url :title text :target "_blank"}
                                      (if (empty? text) url text)]]))
          dedupe
          (partial apply mapv vector) ;; transpose
          (juxt :url :text))
         links)]])
    ;; not-empy?
    (when (seq (:urls socialmedia))
      [:div {:class "association-social-media"}
       ((comp
         (partial map-indexed
                  (fn [idx [platform url]]
                    [:div {:key idx :class "social-media-link"}
                     [:a {:href url
                          :target "_blank"
                          :title (get-in data/social-media [platform :title])}
                      [:div {:class "social-media-icon mini-icon"}
                       [:img (get-in data/social-media [platform :img])]]]]))
         dedupe
         (partial apply mapv vector) ;; transpose
         (juxt :platforms :urls))
        socialmedia)])]])

(defn popup-content-with-marks
  "addr has only 'keine öffentliche Anschrift'
  (popup-content-with-marks marker-data)
  "
  [marker-data]
  (let [m (select-keys marker-data filter-keys)]
    ((comp
      (partial popup-content marker-data)
      (partial into {})
      (partial map (fn [k]
                     ((comp
                       (partial hash-map k)
                       (partial into [:span])
                       mark-string
                       (partial get-in m)
                       vector)
                      k))))
     filter-keys)))
