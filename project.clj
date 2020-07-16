(defproject fdk :lein-v
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "EPL-2.0 OR GPL-2.0-or-later WITH Classpath-exception-2.0"
            :url "https://www.eclipse.org/legal/epl-2.0/"}
  :dependencies
  [
   [org.clojure/clojure           "1.10.1"]
   [org.clojure/data.csv          "1.0.0"]
   ;; url encode
   [ring/ring-codec               "1.1.2"]
   ;; managing environment variables
   [environ                       "1.2.0"]

   ;; wget / get-json
   [clj-http                      "3.10.1"]

   ;; pretty print json a string
   [cheshire                      "5.10.0"]

   [org.clojure/data.json         "1.0.0"]

   ;; transducers
   [net.cgrand/xforms             "0.19.2"]

   [org.clojars.bost/clj-time-ext "0.0.0-37-0x545c"]
   [org.clojars.bost/utils        "0.0.0-37-0xc96a"]

   ;; parse HTML into Clojure data structures - scrapping data from HTML tables
   [hickory "0.7.1"]

   ;; read and write M$ Office documents
   [dk.ative/docjure "1.14.0"]

   ;; https://mvnrepository.com/artifact/org.odftoolkit/simple-odf
   [org.odftoolkit/simple-odf "0.9.0-RC1"]

   ;; debugging
   ;; https://github.com/vvvvalvalval/scope-capture
   [vvvvalvalval/scope-capture "0.3.2"]

   ;; TODO https://github.com/LibrePDF/OpenPDF

   [org.clojure/core.memoize "1.0.236"]

   ;; compute string similarity - identify of what is the association name and
   ;; what is not when web-scrapping association address search results
   ;; https://yomguithereal.github.io/clj-fuzzy/clojure.html
   [clj-fuzzy "0.4.1"]

   ;; character utility functions
   [djy "0.2.1"]

   ]
  :plugins
  [
   ;; project version from git
   [com.roomkey/lein-v "7.2.0"]
   ]
  :repl-options {:init-ns fdk.download})
