(ns fdk.datasrc.xlsx
  (:require
   [dk.ative.docjure.spreadsheet :as dk]))

(def fname
  "resources/<filename>.xlsx")
#_(def sheet
  (->> (dk/load-workbook fname)
       (dk/select-sheet "Alle")))

#_(->> (dk/load-workbook fname)
     (dk/select-sheet "Alle")
     (dk/select-columns {:A :association}))
