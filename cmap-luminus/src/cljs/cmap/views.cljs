(ns cmap.views
  "reagent views (view layer)"
  (:require
   [reagent.core :as r]
   [re-frame.core :as rf]
   [markdown.core :refer [md->html]]
   [cmap.subs :as subs]))

(def <sub (comp deref re-frame.core/subscribe))   ;; same as `listen` (above)

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

(defn home-page []
  [:section.section>div.container>div.content
   [:div
    (when-let [db-vals @(rf/subscribe [:db-vals])]
      ((comp
        (partial vector :div)
        (partial map (comp (partial vector :div) :name first))
        vals
        (partial group-by :associationid)
        cljs.reader/read-string)
       db-vals))
    (when-let [docs @(rf/subscribe [:docs])]
      [:div
       {:dangerouslySetInnerHTML {:__html (md->html docs)}}])]])

(defn page []
  (if-let [page @(rf/subscribe [:common/page])]
    [:div
     [navbar]
     [page]]))
