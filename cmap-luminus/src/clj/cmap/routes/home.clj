(ns cmap.routes.home
  (:require
   [clojure.tools.logging :as log]
   [cmap.layout :as layout]
   [cmap.db.core :as db]
   [clojure.java.io :as io]
   [cmap.middleware :as middleware]
   [ring.util.response]
   [ring.util.http-response :as response]))

(defn home-page [request]
  (layout/render request "home.html"
                 #_{:messages
                    (let [vs (db/get-messages)]
                      (log/info "\n ####### static vs:" vs)
                      vs)}))

(defn home-routes []
  [""
   {:middleware [middleware/wrap-csrf
                 middleware/wrap-formats]}
   ["/" {:get home-page}]
   ["/db-vals" {:get (fn [_]
                       (-> (response/ok
                            (let [vs (->> #_(db/get-messages)
                                          #_(db/read-associations)
                                          (db/read-districts-options)
                                          (pr)
                                          (with-out-str))]
                              #_(log/info "\n$$$$$$$ db-vals:" vs)
                              vs))
                           (response/header "Content-Type" "text/plain; charset=utf-8")))}]
   ["/docs" {:get (fn [_]
                    (-> (response/ok (-> "docs/docs.md" io/resource slurp))
                        (response/header "Content-Type" "text/plain; charset=utf-8")))}]])

