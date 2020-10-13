(ns fdk.common)

(defonce cache (atom {}))

(defn cache!
  "Also return the cached value for further consumption."
  [calc-data-fn ks]
  (let [data (calc-data-fn)]
    (swap! cache update-in ks (fn [_] data))
    data))

