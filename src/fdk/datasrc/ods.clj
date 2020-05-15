(ns fdk.datasrc.ods
  (:require
   [utils.core :refer :all]
   [clojure.string :as s]
   [fdk.data :as data]
   [clojure.inspector :refer :all])
  (:import org.odftoolkit.simple.SpreadsheetDocument))

(defn document []
  (SpreadsheetDocument/loadDocument
   "resources/<filename>.ods"))

(def sheet (-> (document) (.getSheetByIndex 0)))

(defn association [row]
  (-> sheet
      (.getCellByPosition 0 row)
      (.getDisplayText)))

(def associations
  (->> (range (.getRowCount sheet))
       (drop 1)  ;; skip column header
       #_(take 3)
       (map association)
       ;; trim right, (s/replace s "\n" " ") (s/replace s "  " " ")
       (map s/trim)
       (map (fn [a] (s/replace a "\n" " ")))
       (map (fn [a] (s/replace a "  " " ")))
       (map (fn [a] (s/replace a "  " " ")))
       (map (fn [a] (s/replace a "e. V." "e.V.")))
       (map (fn [a] (s/replace a " " " ")))
       (distinct)
       (remove empty?)
       ))

