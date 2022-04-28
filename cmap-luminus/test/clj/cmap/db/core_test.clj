(ns cmap.db.core-test
  (:require
   [cmap.db.core :refer [*db*] :as db]
   [java-time.pre-java8]
   [luminus-migrations.core :as migrations]
   [clojure.test :refer :all]
   [next.jdbc :as jdbc]
   [cmap.config :refer [env]]
   [mount.core :as mount]))

(use-fixtures
  :once
  (fn [f]
    (mount/start
     #'cmap.config/env
     #'cmap.db.core/*db*)
    (migrations/migrate ["migrate"] (select-keys env [:database-url]))
    (f)))

(deftest test-read-associations
  (jdbc/with-transaction [t-conn *db* {:rollback-only true}]
    (is (> ((comp
             (fn [c] (println "count read-associations:" c) c)
             count)
            (db/read-associations t-conn {} {}))
           20))))

(deftest test-users
  (jdbc/with-transaction [t-conn *db* {:rollback-only true}]
    (is (= 1
           (db/create-user!
              t-conn
              {:id         "1"
               :first_name "Sam"
               :last_name  "Smith"
               :email      "sam.smith@example.com"
               :pass       "pass"}
              {})))
    (is (=
         (dissoc
          {:id         "1"
           :first_name "Sam"
           :last_name  "Smith"
           :email      "sam.smith@example.com"
           :pass       "pass"
           :admin      nil
           :last_login nil
           :is_active  nil}
          :last_login)
         (dissoc
          (db/get-user t-conn {:id "1"} {})
          :last_login)))))
