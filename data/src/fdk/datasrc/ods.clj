(ns fdk.datasrc.ods
  (:require
   [clojure.string :as cstr]
   [fdk.common :as com]
   [djy.char :as djy]
   ;; [clojure.inspector :refer :all]
   ;; [taoensso.timbre :as timbre :refer []]
   )
  (:import org.odftoolkit.simple.SpreadsheetDocument))

(defn- column-idx [row-letter]
  {:pre [(char? row-letter)]}
  (.indexOf (djy/char-range \A \Z) (djy/upper-case row-letter)))

(def document-data
  "Reevaluate this when the ods file changed"
  (SpreadsheetDocument/loadDocument
   "resources/Vereinsinformationen_öffentlich_Stadtteilkarte.ods"))

(defn document
  [] document-data
  #_([]
   #_(document "resources/Vereinsinformationen_öffentlich_Stadtteilkarte.ods")
   document-data)
  #_([fname]
   (SpreadsheetDocument/loadDocument fname)))

(defn sheet0 [fname] (-> (document
                         #_fname) (.getSheetByIndex 0)))

(defn sheet-content [sheet]
  (drop 1 ;; skip column header
        (
         identity
         ;; drop 6
         (
          identity
          ;; take 8
          (range (.getRowCount sheet))))))

(defn text-at-position [sheet p row]
  (.getDisplayText (.getCellByPosition sheet p row)))

(defn address [sheet row] (text-at-position sheet (column-idx \C) row))

(defn row-nr [idx] (+ idx 2))

(defn- cleanup [a]
  ((apply comp (reverse [
                         cstr/trim
                         ;; repeating twice should be enough; simple and dirty
                         (fn [a] (cstr/replace a " \n" "\n"))
                         (fn [a] (cstr/replace a " \n" "\n"))
                         (fn [a] (cstr/replace a "  " " "))
                         (fn [a] (cstr/replace a "  " " "))
                         (fn [a] (cstr/replace a " " " "))
                         ;; e.V. without space is incorrect
                         ;; (fn [a] (cstr/replace a "e. V." "e.V."))
                         ]))
   a))

(defn calc-addresses
  "A list of indexed hash-maps:
  '({:idx 0 :address \"...\"}
    {:idx 1 :address \"...\"}
    {:idx 2 :address \"...\"})"
  [sheet]
  (->> sheet
       (sheet-content)
       (map (comp
             (fn [a] (cstr/replace a "\n" ", "))
             cleanup
             (fn [row] (address sheet row))))
       (map-indexed (fn [i s] {:idx (row-nr i) :address s}))))

(defn addresses [sheet]
  (let [ks [:addresses]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! (fn [] (calc-addresses sheet)) ks))))

(defn association [sheet row] (text-at-position sheet (column-idx \A) row))

(defn calc-associations
  "A list of indexed hash-maps:
  '({:idx 0 :name \"...\"}
    {:idx 1 :name \"...\"}
    {:idx 2 :name \"...\"})"
  [sheet]
  (->> sheet
       (sheet-content)
       (map (comp
             (fn [a] (cstr/replace a "\n" " "))
             cleanup
             (fn [row] (association sheet row))))
       (map-indexed (fn [i s] {:idx (row-nr i) :name s}))))

(defn associations [sheet]
  (let [ks [:associations]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! (fn [] (calc-associations sheet)) ks))))

(defn city-district [sheet row] (text-at-position sheet (column-idx \D) row))

(defn calc-city-districts
  "A list of indexed hash-maps:
  '({:idx 0 :city-district \"...\"}
    {:idx 1 :city-district \"...\"}
    {:idx 2 :city-district \"...\"})"
  [sheet]
  (->> sheet
       (sheet-content)
       (map (comp
             cleanup
             (fn [row] (city-district sheet row))))
       (map-indexed (fn [i s] {:idx (row-nr i) :city-district s}))))

(defn city-districts [sheet]
  (let [ks [:city-districts]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! (fn [] (calc-city-districts sheet)) ks))))

(defn table-coordinates [sheet row] (text-at-position sheet (column-idx \E) row))

(defn calc-coordinates
  "A list of indexed hash-maps:
  '({:idx 0 :coordinates \"...\"}
    {:idx 1 :coordinates \"...\"}
    {:idx 2 :coordinates \"...\"})"
  [sheet]
  (->> sheet
       (sheet-content)
       (map (comp
             cleanup
             (fn [row] (table-coordinates sheet row))))
       (map-indexed (fn [i s] {:idx (row-nr i) :coordinates s}))))

(defn coordinates [sheet]
  (let [ks [:coordinates]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! (fn [] (calc-coordinates sheet)) ks))))

(defn contact [sheet row] (text-at-position sheet (column-idx \F) row))

(defn calc-contacts
  "A list of indexed hash-maps:
  '({:idx 0 :contact \"...\"}
    {:idx 1 :contact \"...\"}
    {:idx 2 :contact \"...\"})"
  [sheet]
  (->> sheet
       (sheet-content)
       (map (comp
             cleanup
             (fn [row] (contact sheet row))))
       (map-indexed (fn [i s] {:idx (row-nr i) :contact s}))))

(defn contacts [sheet]
  (let [ks [:contacts]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! (fn [] (calc-contacts sheet)) ks))))

(defn logo [sheet row]
  #_(println "logos" (text-at-position sheet (column-idx \G) row))
  (text-at-position sheet (column-idx \G) row))

(defn calc-logos
  "A list of indexed hash-maps:
  '({:idx 0 :web-page \"...\"}
    {:idx 1 :web-page \"...\"}
    {:idx 2 :web-page \"...\"})"
  [sheet]
  (->> sheet
       (sheet-content)
       (map (comp
             (fn [urls]
               #_(println "(cstr/split-lines urls)" (cstr/split-lines urls))
               (cstr/split-lines urls))
             cleanup
             (fn [row] (logo sheet row))))
       (map-indexed (fn [i a] {:idx (row-nr i) :logos a}))))

(defn logos [sheet]
  (let [ks [:web-pages]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! (fn [] (calc-logos sheet)) ks))))

(defn web-page [sheet row] (text-at-position sheet (column-idx \H) row))

(defn calc-web-pages
  "A list of indexed hash-maps:
  '({:idx 0 :web-page \"...\"}
    {:idx 1 :web-page \"...\"}
    {:idx 2 :web-page \"...\"})"
  [sheet]
  (->> sheet
       (sheet-content)
       (map (comp
             cleanup
             (fn [row] (web-page sheet row))))
       (map-indexed (fn [i a] {:idx (row-nr i) :web-page a}))))

(defn web-pages [sheet]
  (let [ks [:web-pages]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! (fn [] (calc-web-pages sheet)) ks))))

(defn goal
  "umbenannt auf Ziele des Vereins"
  [sheet row] (text-at-position sheet (column-idx \I) row))

(defn calc-goals
  "
  TODO Natural Language Understanding (NLU)
  See https://github.com/huggingface/transformers
  Or just count word frequency

  A list of indexed hash-maps:
  '({:idx 0 :goal \"...\"}
    {:idx 1 :goal \"...\"}
    {:idx 2 :goal \"...\"})"
  [sheet]
  (->> sheet
       (sheet-content)
       (map (comp
             cleanup
             (fn [row] (goal sheet row))))
       (map-indexed (fn [i s] {:idx (row-nr i) :goal s}))))

(defn goals [sheet]
  (let [ks [:goals]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! (fn [] (calc-goals sheet)) ks))))

(defn activity
  [sheet row] (text-at-position sheet (column-idx \J) row))

(defn calc-activities
  "
  TODO Natural Language Understanding (NLU)
  See https://github.com/huggingface/transformers
  Or just count word frequency

  A list of indexed hash-maps:
  '({:idx 0 :activity \"...\"}
    {:idx 1 :activity \"...\"}
    {:idx 2 :activity \"...\"})"
  [sheet]
  (->> sheet
       (sheet-content)
       (map (comp
             cleanup
             (fn [row] (activity sheet row))))
       (map-indexed (fn [i s] {:idx (row-nr i) :activity s}))))

(defn activities [sheet]
  (let [ks [:goals]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! (fn [] (calc-activities sheet)) ks))))

(defn calc-read-table
  "A list of indexed hash-maps:
  [{:idx 0 :name \"...\" :address \"...\" :desc \"...\"}
   {:idx 1 :name \"...\" :address \"...\" :desc \"...\"}
   {:idx 2 :name \"...\" :address \"...\" :desc \"...\"}]"
  [fname]
  ;; TODO make sure the associations and addresses are:
  ;; 1. sorted and 2. of the same size
  (let [s0 (sheet0 fname)]
    (mapv (fn [associations addresses cdistricts
              contacts web-pages goals activities
              coordinates logos]
            (let [contact (:contact contacts)
                  web-page (:web-page web-pages)]
              (merge associations
                     addresses
                     goals
                     cdistricts
                     {:desc (cstr/trim (cstr/join "\n\n" [contact web-page]))}
                     activities
                     coordinates
                     logos)))
          (associations s0)
          (addresses s0)
          (city-districts s0)
          (contacts s0)
          (web-pages s0)
          (goals s0)
          (activities s0)
          (coordinates s0)
          (logos s0))))

(defn read-table [fname]
  (let [ks [:table]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! (fn [] (calc-read-table fname)) ks))))

(def default-category "Sonstiges")

(defn reset-cache!
  "(fdk.datasrc.ods/reset-cache! \"resources/Vereinsinformationen_öffentlich_Stadtteilkarte.ods\")"
  [fname]
  (swap! com/cache (fn [_] {}))
  (let [tbeg (System/currentTimeMillis)]
    ;; enforce evaluation; can't be done by (force (all-rankings))
    (dorun
     (calc-read-table fname))
    (printf "%s chars cached in %s ms"
            (count (str @com/cache)) (- (System/currentTimeMillis) tbeg))))
