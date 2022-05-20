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

(defclass ex-container []
  {
   :resize "both"
   :position "relative"
   :overflow "hidden"
   :height "100%"
   :width "100%"
   :z-index "2"
   :box-shadow "0 0 20px -10px hsl(187deg 97% 24%)"
   :display "grid"
   :align-items "center"})

(defclass wrapper [] {:resize "both"
                      :height "100vh"
                      :display "grid" :grid-template "auto 1fr auto / auto 1fr auto"})
(defclass header  [] {:grid-column "1 / 4" :background "lightpink" :padding "2rem"})
(defclass left    [] {:grid-column "1 / 2" :background "lightblue" :padding "1rem"})
(defclass center  [] {:grid-column "2 / 3" :background "coral"     :padding "1rem"})
(defclass right   [] {:grid-column "3 / 4" :background "yellow"    :padding "1rem"
                      :overflow-y "auto"})
(defclass footer  [] {:grid-column "1 / 4" :background "wheat"     :padding "2rem" :text-align "center" })

;; .left-sidebar, .right-sidebar {padding 1rem}

(defclass level1 [] {:color :green})

;; Create two unequal columns that floats next to each other
(defclass column []
  {
   ;; :flex "70%"
   :float "left"
   :padding (px 10)
   :height (px 300)
   })

(defclass example-overlay []
  {
   :user-select "none"
   :pointer-events "none"
   :position "absolute"
   :width "max-content"
   :background-color "white"
   :box-shadow "0 1px 4px rgba(0,0,0,0.2)"
   :padding "15px"
   :border-radius "10px"
   :border "1px solid #cccccc"
   })

(defclass card []
  {
   :position "relative"
   :display "flex"
   :flex-direction "column"
   :min-width "0"
   :word-wrap "break-word"
   :background-color "#fff"
   :background-clip "border-box"
   :border "1px solid rgba(0,0,0,.125)"
   :border-radius "0.25rem"
   })

;; .card-header:first-child {
;;  border-radius: calc(0.25rem - 1px) calc(0.25rem - 1px) 0 0;
;;  }
(defclass card-header []
  {
   :padding "0.5rem 1rem"
   :margin-bottom "0"
   :background-color "rgba(0,0,0,.03)"
   :border-bottom "1px solid rgba(0,0,0,.125)"
   })

;; .example-map p, .jumbotron p {
;;     margin: 0;
;;     padding: 0;
;; }
;; .example-map {
;;     width: 100%;
;;     height: 60vh;
;;     margin-bottom: 1em;
;; }

;; .no-interaction {
;;     user-select: none;
;;     pointer-events: none;
;; }

;; .example-control {
;;     top: 2.5em;
;;     right: 0.5em;
;; }

;; .example-list {
;;     width: 150px;
;;     max-width: 150px;
;;     min-width: 150px;
;;     font-size: 0.7em;
;;     list-style: lower-latin;
;;     padding: 0;
;;     overflow: hidden;
;; }

;; .example-list ul {
;;     padding: 0;
;;     overflow: hidden;
;; }

;; .example-list li {
;;     font-style: italic;
;;     overflow: hidden;
;; }

;; .example-overview .ol-overviewmap-map {
;;     border: none !important;
;;     width: 300px !important;
;; }

;; .example-overview .ol-overviewmap-box {
;;     border: 2px solid blue;
;; }

;; .example-overview,
;; .example-overview.ol-uncollapsible {
;;     bottom: auto !important;
;;     left: auto !important;
;;     right: 0 !important;
;;     top: 0 !important;
;; }

;; .example-overview:not(.ol-collapsed) button {
;;     bottom: auto !important;
;;     left: auto !important;
;;     right: 1px !important;
;;     top: 1px !important;
;; }

;; .example-fullscreen {
;;     top: 5em;
;;     right: 0.5em;
;; }

;; .fullscreen:-webkit-full-screen {
;;     height: 100%;
;;     margin: 0;
;; }
;; .fullscreen:-ms-fullscreen {
;;     height: 100%;
;; }

;; .fullscreen:fullscreen {
;;     height: 100%;
;; }

;; .fullscreen {
;;     margin-bottom: 10px;
;;     width: 100%;
;;     height: 400px;
;; }

;; .example-spinner {
;;     position: absolute;
;;     top: 40%;
;;     left: 40%;
;;     width: 20%;
;;     height: 20%;
;; }

;; .example-spinner>img {
;;     width: 100%;
;; }
