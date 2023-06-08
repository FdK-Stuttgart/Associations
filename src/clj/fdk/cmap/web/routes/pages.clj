(ns fdk.cmap.web.routes.pages
  (:require
    [fdk.cmap.web.middleware.exception :as exception]
    [fdk.cmap.web.pages.layout :as layout]
    [integrant.core :as ig]
    [reitit.ring.middleware.muuntaja :as muuntaja]
    [reitit.ring.middleware.parameters :as parameters]
    [ring.middleware.anti-forgery :refer [wrap-anti-forgery]]
    [ring.util.response :refer [redirect file-response]]
    [clojure.tools.logging :as log]
    [fdk.cmap.web.routes.utils :as utils]
    )
  (:import [java.io File FileInputStream FileOutputStream])
  )

(defn wrap-page-defaults []
  ;; See https://clojureverse.org/t/anti-forgery-token-error-when-calling-a-clojure-function-in-luminus/7965/6
  #_
  (let [error-page (layout/error-page
                     {:status 403
                      :title "Invalid anti-forgery token"})]
    #(wrap-anti-forgery % {:error-response error-page})))

(defn home [request]
  (layout/render request "home.html"))

(defn imported [request]
  (let [filename (get-in request [:path-params :filename])]
    ;; (log/info "\n########### [imported] filename" filename)
    (let [
          routes (get-in      (utils/route-data request) [:routes 1 1])
          {:keys [query-fn]} (utils/route-data request)
          ]
      (log/info "\n########### [imported] routes\n" (keys routes))
      (log/info "\n########### [imported] :query-fn\n" query-fn)
      #_
      (let [db-vals (->> (query-fn
                          ;; :insert-association
                          :read-association
                          {})
                         (pr)
                         (with-out-str))]
        (log/info "\n$$$ Response length:" (count db-vals))
        db-vals))

    (layout/render request "imported.html")))

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
      (log/info "\n########### [upload-file] size: " size)
      #_
      (let [source (.getChannel in)
            dest   (.getChannel out)]
        (.transferFrom dest source 0 (.size source))
        (.flush out)))))

(defn post-handler [{{:keys [file]} :params}]
  (upload-file resource-path file)
  (redirect "/imported"))

;; Routes
(defn page-routes [_opts]
  [
   ;; http://localhost:3000/
   ["/" {:get home}]

   ;; http://localhost:3000/import
   ;; :get works
   ;; :post returns "Not allowed"

   ;; curl --header "Content-Type: application/json" \
   ;;      --request POST \
   ;;      --data '{"username":"xyz","password":"xyz"}' \
   ;;      'localhost:3000/import'
   ;; :put returns a web page with "Invalid anti-forgery token"

   ["/import" {:post post-handler
               ;; :import true
               #_{:interceptors [#_add-user]}}]

   ["/imported" {:get imported}]

   ])

(defn route-data [opts]
  (merge
   opts
   {:middleware
    [;; Default middleware for pages
     (wrap-page-defaults)
     ;; query-params & form-params
     parameters/parameters-middleware
     ;; encoding response body
     muuntaja/format-response-middleware
     ;; exception handling
     exception/wrap-exception]}))

(derive :reitit.routes/pages :reitit/routes)

(defmethod ig/init-key :reitit.routes/pages
  [_ {:keys [base-path]
      :or   {base-path ""}
      :as   opts}]
  (layout/init-selmer!)
  [base-path (route-data opts) (page-routes opts)])
