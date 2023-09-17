(ns fdk.data.ods
  (:require
   [clojure.tools.logging :refer :all]
   [fdk.data.utils :refer :all]
   [clojure.string :as cstr]
   [djy.char :as djy]
   ;; [clojure.inspector :refer :all]
   ;; [taoensso.timbre :as timbre :refer []]
   )
  (:import org.odftoolkit.simple.SpreadsheetDocument))

(defonce cache (atom {}))

(defn cache!
  "Also return the cached value for further consumption."
  [calc-data-fn ks]
  (let [data (calc-data-fn)]
    #_(swap! cache update-in ks (fn [_] data))
    data))

(defn- column-idx [row-letter]
  {:pre [(char? row-letter)]}
  (.indexOf (djy/char-range \A \Z) (djy/upper-case row-letter)))

(defn sheet0 [fname] (-> fname
                         (SpreadsheetDocument/loadDocument)
                         (.getSheetByIndex 0)))

(defn sheet-rows [sheet]
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
       (sheet-rows)
       (map (comp
             (fn [a] (cstr/replace a "\n" ", "))
             cleanup
             (partial address sheet)))
       (map-indexed (fn [i s] {:idx (row-nr i) :address s}))))

(defn addresses [sheet]
  (let [ks [:addresses]]
    (if-let [v (get-in @cache ks)]
      v
      (cache! (fn [] (calc-addresses sheet)) ks))))

(defn association [sheet row] (text-at-position sheet (column-idx \A) row))

(defn calc-associations
  "A list of indexed hash-maps:
  '({:idx 0 :name \"...\"}
    {:idx 1 :name \"...\"}
    {:idx 2 :name \"...\"})"
  [sheet]
  (->> sheet
       (sheet-rows)
       (map (comp
             (fn [a] (cstr/replace a "\n" " "))
             cleanup
             (partial association sheet)))
       (map-indexed (fn [i s] {:idx (row-nr i) :name s}))))

(defn associations [sheet]
  (let [ks [:associations]]
    (if-let [v (get-in @cache ks)]
      v
      (cache! (fn [] (calc-associations sheet)) ks))))

(defn city-district [sheet row] (text-at-position sheet (column-idx \D) row))

(defn calc-city-districts
  "A list of indexed hash-maps:
  '({:idx 0 :city-district \"...\"}
    {:idx 1 :city-district \"...\"}
    {:idx 2 :city-district \"...\"})"
  [sheet]
  (->> sheet
       (sheet-rows)
       (map (comp
             cleanup
             (partial city-district sheet)))
       (map-indexed (fn [i s] {:idx (row-nr i) :city-district s}))))

(defn city-districts [sheet]
  (let [ks [:city-districts]]
    (if-let [v (get-in @cache ks)]
      v
      (cache! (fn [] (calc-city-districts sheet)) ks))))

(defn table-coordinates [sheet row] (text-at-position sheet (column-idx \E) row))

(defn calc-coordinates
  "A list of indexed hash-maps:
  '({:idx 0 :coordinates \"...\"}
    {:idx 1 :coordinates \"...\"}
    {:idx 2 :coordinates \"...\"})"
  [sheet]
  (->> sheet
       (sheet-rows)
       (map (comp
             cleanup
             (partial table-coordinates sheet)))
       (map-indexed (fn [i s] {:idx (row-nr i) :coordinates s}))))

(defn coordinates [sheet]
  (let [ks [:coordinates]]
    (if-let [v (get-in @cache ks)]
      v
      (cache! (fn [] (calc-coordinates sheet)) ks))))

(defn contact [sheet row] (text-at-position sheet (column-idx \F) row))

(defn calc-contacts
  "A list of indexed hash-maps:
  '({:idx 0 :contact \"...\"}
    {:idx 1 :contact \"...\"}
    {:idx 2 :contact \"...\"})"
  [sheet]
  ((comp
    #_(fn [s] (println "1" s) s)
    (partial map-indexed (fn [i s] {:idx (row-nr i) :contact s}))
    (partial map (comp
                  cleanup
                  #_(fn [s] (println "0" s) s)
                  (partial contact sheet)))
    sheet-rows)
   sheet))

(defn contacts [sheet]
  (let [ks [:contacts]]
    (if-let [v (get-in @cache ks)]
      v
      (cache! (fn [] (calc-contacts sheet)) ks))))

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
       (sheet-rows)
       (map (comp
             (fn [urls]
               #_(println "(cstr/split-lines urls)" (cstr/split-lines urls))
               (cstr/split-lines urls))
             cleanup
             (partial logo sheet)))
       (map-indexed (fn [i a] {:idx (row-nr i) :logos a}))))

(defn logos [sheet]
  (let [ks [:web-pages]]
    (if-let [v (get-in @cache ks)]
      v
      (cache! (fn [] (calc-logos sheet)) ks))))

(defn web-page [sheet row] (text-at-position sheet (column-idx \H) row))

(defn calc-web-pages
  "A list of indexed hash-maps:
  '({:idx 0 :web-page \"...\"}
    {:idx 1 :web-page \"...\"}
    {:idx 2 :web-page \"...\"})"
  [sheet]
  (->> sheet
       (sheet-rows)
       (map (comp
             cleanup
             (partial web-page sheet)))
       (map-indexed (fn [i a] {:idx (row-nr i) :web-page a}))))

(defn web-pages [sheet]
  (let [ks [:web-pages]]
    (if-let [v (get-in @cache ks)]
      v
      (cache! (fn [] (calc-web-pages sheet)) ks))))

(defn goal
  "umbenannt auf Ziele des Vereins"
  [sheet row] (text-at-position sheet (column-idx \I) row))

(defn calc-goals
  "
  TODO Natural Language Understanding (NLU)
  See https://github.huggingface/transformers
  Or just count word frequency

  A list of indexed hash-maps:
  '({:idx 0 :goal \"...\"}
    {:idx 1 :goal \"...\"}
    {:idx 2 :goal \"...\"})"
  [sheet]
  (->> sheet
       (sheet-rows)
       (map (comp
             cleanup
             (partial goal sheet)))
       (map-indexed (fn [i s] {:idx (row-nr i) :goal s}))))

(defn goals [sheet]
  (let [ks [:goals]]
    (if-let [v (get-in @cache ks)]
      v
      (cache! (fn [] (calc-goals sheet)) ks))))

(defn activity
  [sheet row] (text-at-position sheet (column-idx \J) row))

(defn calc-activities
  "
  TODO Natural Language Understanding (NLU)
  See https://github.huggingface/transformers
  Or just count word frequency

  A list of indexed hash-maps:
  '({:idx 0 :activity \"...\"}
    {:idx 1 :activity \"...\"}
    {:idx 2 :activity \"...\"})"
  [sheet]
  (->> sheet
       (sheet-rows)
       (map (comp
             cleanup
             (partial activity sheet)))
       (map-indexed (fn [i s] {:idx (row-nr i) :activity s}))))

(defn activities [sheet]
  (let [ks [:goals]]
    (if-let [v (get-in @cache ks)]
      v
      (cache! (fn [] (calc-activities sheet)) ks))))

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
                     contacts
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
  (let [fname (new java.io.File
                   "./resources/karte.ods"
                   ;; The ö is not properly encoded
                   ;; "./resources/Vereinsinformationen_öffentlich_Stadtteilkarte.ods"
                   )
        ks [:table]]
    (if-let [v (get-in @cache ks)]
      v
      (cache! (fn [] (calc-read-table fname)) ks))))

(def default-category "Sonstiges")

(defn reset-cache!
  "(fdk.data.ods/reset-cache! \"resources/Vereinsinformationen_öffentlich_Stadtteilkarte.ods\")"
  [fname]
  (swap! cache (fn [_] {}))
  (let [tbeg (System/currentTimeMillis)]
    ;; enforce evaluation; can't be done by (force (all-rankings))
    (dorun
     (calc-read-table fname))
    (printf "%s chars cached in %s ms"
            (count (str @cache)) (- (System/currentTimeMillis) tbeg))))

(defn process-table-row [districts
                              ;; : DropdownOption[]
                              row
                              ]

  ;; (println "[process-table-row]" "row" row)
  ;; (println "[process-table-row]" "(keys row)" (keys row))
  (let [association-id (str (java.util.UUID/randomUUID))]
    ;; (println "[process-table-row]" "association-id" association-id)
    ((comp
      ;; (fn [m] (println "[process-table-row]" "m" m) m)
      ;; (fn [m] (println "" m) m)
      ;; (fn [m] (println "9" m) m)
      (fn [m] (assoc m :id association-id))
      ;; (fn [m] (println "8" m) m)
      (fn [m] (assoc m :name (-> row :name)))
      ;; shortName addr_recv ;; not uses
      ;; (fn [m] (println "7" m) m)
      (fn [m] (assoc m :goals
                     {:format "plain" ;; "plain" | "html"
                      :text (-> row :goal escape-html-with-null)}))
      ;; (fn [m] (println "6" m) m)
      (fn [m] (assoc m :activities
                     {:format "plain" ;; "plain" | "html"
                      :text (-> row :activity escape-html-with-null)}))
      ;; (fn [m] (println "5" m) m)
      (fn [m] (assoc m :contacts
                     ((comp
                       (partial process-contact association-id)
                       :desc)
                      row)))
      ;; (fn [m] (println "4" m) m)
      (partial conj
               ((comp
                 ;; (fn [m] (println "31" m) m)
                 (partial process-socialMedia-links association-id)
                 ;; (fn [m] (println "30" m) m)
                 :links)
                row))
      ;; (fn [m] (println "3" m) m)
      (fn [m] (assoc m :images
                     ((comp
                       ;; (fn [m] (println "21" m) m)
                       (partial process-images association-id)
                       ;; (fn [m] (println "20" m) m)
                       :logos)
                      row)))
      ;; (fn [m] (println "2" m) m)
      (fn [m] (assoc m :districts
                     (keywords (:cityDistrict row) districts)))
      ;; (fn [m] (println "1" m) m)
      (partial conj (convert-address (-> row :address normalize-address))) ;; outputAddress
      ;; (fn [m] (println "0" m) m)
      (partial conj (-> row :coordinates parse-lat-lon))
      )
     {})))
