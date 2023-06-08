(ns fdk.cmap.web.controllers.health
  (:require
    [ring.util.http-response :as http-response]
    [ring.util.response :refer [redirect file-response]]
    [fdk.cmap.web.routes.utils :as utils]
    [clojure.tools.logging :as log]
    )
  (:import
   [java.io File FileInputStream FileOutputStream]
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

(def resource-path "/tmp/")

(defn file-path [path & [filename]]
  (java.net.URLDecoder/decode
   (str path File/separator filename)
   "utf-8"))

(defn upload-file
  "uploads a file to the target folder
   when :create-path? flag is set to true then the target path will be created"
  [path {:keys [tempfile size filename]}]
  (try
    (with-open [in (new FileInputStream tempfile)
                out (new FileOutputStream (file-path path filename))]
      (log/info "\n########### [health upload-file] size: " size)
      #_
      (let [source (.getChannel in)
            dest   (.getChannel out)]
        (.transferFrom dest source 0 (.size source))
        (.flush out)))))

(defn write-db
  [{{:strs [x y]} :form-params :as request}]
  ;; (println "x" x "y" y)      ; appears in the console
  ;; (log/debug "x" x "y" y)    ; appears in the console & log/fdk.cmap.log
  (let [{:keys [query-fn]} (utils/route-data request)]
    (let [file (get-in request [:params :file])]
      (upload-file resource-path file)
      #_
      (let [
            db-vals (->> (query-fn :insert-association {})
                         (pr)
                         (with-out-str))]
        (log/info "\n$$$ Response length:" (count db-vals))
        db-vals))
    (redirect "/")
    ))
