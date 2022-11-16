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
    (println "x" x "y" y)      ; appears in the console
    (log/debug "x" x "y" y)    ; appears in the console & log/fdk.cmap.log
    (http-response/ok
     (query-fn :read-associations {}))))
