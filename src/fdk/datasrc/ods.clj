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

(defn contact [row]
  (text-at-position 5 row))

(def contacts
  "A list of indexed hash-maps:
  '({:idx 0 :contact \"...\"}
    {:idx 1 :contact \"...\"}
    {:idx 2 :contact \"...\"})"
  (->> (range (.getRowCount sheet))
       (drop 1)  ;; skip column header
       #_(take 3)
       (map contact)
       ;; trim right, (s/replace s "\n" " ") (s/replace s "  " " ")
       (map s/trim)
       (map-indexed (fn [i a] {:idx i :contact a}))
       ))

(defn web-page [row]
  (text-at-position 6 row))

(def web-pages
  "A list of indexed hash-maps:
  '({:idx 0 :web-page \"...\"}
    {:idx 1 :web-page \"...\"}
    {:idx 2 :web-page \"...\"})"
  (->> (range (.getRowCount sheet))
       (drop 1)  ;; skip column header
       #_(take 3)
       (map contact)
       ;; trim right, (s/replace s "\n" " ") (s/replace s "  " " ")
       (map s/trim)
       (map-indexed (fn [i a] {:idx i :web-page a}))
       ))

(def ms
  "A list of indexed hash-maps:
  [{:idx 0 :name \"...\" :address \"...\" :desc \"...\"}
   {:idx 1 :name \"...\" :address \"...\" :desc \"...\"}
   {:idx 2 :name \"...\" :address \"...\" :desc \"...\"}]"
  ;; TODO make sure the associations and addresses are:
  ;; 1. sorted and 2. of the same size
  (mapv (fn [as ad co we]
          (let [contact (:contact co)
                web-page (:web-page we)]
            (merge as ad {:desc (format "%s\n\n%s" contact web-page)})))
        associations addresses contacts web-pages))
