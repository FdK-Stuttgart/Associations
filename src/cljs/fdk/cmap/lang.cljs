(ns fdk.cmap.lang)

(def labels
  {:de {
        ::search-hint "Vereinsdaten durchsuchen..."
        ::no-pub-addr "keine öffentliche Anschrift"

        ::instagram "Instagram"
        ::facebook "Facebook"
        ::youtube "YouTube"
        ::linkedin "LinkedIn"

        ::messenger "Messenger"
        ::snapchat "Snapchat"
        ::twitter "Twitter"
        ::whatsapp "WhatsApp"

        ::links "Links"
        ::activity-areas "Aktivitätsgebiete"
        ::activities "Aktivitäten"
        ::goals "Ziele des Vereins"}})

(defn de [& ks] (get-in labels (into [:de] ks)))
