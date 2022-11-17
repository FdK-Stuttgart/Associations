(ns fdk.cmap.web.controllers.health
  (:require
    [ring.util.http-response :as http-response]
    [integrant.repl.state :as state]
    [fdk.cmap.web.routes.utils :as utils]
    [clojure.tools.logging :as log]
    )
  (:import
    [java.util Date]))

(defn healthcheck!
  [req]
  (http-response/ok
    {:time     (str (Date. (System/currentTimeMillis)))
     :up-since (str (Date. (.getStartTime (java.lang.management.ManagementFactory/getRuntimeMXBean))))
     :app      {:status  "up"
                :message ""}}))

(defn read-db
  [{{{:keys [x y]} :query} :parameters :as request}]
  (let [query-fn (:db.sql/query-fn state/system)]
    ;; (println "x" x "y" y)      ; appears in the console
    ;; (log/debug "x" x "y" y)    ; appears in the console & log/fdk.cmap.log

    ;; See also
    ;; (rf/reg-event-fx :fetch-from-db ...
    ;;   {:http-xhrio {...
    ;;                 :response-format (ajax/raw-response-format)}})
    (-> (http-response/ok
         (let [db-vals (->> (query-fn :read-associations {})
                            (pr)
                            (with-out-str))]
           (log/info "\n$$$$$$$ Response length:" (count db-vals))
           db-vals))
        (http-response/header "Content-Type" "text/plain; charset=utf-8"))))
