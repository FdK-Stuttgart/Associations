(ns fdk.cmap.web.controllers.health
  (:require
    [ring.util.http-response :as http-response]
    [ring.util.response :refer [redirect file-response]]
    [fdk.cmap.web.routes.utils :as utils]
    [clojure.tools.logging :refer :all]
    [fdk.data.ods :as ods]
    [clojure.string :as s]
    [clojure.set]
    [clojure.inspector :refer :all]
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
  ;; (debug "x" x "y" y)    ; appears in the console & log/fdk.cmap.log
  (let [{:keys [query-fn]} (utils/route-data request)]
    ;; See also
    ;; (rf/reg-event-fx :fetch-from-db ...
    ;;   {:http-xhrio {...
    ;;                 :response-format (ajax/raw-response-format)}})
    (-> (http-response/ok
         (let [db-vals (->> (query-fn :read-associations {})
                            (pr)
                            (with-out-str))]
           (println "\n$$$ Response length:" (count db-vals))
           db-vals))
        (http-response/header "Content-Type" "text/plain; charset=utf-8"))))

(def resource-path "/tmp/")

;; (defn- file-path [path & [filename]]
;;   (java.net.URLDecoder/decode
;;    (str path File/separator filename)
;;    "utf-8"))

(defn read-ods-table
  "uploads a file to the target folder
   when :create-path? flag is set to true then the target path will be created"
  [path {:keys [tempfile size filename] :as prm-file}]
  ;; (println "\n[health read-ods-table] size: " size)
  ;; (println "\n[health read-ods-table] prm-file " prm-file)
  (let [ods-table (ods/read-table tempfile)]
    (println "[health read-ods-table] (count ods-table)" (count ods-table))
    ods-table
    #_
    (try
      (with-open [in (new FileInputStream tempfile)
                  out (new FileOutputStream (file-path path filename))]
        (let [source (.getChannel in)
              dest   (.getChannel out)]
          (.transferFrom dest source 0 (.size source))
          (.flush out))))))

(defn insert-association [query-fn row]
  (let [lon (:lon row)
        lat (:lat row)
        street (:street row)
        city (:city row)
        postcode (:postcode row)
        activities_text (-> row :activities :text)
        goals_text (-> row :goals :text)
        districtList nil ;; "[\"03913c8d-c21d-470a-90fc-b3032fc33f4a\"]"
        activityList nil ;; "null"

        vals
        ;; (select-keys row [:id :name])
        (zipmap
         [
          :id
          :name
          :shortName
          :lat
          :lng
          :addressLine1
          :addressLine2
          :addressLine3
          :street
          :postcode
          :city
          :country
          :goals_format
          :goals_text
          :activities_format
          :activities_text
          :districtList
          :activityList
          ]
         [
          (:id row)   ;; "000bd9bd-3cb1-4ea6-b65d-b55e447254b0"
          (:name row)  ;; "Freunde des Italienischen Kulturinstituts in Stuttgart e. V."
          ""               ;; :shortName
          lat              ;; 48.765011
          lon              ;; 9.169502
          ""               ;; :addressLine1
          ""               ;; :addressLine2
          ""               ;; :addressLine3
          street           ;; "Kolbstraße 6"
          postcode         ;; "70178"
          city             ;; "Stuttgart"
          ""               ;; :country
          "plain"          ;; :goals_format
          goals_text       ;; "Bekanntmachung der italienischen Kultur und Sprache."
          "plain"          ;; :activities_format
          activities_text
          districtList
          activityList
          ;; :current 1
          ])]
    (let [db-vals (->> (query-fn :insert-association vals)
                       (pr)
                       (with-out-str))]
      ;; (println ":insert-association response length:" (count db-vals))
      (println "[:insert-association] response db-vals:" db-vals)
      (println "[:insert-association] (:id row):" (:id row))
      db-vals)))

(defn insert-contact [query-fn row]
  ;; (println "[insert-contact] (keys row)" (keys row))
  (let [
        contactId (:id row) ;; "00811481-cbb1-4124-be6f-67c418dea1c5"
        [phone-raw mail _] [(:phone row) (:mail row)]
        #_
        ((comp
          (fn [s] (println "1 [insert-contact]" s) s)
          (fn [s] (s/split s #"\n"))
          (fn [s] (println "0 [insert-contact]" s) s)
          )
         row)
        ]
    ;; (println "[phone-raw mail]" [phone-raw mail])
    (let [
          [_ phone] (s/split phone-raw #"Tel. ")
          associationId (:associationId row)  ;; "7f1b41a8-7ae1-4457-81cb-985993bbb354"
          orderIndex 1

          vals
          (zipmap [:contactId ;; :id
                   :contactName
                   :poBox
                   :phone
                   :mail
                   :fax
                   :id        ;; associationId
                   :index     ;; orderIndex
                   ]
                  [contactId
                   "" ;; :contactName
                   "" ;; :poBox
                   phone
                   mail ;; "bawue@juma-ev.de"
                   ""   ;; fax
                   associationId
                   orderIndex
                   ;; 1 ;; current
                   ])]
      ;; (println "vals" vals)
      (let [db-vals (->> (query-fn :insert-contact vals)
                         (pr)
                         (with-out-str))]
        ;; (println "\n$$$ :insert-contact response length:" (count db-vals))
        (println "[:insert-contact] response db-vals:" db-vals)
        db-vals))))

(defn update-contact [query-fn row]
  (let [vals row]
    (let [db-vals (->> (query-fn :update-contact vals)
                       (pr)
                       (with-out-str))]
      ;; (println "[:update-contact] response length:" (count db-vals))
      (println "[:update-contact] response db-vals:" db-vals)
      db-vals)))

(defn update-image [query-fn row]
  (let [vals row]
    (let [db-vals (->> (query-fn :update-image vals)
                       (pr)
                       (with-out-str))]
      ;; (println "\n$$$ :update-image response length:" (count db-vals))
      (println "\n$$$ :update-image response:" db-vals)
      db-vals)))

(defn insert-image [query-fn row]
  (let [vals
        (zipmap [:imageId
                 :url
                 :altText
                 :id
                 :index
                 :url
                 :altText
                 :id
                 :index
                 ] [])]
    (println "\n$$$ row" row)
    (let [db-vals (->> (query-fn :insert-image vals)
                       (pr)
                       (with-out-str))]
      ;; (println "\n$$$ :insert-image response length:" (count db-vals))
      (println "\n$$$ :insert-image response:" db-vals)
      db-vals)))

(defn update-link [query-fn row]
  (let [vals row]
    (let [db-vals (->> (query-fn :update-link vals)
                       (pr)
                       (with-out-str))]
      ;; (println "\n$$$ :update-link response length:" (count db-vals))
      (println "\n$$$ :update-link response:" db-vals)
      db-vals)))

(defn insert-link [query-fn row]
  (let [vals
        (zipmap [:linkId
                 :url
                 :linkText
                 :id
                 :index
                 :url
                 :linkText
                 :id
                 :index
                 ] [])]
    (println "\n$$$ row" row)
    (let [db-vals (->> (query-fn :insert-link vals)
                       (pr)
                       (with-out-str))]
      ;; (println "\n$$$ :insert-link response length:" (count db-vals))
      (println "\n$$$ :insert-link response:" db-vals)
      db-vals)))

(defn update-socialmedia [query-fn row]
  (let [vals row]
    (let [db-vals (->> (query-fn :update-socialmedia vals)
                       (pr)
                       (with-out-str))]
      ;; (println "\n$$$ :update-socialmedia response length:" (count db-vals))
      (println "\n$$$ :update-socialmedia response:" db-vals)
      db-vals)))

(defn insert-socialmedia [query-fn row]
  (let [vals
        (zipmap [:socialMediaId,
                 :platform
                 :url
                 :linkText
                 :id
                 :index
                 :platform
                 :url
                 :linkText
                 :id
                 :index
                 ] [])]
    (println "\n$$$ row" row)
    (let [db-vals (->> (query-fn :insert-socialmedia vals)
                       (pr)
                       (with-out-str))]
      ;; (println "\n$$$ :insert-socialmedia response length:" (count db-vals))
      (println "\n$$$ :insert-socialmedia response:" db-vals)
      db-vals)))

(defn write-file
  "
  (fdk.cmap.web.controllers.health/write-file fdk.cmap.web.controllers.health/file fdk.cmap.web.controllers.health/query-fn)
  "
  [file query-fn]
  (def file file)
  (def query-fn query-fn)
  (let [
          table (read-ods-table resource-path file)
          districts ((comp
                      (partial map :value))
                     (query-fn :read-districts-options {}))
          ]
      (def table table)
      ;; (inspect-tree table)
      (let [row
            ((comp
              (fn [r] (dissoc r
                              :activityList
                              :socialMediaLinks :links :images
                              ;; :contacts
                              :shortName :country
                              :goals_format :activities_format
                              :addressLine1 :addressLine2 :addressLine3))
              ;; (fn [r] (println "(keys r)" (keys r)) r)
              (fn [r] (clojure.set/rename-keys r {:idx :id :lng :lon}))
              first
              (partial map (partial ods/process-table-row districts)))
             table)
            ]
        ;; For mapping see $dec/fdk/map/app-form/src/app/services/ods-table/ods.ts

        ;; :goals :contacts :images :city :postcode :districts
        ;; :activities :country :links
        ;; TODO some keys are missing in the `row` hash map; needed are
        ;; :goals_text       ;; "Bekanntmachung der italienischen Kultur und Sprache."
        ;; :activities_text
        ;; :districtList
        ;; :activityList

        ;; $associations = json_decode($postdata);
        (insert-association query-fn row)
        (def row row)
        (println "[write-file] (count (:contacts row)):" (count (:contacts row)))
        (update-contact query-fn row)
        (println "[write-file] (boolean (seq (:contacts row))):" (boolean (seq (:contacts row))))
        (when (seq (:contacts row)) ;; ie when not empy
          (map (partial insert-contact query-fn) (:contacts row)))

        ;; (update-image query-fn row)
        ;; ;; $images = $request->images;
        ;; (insert-image query-fn row)
        ;; (update-link query-fn row)
        ;; ;; $links = $request->links;
        ;; (insert-link query-fn row)
        ;; (update-socialmedia query-fn row)
        ;; ;; $socialMedia = $request->socialMedia;
        ;; (insert-socialmedia query-fn row)
        )))

(defn write-db
  [{{:strs [x y]} :form-params :as request}]
  ;; (println "x" x "y" y)      ; appears in the console
  ;; (debug "x" x "y" y)    ; appears in the console & fdk.cmap.log
  ;; (debug "request\n" request)    ; appears in the console & fdk.cmap.log
  (let [{:keys [query-fn]} (utils/route-data request)
        file (get-in request [:params :file])]
    (write-file file query-fn)
    (redirect "/")))
