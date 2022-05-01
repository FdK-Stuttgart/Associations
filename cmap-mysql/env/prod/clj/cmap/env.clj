(ns cmap.env
  (:require [clojure.tools.logging :as log]))

(def defaults
  {:init
   (fn []
     (log/info "\n-=[cmap started successfully]=-"))
   :stop
   (fn []
     (log/info "\n-=[cmap has shut down successfully]=-"))
   :middleware identity})
