(ns fdk.cmap.core
  "entry point, plus history, routing, etc"
  (:require
   ["react-dom/client" :refer [createRoot]]
   ["react" :as react]
   [goog.dom :as gdom]
   [reagent.core :as r]

   [day8.re-frame.http-fx]
   [re-frame.core :as rf]
   [fdk.cmap.views :as views]
   ;; https://day8.github.io/re-frame/App-Structure/#the-gotcha
   [fdk.cmap.events] ;; must be required
   [fdk.cmap.subs] ;; must be required
   ))

(defonce root (createRoot (gdom/getElement "app")))

(defn init []
  #_(ajax/load-interceptors!)
  (rf/dispatch [
                :fetch-from-db
                ;; :page/init-db
                ])
  ((comp
    ;; Strict Mode enables extra development-only checks for the entire
    ;; component tree inside the <StrictMode> component. These checks help you
    ;; find common bugs in your components early in the development process.
    ;;
    ;; We recommend wrapping your entire app in Strict Mode, especially for
    ;; newly created apps.
    ;; https://react.dev/reference/react/StrictMode#enabling-strict-mode-for-entire-app
    (fn [v]
      ;; (js/console.log "[init]" "react/StrictMode")
      ;; (js/console.log "[init]" "(.-innerWidth js/window)"
      ;;                 (.-innerWidth js/window))
      [:> react/StrictMode {} v]))
   (.render root (r/as-element [views/main-panel]))))

(defn ^:dev/after-load mount-components []
  ;; The `:dev/after-load` metadata causes this function to be called
  ;; after shadow-cljs hot-reloads code.
  ;; This function is called implicitly by its annotation.
  (init))
