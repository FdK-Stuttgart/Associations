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
(let [fun (fn [style-name params]
            {:name style-name
             :css (spade.runtime/compile-css [[:* {:box-sizing :border-box}]])})]
  (def universal-selector
    (spade.runtime/ensure-style!
     :global (spade.util/factory->name fun) fun nil)))

(defglobal defaults
  [:body
   {
    ;; :color               :red
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

;; (defclass row [] {:content "\"\"" :display "table" :clear "both"})
(let [fun (fn [style-name params]
            ;; ::after - clear floats after the columns
            (let [style [(str "." style-name "::after")
                         {:content "\"\"" :display "table" :clear "both"}]]
              {:css (spade.runtime/compile-css style) :name style-name}))]
  (defn row []
    (spade.runtime/ensure-style! :class (spade.util/factory->name fun) fun [])))
