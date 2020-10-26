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

(defn calc-addresses-fn []
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
      (com/cache! calc-addresses-fn ks))))

(defn association [row] (text-at-position (column-idx \A) row))

(defn calc-associations-fn
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
      (com/cache! calc-associations-fn ks))))

(defn contact [row] (text-at-position (column-idx \F) row))

(defn calc-contacts-fn
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
      (com/cache! calc-contacts-fn ks))))

(defn web-page [row] (text-at-position (column-idx \G) row))

(defn calc-web-pages-fn
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
      (com/cache! calc-web-pages-fn ks))))

(defn engagement [row] (text-at-position (column-idx \H) row))

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
       (map-indexed (fn [i s] {:idx (row-nr i) :engagement s}))))

(defn calc-read-table-fn
  "A list of indexed hash-maps:
  [{:idx 0 :name \"...\" :address \"...\" :desc \"...\"}
   {:idx 1 :name \"...\" :address \"...\" :desc \"...\"}
   {:idx 2 :name \"...\" :address \"...\" :desc \"...\"}]"
  []
  ;; TODO make sure the associations and addresses are:
  ;; 1. sorted and 2. of the same size
  (mapv (fn [as ad co we en]
          (let [contact (:contact co)
                web-page (:web-page we)]
            (merge as ad en {:desc (format "%s\n\n%s" contact web-page)})))
        (associations) (addresses) (contacts) (web-pages) (engagements)))

(defn read-table []
  (let [ks [:table]]
    (if-let [v (get-in @com/cache ks)]
      v
      (com/cache! calc-read-table-fn ks))))

(def default-category "Sonstiges")

(defn reset-cache! []
  (swap! com/cache (fn [_] {}))
  (let [tbeg (System/currentTimeMillis)]
    ;; enforce evaluation; can't be done by (force (all-rankings))
    (dorun
     (calc-read-table-fn))
    (printf "%s chars cached in %s ms"
            (count (str @com/cache)) (- (System/currentTimeMillis) tbeg))))
