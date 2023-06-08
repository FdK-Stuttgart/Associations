(ns fdk.cmap.web.routes.api
  (:require
    [fdk.cmap.web.controllers.health :as health]
    [fdk.cmap.web.middleware.exception :as exception]
    [fdk.cmap.web.middleware.formats :as formats]
    [integrant.core :as ig]
    [reitit.coercion.malli :as malli]
    [reitit.ring.coercion :as coercion]
    [reitit.ring.middleware.muuntaja :as muuntaja]
    [reitit.ring.middleware.parameters :as parameters]
    [reitit.swagger :as swagger]
    [clojure.tools.logging :as log]
    )
  )

;; Routes
(defn api-routes [_opts]
  [
   ;; http://localhost:3000/api/swagger.json
   ["/swagger.json"
    {:get {:no-doc  true
           :swagger {:info {:title "fdk.cmap API"}}
           :handler (swagger/create-swagger-handler)}}]

   ;; http://localhost:3000/api/health
   ["/health"
    {:get
     health/healthcheck!}]

   ;; http://localhost:3000/api/db-vals-1-2?x=1&y=2
   ["/db-vals-1-2"
    {:get
     {:parameters {:query {:x int? :y int?}}
      :handler health/read-db}}]

   ;; http://localhost:3000/api/db-vals
   ["/db-vals" {:get health/read-db}]

   ["/import" {:post
               {
                :handler health/write-db}
               }]
   ]
  )

(defn route-data
  [opts]
  (merge
    opts
    {:coercion   malli/coercion
     :muuntaja   formats/instance
     :swagger    {:id ::api}
     :middleware [;; query-params & form-params
                  parameters/parameters-middleware
                  ;; content-negotiation
                  muuntaja/format-negotiate-middleware
                  ;; encoding response body
                  muuntaja/format-response-middleware
                  ;; exception handling
                  coercion/coerce-exceptions-middleware
                  ;; decoding request body
                  muuntaja/format-request-middleware
                  ;; coercing response bodys
                  coercion/coerce-response-middleware
                  ;; coercing request parameters
                  coercion/coerce-request-middleware
                  ;; exception handling
                  exception/wrap-exception]}))

(derive :reitit.routes/api :reitit/routes)

(defmethod ig/init-key :reitit.routes/api
  [_ {:keys [base-path]
      :or   {base-path ""}
      :as   opts}]
  [base-path (route-data opts) (api-routes opts)])
