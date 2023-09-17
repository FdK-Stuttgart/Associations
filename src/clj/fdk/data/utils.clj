(ns fdk.data.utils
  (:require
   [clojure.tools.logging :as log]
   [clojure.string :as cstr]
   ;; [clojure.string :refer :all]
   ))

(defn normalize-address
  "(normalize-address \"Karlstraße 15
73770 Denkendorf\")
  ;; => \"Karlstraße 15, 73770 Denkendorf\"
  "
  [address]
  (if address
    (let [adr (cstr/replace address "\n" ", ")
         adr-match (re-find #"[0-9] [A-z]," adr)]
      (if adr-match
        (let [old-house-nr (str adr-match)
              new-house-nr (cstr/replace old-house-nr " " "")]
          (cstr/replace adr (re-pattern old-house-nr) new-house-nr))
        adr))
    address))

(defn is-synonym [string-part district-label]
  (let [string-part (-> string-part
                        (cstr/replace "Bad-Cannstatt" "Bad Cannstatt")
                        cstr/trim)]
    (or (= string-part district-label)
        (and (cstr/starts-with? district-label "Stuttgart")
             (let [string-part-with-prefix
                   (if (cstr/starts-with? string-part "Stuttgart ")
                     (cstr/replace string-part "Stuttgart " "Stuttgart-")
                     string-part)]
               (or (= string-part-with-prefix district-label)
                   (and (not (cstr/starts-with? string-part "Stuttgart-"))
                        (not (cstr/starts-with? string-part-with-prefix "Stuttgart"))
                        (= (str "Stuttgart-" string-part) district-label)))))
        (= string-part "Stuttgart")
        (= district-label "Stadt Stuttgart")
        (and (or (= string-part "Baden-Württemberg")
                 (= string-part "Baden Württemberg")
                 (= string-part "Landesweit"))
             (= district-label "Landesweit (Baden-Württemberg)"))
        (and (= district-label "Stuttgart und Region")
             (or (cstr/includes? string-part "Stuttgart und Umgebung")
                 (cstr/includes? string-part "und Region")
                 (= string-part "Stuttgart Region"))))))

(defn get-districts [string-parts options]
  (->> string-parts
       (map (fn [string-part]
              (first (filter (fn [option]
                               (or (= string-part (:label option))
                                   (is-synonym string-part (:label option))))
                             options))))
       (filter identity)
       (map :value)))

(defn keywords [thing options]
  (if thing
    (let [clean (-> thing
                    (cstr/replace #"\(.*?\)" "")
                    (cstr/replace #"\." "")
                    (cstr/trim))
          clean-split (cstr/split clean #", ")]
      (get-districts clean-split options))
    []))


(defn escape-html [unsafe]
  (-> unsafe
      (cstr/replace "&" "&amp;")
      (cstr/replace "<" "&lt;")
      (cstr/replace ">" "&gt;")
      (cstr/replace "\"" "&quot;")
      (cstr/replace "'" "&#039;")
      (cstr/replace "\n" "<br/>")))

(defn escape-html-with-null [unsafe]
  (if unsafe
    (escape-html unsafe)
    ""))

(defn domain-regex [domain]
  ;; (re-pattern (str ".*" domain "\\..*") "i")
  (re-pattern (str "(?i).*" domain "\\..*")))

(def SocialMediaPlatform
  {:FACEBOOK   "Facebook"
   :INSTAGRAM  "Instagram"
   :YOUTUBE    "YouTube"
   :PINTEREST  "Pinterest"
   :TWITTER    "Twitter"
   :LINKEDIN   "LinkedIn"
   :WHATSAPP   "WhatsApp"
   :SNAPCHAT   "Snapchat"
   :OTHER      "Other"})

(defn get-social-media-platform
  "(get-social-media-platform \"https://www.facebook.com/foo\")
  ;; => \"Facebook\""
  [url]
  (cond
    (re-find (domain-regex "facebook") url)    (:FACEBOOK SocialMediaPlatform)
    (re-find (domain-regex "instagram") url)   (:INSTAGRAM SocialMediaPlatform)
    (re-find (domain-regex "youtube") url)     (:YOUTUBE SocialMediaPlatform)
    (re-find (domain-regex "pinterest") url)   (:PINTEREST SocialMediaPlatform)
    (re-find (domain-regex "twitter") url)     (:TWITTER SocialMediaPlatform)
    (re-find (domain-regex "linkedin") url)    (:LINKEDIN SocialMediaPlatform)
    (re-find (domain-regex "whatsapp") url)    (:WHATSAPP SocialMediaPlatform)
    (re-find (domain-regex "snapchat") url)    (:SNAPCHAT SocialMediaPlatform)
    :else (:OTHER SocialMediaPlatform)))

(defn is-social-media-link [url]
  (not= (get-social-media-platform url) (:OTHER SocialMediaPlatform)))

(defn no-public-address [norm-addr]
  (re-find
   (re-pattern "(?i).*keine|Postfach.*")
   ;; #"(?i).*keine|Postfach.*"
   norm-addr))

(defn convert-address [norm-addr]
  (let [addr-lines (if (no-public-address norm-addr)
                     [norm-addr]
                     (cstr/split norm-addr #", "))
        street (first addr-lines)
        postcode-city (second addr-lines)
        [postcode city] (if postcode-city
                          (cstr/split postcode-city #"\s+")
                          [nil nil])
        addr-lines (vec (concat [nil nil nil] (drop 2 addr-lines)))]
    {:addressLine1 (addr-lines 0)
     :addressLine2 (addr-lines 1)
     :addressLine3 (addr-lines 2)
     :street street
     :postcode postcode
     :city city
     :country ""}))

(defn parse-lat-lon
  "(parse-lat-lon \"9.319517 48.694530\")
  ;; => {:lat 48.69453, :lng 9.319517}"
  [coordinates]
  (let [lat-lng-split (mapv (fn [s] (Float/parseFloat s))
                            (cstr/split coordinates #"\s+"))]
    {:lat (lat-lng-split 1)
     :lng (lat-lng-split 0)}))

(defn process-contact [association-id contact]
  (let [contact-details (if contact (cstr/split contact #"\r?\n") [])
        emails (filter #(re-find #"@" %) contact-details)
        po-boxes (filter #(cstr/includes? (cstr/lower-case %) "postfach") contact-details)
        non-emails (remove #(or (re-find #"@" %)
                                (cstr/includes? (cstr/lower-case %) "postfach"))
                           contact-details)
        fax-numbers (for [cdi non-emails :when (re-find #"fax" (cstr/lower-case cdi))]
                      (-> cdi
                          (cstr/replace #"Fax[:.]?" "")
                          (cstr/replace #"fax[:.]?" "")
                          cstr/trim))
        phone-numbers (for [cdi non-emails :when (not (re-find #"fax" (cstr/lower-case cdi)))]
                        (-> cdi
                            (cstr/replace #"Tel[:.]?" "")
                            (cstr/replace #"tel[:.]?" "")
                            cstr/trim))
        max-length (max (count phone-numbers) (count fax-numbers) (count emails))
        arr-contact (mapv (fn [i]
                            {:id (str (java.util.UUID/randomUUID))
                             :name ""
                             :mail (get emails i "")
                             :phone (get phone-numbers i "")
                             :fax (get fax-numbers i "")
                             :poBox (get po-boxes i "")
                             :associationId association-id})
                          (range max-length))]
    arr-contact))

(defn process-socialMedia-links [association-id links]
  (let [link-list (if links (cstr/split links #"\s+") [])
        arr-link (for [url link-list :when (not (is-social-media-link url))]
                   {:id (str (java.util.UUID/randomUUID))
                    :link-text ""
                    :url url
                    :association-id association-id})
        social-media-links (for [url link-list :when (is-social-media-link url)]
                             {:platform (get-social-media-platform url)
                              :id (str (java.util.UUID/randomUUID))
                              :link-text ""
                              :url url
                              :association-id association-id})]
    {:links arr-link
     :socialMediaLinks social-media-links }))

(defn process-images [association-id logos]
  ;; (log/info "[process-images]" "association-id" association-id)
  ;; (log/info "[process-images]" "logos" logos)
  ((comp
    (partial mapv (fn [logo]
                    {:id (str (java.util.UUID/randomUUID))
                     :url logo
                     :alt-text ""
                     :association-id association-id})))
   logos))
