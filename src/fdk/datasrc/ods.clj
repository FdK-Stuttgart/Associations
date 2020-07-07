(ns fdk.datasrc.ods
  (:require
   [utils.core :refer :all]
   [clojure.string :as s]
   [fdk.data :as data]
   [clojure.inspector :refer :all])
  (:import org.odftoolkit.simple.SpreadsheetDocument))

(defn document []
  (SpreadsheetDocument/loadDocument
   "resources/Vereinsinformationen_öffentlich_Stadtteilkarte.ods"))

(def sheet (-> (document) (.getSheetByIndex 0)))

(defn text-at-position [p row]
  (-> sheet
      (.getCellByPosition p row)
      (.getDisplayText)))

(defn address [row]
  (text-at-position 2 row))

(def addresses
  "A list of indexed hash-maps:
  '({:idx 0 :address \"...\"}
    {:idx 1 :address \"...\"}
    {:idx 2 :address \"...\"})"
  (->> (range (.getRowCount sheet))
       (drop 1)  ;; skip column header
       #_(take 3)
       (map address)
       ;; trim right, (s/replace s "\n" " ") (s/replace s "  " " ")
       (map s/trim)
       (map (fn [a] (s/replace a " \n" "\n")))
       (map (fn [a] (s/replace a " \n" "\n")))
       (map (fn [a] (s/replace a "\n" ", ")))
       (map (fn [a] (s/replace a "  " " ")))
       (map (fn [a] (s/replace a "  " " ")))
       (map (fn [a] (s/replace a " " " ")))
       (map-indexed (fn [i a] {:idx i :address a}))
       ))

(defn association [row]
  (text-at-position 0 row))

(def associations
  "A list of indexed hash-maps:
  '({:idx 0 :name \"...\"}
    {:idx 1 :name \"...\"}
    {:idx 2 :name \"...\"})"
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
       (map-indexed (fn [i a] {:idx i :name a}))
       ))

(def ms
  "A list of indexed hash-maps:
  [{:idx 0 :name \"...\" :address \"...\"}
    {:idx 1 :name \"...\" :address \"...\"}
    {:idx 2 :name \"...\" :address \"...\"}]"
  ;; TODO make sure the associations and addresses are:
  ;; 1. sorted and 2. of the same size
  (mapv (fn [as ad] (merge as ad))
        associations addresses))
