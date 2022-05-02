(ns cmap.views
  "reagent views (view layer)"
  (:require
   [reagent.core :as r]
   [re-frame.core :as rf]
   [cmap.subs :as subs]))

;; https://lambdaisland.com/blog/11-02-2017-re-frame-form-1-subscriptions
;; (def <sub "Subscribe / listen to" (comp deref re-frame.core/subscribe))

(defn nav-link [uri title page]
  [:a.navbar-item
   {:href   uri
    :class (when (= page @(rf/subscribe [:common/page-id])) :is-active)}
   title])

(defn about-page []
  [:section.section>div.container>div.content
   [:img {:src "/img/warning_clojure.png"}]])

(defn navbar []
  (r/with-let [expanded? (r/atom false)]
    [:nav.navbar.is-info>div.container
     [:div.navbar-brand
      [:a.navbar-item {:href "/" :style {:font-weight :bold}} "cmap"]
      [:span.navbar-burger.burger
       {:data-target :nav-menu
        :on-click #(swap! expanded? not)
        :class (when @expanded? :is-active)}
       [:span][:span][:span]]]
     [:div#nav-menu.navbar-menu
      {:class (when @expanded? :is-active)}
      [:div.navbar-start
       [nav-link "#/" "Home" :home]
       [nav-link "#/about" "About" :about]]]]))

(defn home-page
  "Views should only compute hiccup. A view shouldn't process input data. The
  subscriptions it uses should deliver the data already in the right structure,
  ready for use in hiccup generation.
  See https://day8.github.io/re-frame/correcting-a-wrong"
  []
  [:section.section>div.container>div.content
   [:div
    [:div @(rf/subscribe [:db-vals])]
    [:div
     {:dangerouslySetInnerHTML {:__html @(rf/subscribe [:docs])}}]]])

(defn page []
  (if-let [page @(rf/subscribe [:common/page])]
    [:div
     [navbar]
     [page]]))
