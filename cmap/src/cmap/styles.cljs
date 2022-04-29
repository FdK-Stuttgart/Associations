(ns cmap.styles
  (:require-macros
    [garden.def :refer [defcssfn]])
  (:require
    [spade.core   :refer [defglobal defclass]]
    [garden.units :refer [deg px]]
    [garden.color :refer [rgba]]))

(defcssfn linear-gradient
 ([c1 p1 c2 p2]
  [[c1 p1] [c2 p2]])
 ([dir c1 p1 c2 p2]
  [dir [c1 p1] [c2 p2]]))

#_(defglobal d [:body {:color :red}])

(do
  (defn universal-selector-factory$ [style-name24356 params24357]
    {:name style-name24356, :css (spade.runtime/compile-css [[:* {:box-sizing :border-box}]])})
  (let [factory-name24358 (spade.util/factory->name universal-selector-factory$)]
    (def universal-selector
      (spade.runtime/ensure-style! :global factory-name24358 universal-selector-factory$ nil))))

(defglobal defaults
  [
   ;; :&:* {:box-sizing :border-box}
   :body
   {:color               :red
    :background-color    :#ddd
    :background-image    [(linear-gradient :white (px 2) :transparent (px 2))
                          (linear-gradient (deg 90) :white (px 2) :transparent (px 2))
                          (linear-gradient (rgba 255 255 255 0.3) (px 1) :transparent (px 1))
                          (linear-gradient (deg 90) (rgba 255 255 255 0.3) (px 1) :transparent (px 1))]
    :background-size     [[(px 100) (px 100)] [(px 100) (px 100)] [(px 20) (px 20)] [(px 20) (px 20)]]
    :background-position [[(px -2) (px -2)] [(px -2) (px -2)] [(px -1) (px -1)] [(px -1) (px -1)]]}])

(defclass level1
  []
  {:color :green})

;; Create two unequal columns that floats next to each other
(defclass column []
  {
   ;; :flex "70%"
   :float "left"
   :padding (px 10)
   :height (px 300)
   })

(defclass left [] {:width "75%"})
(defclass right [] {:width "25%"})

;; Clear floats after the columns
;; (defclass row [] {:content "\"\"" :display "table" :clear "both"})
(do
  (defn row-factory$ [style-name23148 params23149]
    (let [style23151 [(str "." style-name23148 "::after")
                      {:content "\"\"", :display "table", :clear "both"}]]
      {:css (spade.runtime/compile-css style23151), :name style-name23148}))
  (let [factory-name23150 (spade.util/factory->name row-factory$)]
    (defn row []
      (spade.runtime/ensure-style! :class factory-name23150 row-factory$ []))))



