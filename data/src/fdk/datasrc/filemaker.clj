(ns fdk.datasrc.filemaker
  (:require [clojure.data.csv :as csv]
            [clojure.java.io :as io]
            [clojure.set :refer :all]
            [clojure.string :as s]
            [fdk.data :as data]
            [utils.core :refer :all]))

(defn slurp-csv
  "Takes csv file name and reads its data. Returns e.g.:
  [[\"cell-1A\" \"cell-1B\" \"cell-1C\"]
   [\"cell-2A\" \"cell-2B\" \"cell-2C\"]]

  Invocation e.g.:
  (slurp-csv \"resources/fdk.csv\")"
  [fname & options]
  (with-open [file (io/reader fname)]
    ;; TODO timestamps in file na [file (io/reader fname)]
    #_(-> file (slurp) (ccsv/parse-csv))
    (-> (apply csv/read-csv file options)
        (doall))))

(defn csv-data->maps
  "E.g.
  (-> \"resources/fdk.csv\" (slurp-csv) (csv-data->maps) (doall))
  TODO `maps->csv-data` and `csv-data->maps` should be inverse."
  [csv-data]
  (mapv zipmap
        (->> (first csv-data) ;; First row is the header
             (map keyword)    ;; Drop if you want string keys instead
             (repeat))        ;; lazy infinite sequence
	      (rest csv-data)))

(defn maps->csv-data
  "Takes a collection of maps and returns csv-data (vector of vectors with all
  values).
  TODO `maps->csv-data` and `csv-data->maps` should be inverse.
  Thanks to https://stackoverflow.com/a/48244002"
  [maps]
  (let [columns (-> maps first keys)
        headers (mapv name columns)
        rows (mapv #(mapv % columns) maps)]
    (into [headers] rows)))

(defn barf-csv
  "Takes a file (path, name and extension) and csv-data (vector of vectors with
  all values) and writes csv file.

  E.g.
  (barf-csv \"resources/result.csv\"
    (-> result normalize maps->csv-data)
    :separator \\;) "
  [file csv-data & options]
  (with-open [writer (io/writer file)]
    (apply csv/write-csv writer csv-data options)))

#_(count (slurp-csv "resources/202004_lageschluessel.csv" :separator \;))

#_(def streets
  (as-> "resources/202004_lageschluessel.csv" $
      (slurp-csv $ :separator \;)
      (csv-data->maps $)
      (map (fn [hm]
             (-> hm
                 (rename-keys {:lagebezeichnung :street :gemeinde :city})
                 (select-keys [:street :city]))) $)))

(defn fix-keywords
  "Take a seq of hash maps and replace space with '-' in every keyword."
  [ms]
  (->> ms
       (mapv (fn [m]
               (reduce conj {}
                       (map (fn [[k v]] {(keyword (s/replace (name k) " " "-")) v}) m) )))))

(defn fix-newlines [ms]
  (->> ms
       (mapv (fn [m]
               (->> m
                    (map (fn [[k v]] {k
                                     (if (string? v)
                                       (s/replace v "" "\n")
                                       v)}))
                    (reduce into {}))))))

(defn relevant-data
  "Get only relevant data from the `ms`
  (relevant-data ms)"
  [ms]
  (->> ms
       #_(take 1)
       (map (fn [m]
              (-> m
                  (select-keys [
                                :A-Anschrift-Wahl  #_I #_:association
                                :A-PLZ-F-2         #_AH
                                :A-Firma           #_G
                                :A-Land-F-1        #_Q #_ :city
                                :A-Namen-Notiz-Wdh #_W #_ :zip-code
                                :A-Ort-F-Liste     #_AA #_:street-and-house-nr])
                  (clojure.set/rename-keys
                   {
                    :A-PLZ-F-2 #_:A-Firma #_:A-Anschrift-Wahl :association
                    :A-Land-F-1 :city
                    :A-Namen-Notiz-Wdh :zip-code
                    :A-Ort-F-Liste :street-and-house-nr}))))))

#_(def ms
  (->> "resources/fdk.csv"
      (slurp-csv)
      (csv-data->maps)
      #_(take 1)
      (map-indexed (fn [idx m] (assoc m :line
                                     ;; lines start from 1 and 1st row skipped
                                     (+ 2 idx))))
      (fix-keywords)
      (fix-newlines)
      #_(doall)))

(defn private-kv [[k v]]
  (if (.contains (s/lower-case v) "privat") {k v}))

(defn association-names [ms]
  (->> ms
       (map (fn [m]
              (select-keys m [
                              #_:line
                              #_:A-Anschrift-Wahl  #_I
                              #_:A-Firma           #_J
                              :A-PLZ-F-2         #_AH
                              ])))
       (map (fn [m]
              (->> m
                   (map (fn [[k v]] v)))))
       (reduce into [])))

(defn select-private-kvs
  "Select only key-val pairs where val contains \"privat\" and add {:line ...}"
  [m]
  (->> m
       (keep private-kv)
       (reduce into
               (select-keys m [:line]))))

(defn private [ms]
  (let [
        ;; lines containing address-relevant "private" note
        line-private
        [29 45 60 62 66 69 77 78 81 102 112 134 148 181 189 207 247 252]

        ;; lines containing address-non-relevant "private" note
        line-private-false-positives
        [12 15 16 24 55 92]

        lines-to-remove (into
                         #_line-private
                         line-private-false-positives)]
    (->> ms
         (filter (fn [m]
                   (if-not (empty? (keep private-kv m))
                     m)))
         (remove (fn [{:keys [line]}]
                   (in? lines-to-remove line)))
         #_(take 1)
         #_(count))))

(defn public [ms]
  (difference (set ms)
              (->> ms (private) (set))))

(defn associations [ms]
  (->> []
       (into (->> ms (public) (relevant-data)))
       ;; (into data/data) ;; manual inquiry
       #_(take 1)
       (map (fn [{:keys [association city zip-code street-and-house-nr] :as ms}]
              #_ms
              {:name association
               :address (str street-and-house-nr ", " zip-code " " city)}))))
