(ns fdk.datasrc.ods
  (:require
   [utils.core :refer :all]
   [clojure.string :as s]
   [fdk.data :as data]
   [djy.char :as djy]
   [clojure.inspector :refer :all])
  (:import org.odftoolkit.simple.SpreadsheetDocument))

(defn- row-idx [row-letter]
  {:pre [(char? row-letter)]}
  (.indexOf (djy/char-range \A \Z) (djy/upper-case row-letter)))

(defn document []
  (SpreadsheetDocument/loadDocument
   "resources/Vereinsinformationen_öffentlich_Stadtteilkarte.ods"))

(defn sheet [] (-> (document) (.getSheetByIndex 0)))
(defn sheet-content [] (->> (range (.getRowCount (sheet)))
                            (drop 1)  ;; skip column header
                            #_(take 3)))

(defn text-at-position [p row]
  (-> (sheet)
      (.getCellByPosition p row)
      (.getDisplayText)))

(defn address [row] (text-at-position (row-idx \C) row))

(defn- cleanup [a]
  ((apply comp (reverse [
                         s/trim
                         ;; repeating twice should be enough; simple and dirty
                         (fn [a] (s/replace a " \n" "\n"))
                         (fn [a] (s/replace a " \n" "\n"))
                         (fn [a] (s/replace a "  " " "))
                         (fn [a] (s/replace a "  " " "))
                         (fn [a] (s/replace a " " " "))
                         (fn [a] (s/replace a "e. V." "e.V."))
                         ]))
   a))

(defn addresses []
  "A list of indexed hash-maps:
  '({:idx 0 :address \"...\"}
    {:idx 1 :address \"...\"}
    {:idx 2 :address \"...\"})"
  (->> (sheet-content)
       (map address)
       (map cleanup)
       (map (comp
             (fn [a] (s/replace a "\n" ", "))
             cleanup))
       (map-indexed (fn [i s] {:idx i :address s}))))

(defn association [row] (text-at-position (row-idx \A) row))

(defn associations
  "A list of indexed hash-maps:
  '({:idx 0 :name \"...\"}
    {:idx 1 :name \"...\"}
    {:idx 2 :name \"...\"})"
  []
  (->> (sheet-content)
       (map association)
       (map (comp
             (fn [a] (s/replace a "\n" " "))
             cleanup))
       (map-indexed (fn [i s] {:idx i :name s}))))

(defn contact [row] (text-at-position (row-idx \F) row))

(defn contacts
  "A list of indexed hash-maps:
  '({:idx 0 :contact \"...\"}
    {:idx 1 :contact \"...\"}
    {:idx 2 :contact \"...\"})"
  []
  (->> (sheet-content)
       (map contact)
       (map cleanup)
       (map-indexed (fn [i s] {:idx i :contact s}))))

(defn web-page [row] (text-at-position (row-idx \G) row))

(defn web-pages
  "A list of indexed hash-maps:
  '({:idx 0 :web-page \"...\"}
    {:idx 1 :web-page \"...\"}
    {:idx 2 :web-page \"...\"})"
  []
  (->> (sheet-content)
       (map contact)
       (map cleanup)
       (map-indexed (fn [i a] {:idx i :web-page a}))))

(defn engagement [row] (text-at-position (row-idx \H) row))

(defn engagements
  "
  TODO Natural Language Understanding (NLU)
  See https://github.com/huggingface/transformers
  Or just count word frequency

  A list of indexed hash-maps:
  '({:idx 0 :engagement \"...\"}
    {:idx 1 :engagement \"...\"}
    {:idx 2 :engagement \"...\"})"
  []
  (->> (sheet-content)
       (map engagement)
       (map cleanup)
       (map-indexed (fn [i s] {:idx i :engagement s}))))

(defn ms
  "A list of indexed hash-maps:
  [{:idx 0 :name \"...\" :address \"...\" :desc \"...\"}
   {:idx 1 :name \"...\" :address \"...\" :desc \"...\"}
   {:idx 2 :name \"...\" :address \"...\" :desc \"...\"}]"
  []
  ;; TODO make sure the associations and addresses are:
  ;; 1. sorted and 2. of the same size
  (mapv (fn [as ad co we]
          (let [contact (:contact co)
                web-page (:web-page we)]
            (merge as ad {:desc (format "%s\n\n%s" contact web-page)})))
        (associations) (addresses) (contacts) (web-pages)))
