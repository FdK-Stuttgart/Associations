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

(def pattern-atom (reagent/atom nil))

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
           imageurl links socialmedia
           pobox phone fax
           ] :as prm}]
  #_(js/console.log "(keys prm)" (count (keys prm)) (keys prm))
  #_(js/console.log "phone" phone)
  [:div
   {:class
         "association-container osm-association-container"
         #_"association-container"
         #_"osm-association-container"
    }
   [:div {:class "osm-association-inner-container"}
    [:div {:class "association-title"}
     (into [:h2]
           ;; (mark-string name) ;; doesn't work

           ;; [mark-string name] ;; Produces:
           ;; Warning: Functions are not valid as a React child. This may happen
           ;; if you return a Component instead of <Component /

           (:f> mark-string name))]
    [:div {:class "association-images"}
     [:div {:class "association-image"}
      [:img {:src imageurl :alt ""}]]]
    [:div {:class "association-address"}
     [:p {:class "street"} street]
     [:p {:class "postcode-city"} postcode-city]
     [:p {:class "name"} [:strong addr]]]

    (when (or (seq phone) (seq fax) (seq email))
      [:div {:class "association-contacts"}
       [:div {:class "association-contact"}
        (when (seq phone) ;; i.e. (not (empty? ...))
          [:div {:class "association-contact-row"}
           [:div {:class "social-media-icon mini-icon"}
            [:img {:src "assets/phone.png" :alt ""}]]
           [:p {:class "phone"}
            [:a {:href (str "tel:" phone)} phone]]])
        (when (seq fax) ;; i.e. (not (empty? ...))
          [:div {:class "association-contact-row"}
           [:div {:class "social-media-icon mini-icon"}
            [:img {:src "assets/fax.png" :alt ""}]]
           [:p {:class "fax"}
            [:a {:href (str "fax:" fax)} fax]]])
        (when (seq email) ;; i.e. (not (empty? ...))
          [:div {:class "association-contact-row"}
           [:div {:class "social-media-icon mini-icon"}
            [:img {:src "assets/mail.png" :alt ""}]]
           [:p {:class "mail"}
            [:a {:href (str "mailto:" email)} email]]])]])
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
