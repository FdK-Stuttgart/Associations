(ns cmap.styles
  (:require-macros
   [garden.def :refer [defcssfn]])
  (:require
   [clojure.string :as s]
   [spade.core   :refer [defglobal defclass]]
   [garden.units :refer [deg px]]
   [garden.color :refer [rgba]]))

(def padding 4)
(def pxu "px")

(defclass wrapper [] {:resize "both"
                      ;; :padding "10mm"
                      :height "100vh"
                      :display "grid"
                      ;; :grid-template "auto 200px auto / auto 1fr auto"
                      ;; "grid-template-rows" / "grid-template-columns"
                      ;; 1fr - 1 fraction of the free space
                      ;; "auto 1fr auto / auto 1fr auto"
                      :grid-template-rows "auto 1fr auto"
                      :grid-template-columns
                      (s/join " " ["auto" "1fr" #_"fit-content(30%)" "30%"])
                      :grid-template-areas "none"
                      })
;; "starts on column" / "end before column"
;; em	Relative to the font-size of the element (2em means 2 times the size of the current font)
;; rem Relative to font-size of the root element
(defclass header  [] {:grid-column "1 / 4" :background "lightpink"
                      :text-align "center"
                      ;; :padding "2rem"
                      })
(defclass left    [] {:grid-column "1 / 2" :background "lightblue" :padding (str padding pxu)})
(defclass center  [] {:grid-column "2 / 3" :background "coral"     :padding (str padding pxu)
                      ;; :min-height "100vh"
                      ;; :min-height "fit-content"
                      })
(defclass right   [] {:grid-column "3 / 4" :background "yellow"    :padding (str padding pxu)
                      :overflow-y "auto"
                      })
(defclass footer  [] {:grid-column "1 / 4" :background "wheat"
                      ;; :padding "2rem"
                      :text-align "center"
                      })
(defclass tab-content [] {
                          :background "green"
                          ;; :height "70vh"
                          :overflow-y "auto"
                          })

(defclass pos []
  {
   ;; :position "absolute"
   ;; :positioning "center-center"
   ;; :pointer-events "auto"
   :transform "translate(-50%, -100%)"
   ;; :transform-origin "0% 100px"
   ;; :transform "translate(410px, 724px)"
   ;; :transform "translate(-50%, -100%) translate(410px, 724px)"
   ;; :transform "translate(-50%, -100%) translate(510px, 603px)"
   }
  )

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
