(ns fdk.process
  "Combine all the partial results etc."
  (:require
   [clj-fuzzy.metrics :as fuzzy]
   [fdk.cities :refer :all]
   [utils.core :refer :all]))

(def columns
  [{:idx 1 :k :association}
   {:idx 2 :k :phone}
   {:idx 3 :k :address0}
   {:idx 4 :k :address1}
   {:idx 5 :k :address2}])

(defn normalize
  "Needed for the `barf-result` macro"
  [ks m] (conj
          (zipmap ks (cycle [""]))
       m))

(defmacro barf-result
  "Create csv-file with the same name as the name of the `result` form.
  E.g.
  (barf-result result-baden)
  Creates `resources/result-baden.csv`"
  [result]
  `(let [result# ~result
         result-file# (format "resources/%s.csv" (quote ~result))
         ks# (->> result#
                  (map keys)
                  (reduce into #{}))
         cs# (->> columns
                  (filter (fn [c#] (in? ks# (:k c#))))
                  (sort-by :idx)
                  (mapv (fn [m#] (:k m#))))]
     (barf-csv result-file#
               (maps->csv-data (map (fn [r#] (normalize cs# r#)) result#))
               :separator \;)))

(defn test-similarity-fns [result]
  (map (fn [{:keys [i address association]}]
         (let [strs (->> [address association]
                         (map clojure.string/lower-case))]
           (->>
            ;; Functions for string similarity computation
            [{:n :sorensen       :f fuzzy/sorensen}
             {:n :dice           :f fuzzy/dice}
             {:n :levenshtein    :f fuzzy/levenshtein}
             {:n :hamming        :f fuzzy/hamming}
             {:n :jaccard        :f fuzzy/jaccard}
             {:n :tanimoto       :f fuzzy/tanimoto}
             {:n :jaro           :f fuzzy/jaro}
             ;; (< n coefficient) means the value of :address key is not
             ;; really different from association name
             {:n :jaro-winkler   :f fuzzy/jaro-winkler :coefficient 0.6}
             {:n :mra-comparison :f fuzzy/mra-comparison}
             {:n :tversky        :f fuzzy/tversky}]
            (map (fn [{:keys [n f]}]
                   {:i i :n n :r (apply f strs)})))))
       result))

(defn city
  "(city \"Lerchenberger Str. 48, 73035 Göppingen\")
  ;; =>
  \"Göppingen\""
  [s]
  (last (re-find #"[0-9]{5} (.*)$" s)))

(defn multiple-addresses
  "(->> [result-new result-baden result-karte]
        #_(map (fn [r] (take 1 r)))
        (apply map multiple-addresses m1 m2 m3))"
  [m & rest-ms]
  (let [ms (conj rest-ms m) ;; make `m` the first elem of `ms`
        combined-ms
        (->> ms
             (group-by :association)
             (map (fn [[k v]] {:association k
                              :vs
                              (->> v
                                   (mapv (fn [m] (select-keys m [:address]))))}))
             (map (fn [{:keys [vs]}]
                    (->> vs
                         distinct
                         (remove empty?)
                         (zipmap (range))
                         (keep (fn [[k v]] {(keyword (str "address" k)) (:address v)})))))
             (reduce into {}))]
    (apply conj
           (conj (map (fn [mi] (dissoc mi :address)) ms)
                 combined-ms))))

(defn in-bw? [address] (and address (in? baden-wuerttemberg (city address))))

(defn stats
  "(stats result-karte)
  (->> [result-new result-baden result-karte result-adresse
        result-combined]
       (map stats))
  "
  [result]
  {:cnt-address (->> result
                     (filter (fn [m] (contains? m :address)))
                     (filter (fn [m] (in-bw? (:address m))))
                     (count))
   :cnt-phone   (->> result
                     (filter (fn [m] (contains? m :phone)))
                     (count))
   :eq-address  (->> result
                     (filter (fn [m] (contains? m :eq-address)))
                     (count))
   :eq-phone    (->> result
                     (filter (fn [m] (contains? m :eq-phone)))
                     (count))})
(def rf
  (let [
        cities-bw baden-wuerttemberg
        #_(->> big-cities
               (filter (fn [{:keys [bl]}]
                         (= bl "Baden-Württemberg")))
               (map :cities)
               (reduce into []))
        ]
    (->> [result-new result-baden result-karte result-adresse]
         #_(mapv (fn [mi] (->> mi (take 18))))
         #_(mapv (fn [mi] (->> mi (drop 17))))
         (mapv (fn [mi]
                 (->> mi
                      (map (fn [{:keys [address] :as m}]
                             (if (and address (not (in-bw? address)))
                               (select-keys m [:association])
                               m))))))
         (apply map multiple-addresses))))

#_(barf-result rf)

#_(->> (group-by :n [{:n 1 :a 1} {:n 1 :a 1} {:n 1} {:n 1 :a 2}])
     (map (fn [[k v]] {:n k :v (mapv (fn [{:keys [a]}] a) v)}))
     (map (fn [m] (->> m
                       :v
                       dedupe
                       (zipmap (range))))))

(->> [result-new result-baden result-karte result-adresse
      result-combined]
     (map stats))
