(ns fdk.datasrc.ods
  (:require
   [utils.core :refer :all]
   [clojure.string :as s]
   [fdk.data :as data]
   [fdk.common :as com]
   [djy.char :as djy]
   [clojure.inspector :refer :all]
   [taoensso.timbre :as timbre :refer []]
   )
  (:import org.odftoolkit.simple.SpreadsheetDocument))

(defn- column-idx [row-letter]
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

(defn address [row] (text-at-position (column-idx \C) row))

(defn row-nr [idx] (+ idx 2))

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

(defn calc-addresses []
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
       (map-indexed (fn [i s] {:idx (row-nr i) :address s}))))

(defn addresses []
  (let [ks [:addresses]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! calc-addresses ks))))

(defn association [row] (text-at-position (column-idx \A) row))

(defn calc-associations
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
       (map-indexed (fn [i s] {:idx (row-nr i) :name s}))))

(defn associations []
  (let [ks [:associations]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! calc-associations ks))))

(defn city-district [row] (text-at-position (column-idx \D) row))

(defn calc-city-districts
  "A list of indexed hash-maps:
  '({:idx 0 :city-district \"...\"}
    {:idx 1 :city-district \"...\"}
    {:idx 2 :city-district \"...\"})"
  []
  (->> (sheet-content)
       (map city-district)
       (map cleanup)
       (map-indexed (fn [i s] {:idx (row-nr i) :city-district s}))))

(defn city-districts []
  (let [ks [:city-districts]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! calc-city-districts ks))))

(defn contact [row] (text-at-position (column-idx \F) row))

(defn calc-contacts
  "A list of indexed hash-maps:
  '({:idx 0 :contact \"...\"}
    {:idx 1 :contact \"...\"}
    {:idx 2 :contact \"...\"})"
  []
  (->> (sheet-content)
       (map contact)
       (map cleanup)
       (map-indexed (fn [i s] {:idx (row-nr i) :contact s}))))

(defn contacts []
  (let [ks [:contacts]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! calc-contacts ks))))

(defn web-page [row] (text-at-position (column-idx \G) row))

(defn calc-web-pages
  "A list of indexed hash-maps:
  '({:idx 0 :web-page \"...\"}
    {:idx 1 :web-page \"...\"}
    {:idx 2 :web-page \"...\"})"
  []
  (->> (sheet-content)
       (map web-page)
       (map cleanup)
       (map-indexed (fn [i a] {:idx (row-nr i) :web-page a}))))

(defn web-pages []
  (let [ks [:web-pages]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! calc-web-pages ks))))

(defn goal
  "umbenannt auf Ziele des Vereins"
  [row] (text-at-position (column-idx \H) row))

(defn goals
  "
  TODO Natural Language Understanding (NLU)
  See https://github.com/huggingface/transformers
  Or just count word frequency

  A list of indexed hash-maps:
  '({:idx 0 :goal \"...\"}
    {:idx 1 :goal \"...\"}
    {:idx 2 :goal \"...\"})"
  []
  (->> (sheet-content)
       (map goal)
       (map cleanup)
       (map-indexed (fn [i s] {:idx (row-nr i) :goal s}))))

(defn activity
  [row] (text-at-position (column-idx \I) row))

(defn activities
  "
  TODO Natural Language Understanding (NLU)
  See https://github.com/huggingface/transformers
  Or just count word frequency

  A list of indexed hash-maps:
  '({:idx 0 :activity \"...\"}
    {:idx 1 :activity \"...\"}
    {:idx 2 :activity \"...\"})"
  []
  (->> (sheet-content)
       (map activity)
       (map cleanup)
       (map-indexed (fn [i s] {:idx (row-nr i) :activity s}))))

(defn calc-read-table
  "A list of indexed hash-maps:
  [{:idx 0 :name \"...\" :address \"...\" :desc \"...\"}
   {:idx 1 :name \"...\" :address \"...\" :desc \"...\"}
   {:idx 2 :name \"...\" :address \"...\" :desc \"...\"}]"
  []
  ;; TODO make sure the associations and addresses are:
  ;; 1. sorted and 2. of the same size
  (mapv (fn [associations addresses cdistricts
            contacts web-pages goals activities]
          (let [contact (:contact contacts)
                web-page (:web-page web-pages)]
            (merge associations
                   addresses
                   goals
                   cdistricts
                   {:desc (format "%s\n\n%s" contact web-page)}
                   activities)))
        (associations) (addresses) (city-districts)
        (contacts) (web-pages) (goals) (activities)))

(defn read-table []
  (let [ks [:table]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! calc-read-table ks))))

(def default-category "Sonstiges")

(defn reset-cache!
  "(fdk.datasrc.ods/reset-cache!)"
  []
  (swap! com/cache (fn [_] {}))
  (let [tbeg (System/currentTimeMillis)]
    ;; enforce evaluation; can't be done by (force (all-rankings))
    (dorun
     (calc-read-table))
    (printf "%s chars cached in %s ms"
            (count (str @com/cache)) (- (System/currentTimeMillis) tbeg))))
