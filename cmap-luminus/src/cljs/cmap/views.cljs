(ns cmap.views
  "reagent views (view layer)"
  (:require
   [reagent.core :as r]
   [re-frame.core :as rf]
   [cmap.subs :as subs]
   ["semantic-ui-react" :as rsu]
   ;; TODO use import instead of <link rel="stylesheet" ...>
   ;; ["semantic-ui-css/components/tab" :as csu]
   ))

;; See
;; https://github.com/reagent-project/reagent/blob/master/doc/InteropWithReact.md
;; https://dawranliou.com/blog/reagent-component-vs-react-component/

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

(def Tab (r/adapt-react-class rsu/Tab))

(defn home-page
  "Views should only compute hiccup. A view shouldn't process input data. The
  subscriptions it uses should deliver the data already in the right structure,
  ready for use in hiccup generation.
  See https://day8.github.io/re-frame/correcting-a-wrong"
  []
  [:section.section>div.container>div.content
   [:div
    [:div
     [Tab {:panes [{:menuItem "Tab 1" :render
                    (when-let [t @(rf/subscribe [:db-associations])]
                      (fn []
                        ((comp
                          r/as-element
                          (partial vector :div {:class "ui attached segment active tab"})
                          (partial take 2)
                          (partial map (fn [[k v]] [:span {:key k} [:div v]])))
                         t)))}
                   {:menuItem "Tab 2" :render
                    (when-let [t @(rf/subscribe [:db-associations])]
                      (fn []
                        ((comp
                          r/as-element
                          (partial vector :div {:class "ui attached segment active tab"})
                          (partial take 3)
                          (partial map (fn [[k v]] [:span {:key k} [:div v]])))
                         t)))}
                   {:menuItem "Tab 3" :render
                    (when-let [t @(rf/subscribe [:db-associations])]
                      (fn []
                        ((comp
                          r/as-element
                          (partial vector :div {:class "ui attached segment active tab"})
                          (partial take 4)
                          (partial map (fn [[k v]] [:span {:key k} [:div v]])))
                         t)))
                    }]}]]
    [:div
     {:dangerouslySetInnerHTML {:__html @(rf/subscribe [:docs])}}]]])

(defn page []
  (if-let [page @(rf/subscribe [:common/page])]
    [:div
     [navbar]
     [page]]))
