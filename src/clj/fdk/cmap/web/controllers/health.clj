(ns fdk.cmap.web.controllers.health
  (:require
    [ring.util.http-response :as http-response]
    [ring.util.response :refer [redirect file-response]]
    [fdk.cmap.web.routes.utils :as utils]
    [clojure.tools.logging :as log]
    [fdk.data.ods :as ods]
    [clojure.string :as s]
    [clojure.set]
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

;; (defn- file-path [path & [filename]]
;;   (java.net.URLDecoder/decode
;;    (str path File/separator filename)
;;    "utf-8"))

(defn read-ods-table
  "uploads a file to the target folder
   when :create-path? flag is set to true then the target path will be created"
  [path {:keys [tempfile size filename] :as prm-file}]
  ;; (log/info "\n########### [health read-ods-table] size: " size)
  ;; (log/info "\n########### [health read-ods-table] prm-file " prm-file)
  (let [ods-table (ods/read-table tempfile)]
    (log/info "\n########### [health read-ods-table] ods-table rows: " (count ods-table))
    ods-table
    #_
    (try
      (with-open [in (new FileInputStream tempfile)
                  out (new FileOutputStream (file-path path filename))]
        (let [source (.getChannel in)
              dest   (.getChannel out)]
          (.transferFrom dest source 0 (.size source))
          (.flush out))))))

;; (fn [m] (dissoc m :lng :lat))
;; (fn [m] (assoc-in m [:coords] (vals (select-keys m [:lng :lat]))))
;; (fn [m] (rename-keys m {:associationid :k
;;                         :addressline1 :addr
;;                         :districtlist :districts
;;                         :mail :email
;;                         :activities_text :activities
;;                         :goals_text :goals}))
;; (fn [m] (update-in m [:name] (fn [s] (s/replace s " e. V." ""))))
;; (fn [m] (select-keys m [:associationid
;;                         :name
;;                         :street
;;                         :postcode-city
;;                         :city
;;                         :activities_text
;;                         :goals_text
;;                         :addressline1
;;                         :districtlist
;;                         :mail
;;                         :lng
;;                         :lat
;;                         :imageurl
;;                         :links
;;                         :socialmedia

;;                         ;; :contacts
;;                         :pobox :phone :fax
;;                         ]))

(defn insert-association [query-fn row]
  (let [[lon lat] (-> row :coordinates (s/split #" "))
        address (-> row :address (s/split #", "))
        street (-> address first)
        [postcode city]  (-> address second (s/split #" "))
        activities_text (-> row :activity)
        goals_text (-> row :goal)
        districtList nil ;; "null"
        activityList nil ;; "[\"03913c8d-c21d-470a-90fc-b3032fc33f4a\"]"

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
      ;; (log/info "\n$$$ :insert-association response length:" (count db-vals))
      ;; (log/info "\n$$$ :insert-association response:" db-vals)
      db-vals)))

(defn insert-contact [query-fn row]
  (let [contactId "00811481-cbb1-4124-be6f-67c418dea1c5"
        [phone-raw mail] (-> row :desc (s/split #"\n"))
        [_ phone] (s/split phone-raw #"Tel. ")
        associationId "7f1b41a8-7ae1-4457-81cb-985993bbb354" ;; :id        ;;
        orderIndex 1 ;; :index     ;;

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
    ;; (log/info "\n$$$ row" row)
    (log/info "\n$$$ vals" vals)
    (let [db-vals (->> (query-fn :insert-contact vals)
                       (pr)
                       (with-out-str))]
      ;; (log/info "\n$$$ :insert-contact response length:" (count db-vals))
      (log/info "\n$$$ :insert-contact response:" db-vals)
      db-vals)))

(defn update-contact [query-fn row]
  (let [vals row]
    (let [db-vals (->> (query-fn :update-contact vals)
                       (pr)
                       (with-out-str))]
      ;; (log/info "\n$$$ :update-contact response length:" (count db-vals))
      (log/info "\n$$$ :update-contact response:" db-vals)
      db-vals)))

(defn update-image [query-fn row]
  (let [vals row]
    (let [db-vals (->> (query-fn :update-image vals)
                       (pr)
                       (with-out-str))]
      ;; (log/info "\n$$$ :update-image response length:" (count db-vals))
      (log/info "\n$$$ :update-image response:" db-vals)
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
    (log/info "\n$$$ row" row)
    (let [db-vals (->> (query-fn :insert-image vals)
                       (pr)
                       (with-out-str))]
      ;; (log/info "\n$$$ :insert-image response length:" (count db-vals))
      (log/info "\n$$$ :insert-image response:" db-vals)
      db-vals)))

(defn update-link [query-fn row]
  (let [vals row]
    (let [db-vals (->> (query-fn :update-link vals)
                       (pr)
                       (with-out-str))]
      ;; (log/info "\n$$$ :update-link response length:" (count db-vals))
      (log/info "\n$$$ :update-link response:" db-vals)
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
    (log/info "\n$$$ row" row)
    (let [db-vals (->> (query-fn :insert-link vals)
                       (pr)
                       (with-out-str))]
      ;; (log/info "\n$$$ :insert-link response length:" (count db-vals))
      (log/info "\n$$$ :insert-link response:" db-vals)
      db-vals)))

(defn update-socialmedia [query-fn row]
  (let [vals row]
    (log/info "\n$$$ row" row)
    (let [db-vals (->> (query-fn :update-socialmedia vals)
                       (pr)
                       (with-out-str))]
      ;; (log/info "\n$$$ :update-socialmedia response length:" (count db-vals))
      (log/info "\n$$$ :update-socialmedia response:" db-vals)
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
    (log/info "\n$$$ row" row)
    (let [db-vals (->> (query-fn :insert-socialmedia vals)
                       (pr)
                       (with-out-str))]
      ;; (log/info "\n$$$ :insert-socialmedia response length:" (count db-vals))
      (log/info "\n$$$ :insert-socialmedia response:" db-vals)
      db-vals)))

(defn write-db
  [{{:strs [x y]} :form-params :as request}]
  ;; (println "x" x "y" y)      ; appears in the console
  ;; (log/debug "x" x "y" y)    ; appears in the console & log/fdk.cmap.log
  (log/debug "request\n" request)    ; appears in the console & log/fdk.cmap.log
  (let [{:keys [query-fn]} (utils/route-data request)]
    (let [file (get-in request [:params :file])
          table (read-ods-table resource-path file)]
      (let [rowx (first table)
            row (clojure.set/rename-keys rowx {:idx :id})]
        ;; For mapping see $dec/fdk/map/app-form/src/app/services/ods-table/ods.ts
        ;; :address :coordinates :city-district :desc :logos :name :goal :activity :id

        ;; $associations = json_decode($postdata);
        (insert-association query-fn row)
        (update-contact query-fn row)

        ;; $contacts = $request->contacts;
        (insert-contact query-fn row)

        (update-image query-fn row)
        ;; $images = $request->images;
        (insert-image query-fn row)
        (update-link query-fn row)
        ;; $links = $request->links;
        (insert-link query-fn row)
        (update-socialmedia query-fn row)
        ;; $socialMedia = $request->socialMedia;
        (insert-socialmedia query-fn row)
        ))
    (redirect "/")))
