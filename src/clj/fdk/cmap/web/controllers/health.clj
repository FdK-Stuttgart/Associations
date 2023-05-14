(ns fdk.cmap.web.controllers.health
  (:require
    [ring.util.http-response :as http-response]
    [fdk.cmap.web.routes.utils :as utils]
    [clojure.tools.logging :as log]
    )
  (:import
    [java.util Date]))

(defn healthcheck!
  [req]
  (http-response/ok
    {:time     (str (Date. (System/currentTimeMillis)))
     :up-since ((comp str
                      (fn [v] (Date. v))
                      (fn [v] (.getStartTime v)))
                (java.lang.management.ManagementFactory/getRuntimeMXBean))
     :app      {:status  "up" :message ""}}))

(defn read-db
  [{{:strs [x y]} :form-params :as request}]
  ;; (println "x" x "y" y)      ; appears in the console
  ;; (log/debug "x" x "y" y)    ; appears in the console & log/fdk.cmap.log
  (let [{:keys [query-fn]} (utils/route-data request)]
    ;; See also
    ;; (rf/reg-event-fx :fetch-from-db ...
    ;;   {:http-xhrio {...
    ;;                 :response-format (ajax/raw-response-format)}})
    (-> (http-response/ok
         (let [db-vals (->> (query-fn :read-associations {})
                            (pr)
                            (with-out-str))]
           (log/info "\n$$$ Response length:" (count db-vals))
           db-vals))
        (http-response/header "Content-Type" "text/plain; charset=utf-8"))))
