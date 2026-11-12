/* =========================================================
   Çocuk Kartlarım — site betiği
   - 5 dilli arayüz (Türkçe, İngilizce, Almanca, Fransızca, İtalyanca)
   - Mobil menü, dil menüsü, kaydırma efektleri, SSS akordeonu
   ========================================================= */

(function () {
  "use strict";

  var I18N = {
    tr: {
      "meta.title": "Çocuk Kartlarım — Çocuğunuzun sağlık kartları, hep yanınızda",
      "meta.description": "Aşı takvimi, kan grubu ve alerji kayıtları tek uygulamada. Tüm veriler yalnızca cihazınızda kalır; hesap yok, sunucu yok, reklam yok.",
      "a11y.skip": "İçeriğe geç",
      "nav.features": "Özellikler",
      "nav.screens": "Ekranlar",
      "nav.privacy": "Gizlilik",
      "nav.faq": "S.S.S.",
      "nav.cta": "İndir",
      "hero.badge": "5 dilde · Tamamen cihazda",
      "hero.title": "Çocuğunuzun sağlık kartları,",
      "hero.titleAccent": "hep yanınızda.",
      "hero.lead": "Aşı takvimi, kan grubu ve alerji kayıtları tek uygulamada. Tüm veriler yalnızca cihazınızda kalır — hesap yok, sunucu yok, reklam yok.",
      "hero.cta1": "Uygulamayı indir",
      "hero.cta2": "Özellikleri gör",
      "hero.chip1": "Reklamsız",
      "hero.chip2": "Çevrimdışı çalışır",
      "hero.chip3": "Veriler cihazda",
      "hero.note": "iOS 16+ · Türkçe, İngilizce, Almanca, Fransızca, İtalyanca",
      "float.vaccine": "Aşı takvimi",
      "float.vaccineSub": "Geciken dozlar kırmızı",
      "float.blood": "Kan grubu kartı",
      "float.bloodSub": "Tek bakışta",
      "float.lang": "5 dil",
      "stats.1": "aşı satırı",
      "stats.2": "takvim hücresi",
      "stats.3": "dijital kart",
      "stats.4": "dil",
      "stats.5": "sunucu",
      "features.eyebrow": "Özellikler",
      "features.title": "Çocuk sağlığını takip etmek için ihtiyacınız olan her şey",
      "features.lead": "Tek bir uygulamada üç kart, otomatik takvim ve tam gizlilik.",
      "f1.title": "Aşı Takvimi",
      "f1.text": "Doğum tarihine göre otomatik planlanan 10 aşı satırı. Yapılan, bekleyen ve geciken dozlar tek bakışta.",
      "f2.title": "Kan Grubu Kartı",
      "f2.text": "Kurum, doğum yeri, kan grubu ve onaylayan bilgisiyle resmî görünümlü kart.",
      "f3.title": "Alerji ve Kronik Hastalık",
      "f3.text": "Sınırsız kayıt; kullanılan ilaç, doz ve kullanım sıklığı ile birlikte.",
      "f4.title": "Çoklu Çocuk",
      "f4.text": "Her çocuk için ayrı kart ve cinsiyete göre renk teması. Kardeşler tek listede.",
      "f5.title": "Paylaşılabilir Kartlar",
      "f5.text": "Kartları görsel olarak paylaşın veya yazdırın. T.C. kimlik no otomatik maskelenir.",
      "f6.title": "Beş Dil",
      "f6.text": "Türkçe, İngilizce, Almanca, Fransızca, İtalyanca. Yeniden başlatmadan değişir.",
      "screens.eyebrow": "Ekranlar",
      "screens.title": "Uygulamanın içinden",
      "screens.lead": "Sade arayüz, büyük dokunma alanları ve her ekranda okunaklı tipografi.",
      "s1": "Çocuk listesi",
      "s2": "Aşı takip kartı",
      "s3": "Kan grubu kartı",
      "s4": "Alerji ve kronik hastalık",
      "s5": "Dil seçimi",
      "how.eyebrow": "Nasıl çalışır",
      "how.title": "Üç adımda hazır",
      "how.1t": "Çocuğu ekleyin",
      "how.1d": "Ad, doğum tarihi ve cinsiyet yeterli. Aşı takvimi otomatik oluşur.",
      "how.2t": "Kartları doldurun",
      "how.2d": "Yapılan aşıları işaretleyin; kan grubu ve sağlık kayıtlarını girin.",
      "how.3t": "Güvenle paylaşın",
      "how.3d": "Kartı görsel olarak paylaşın veya yazdırın. Kimlik numarası maskelenir.",
      "privacy.eyebrow": "Gizlilik",
      "privacy.title": "Verileriniz cihazınızdan çıkmaz.",
      "privacy.lead": "Çocuk Kartlarım hesap açmanızı istemez ve hiçbir veriyi sunucuya göndermez.",
      "privacy.1": "Kayıtlar cihazın uygulama klasöründe, dosya korumasıyla saklanır.",
      "privacy.2": "Analitik, reklam SDK'sı veya takip kodu yok.",
      "privacy.3": "Uygulamayı sildiğinizde veriler de cihazdan silinir.",
      "privacy.link": "Gizlilik politikasını okuyun",
      "privacy.badge": "Cihazda şifreli saklama",
      "faq.eyebrow": "S.S.S.",
      "faq.title": "Sık sorulan sorular",
      "faq.1q": "Uygulama ücretli mi?",
      "faq.1a": "Hayır, ücretsizdir. Kaynak kodu GitHub'da açıktır.",
      "faq.2q": "Verilerim nerede saklanıyor?",
      "faq.2a": "Yalnızca cihazınızda. Hesap, bulut veya sunucu yok.",
      "faq.3q": "Aşı takvimi hangi ülkeye göre?",
      "faq.3a": "Türkiye'nin rutin çocukluk çağı aşı takvimine göre 10 satır ve 100 hücre içerir. Resmî takvim için sağlık kuruluşunuza danışın.",
      "faq.4q": "Kartları nasıl paylaşıyorum?",
      "faq.4a": "Kart ekranındaki “Kartı Paylaş” düğmesiyle görsel olarak paylaşın. T.C. kimlik no ilk 3 ve son 3 hane dışında maskelenir.",
      "faq.5q": "Dili nasıl değiştiririm?",
      "faq.5a": "Çocuk listesi ekranının sol üstündeki küre simgesine dokunun. Seçim uygulama yeniden başlatılmadan uygulanır.",
      "faq.6q": "Android sürümü var mı?",
      "faq.6a": "Şimdilik iOS sürümü yayında. Android kaynak kodu için depoyu takip edebilirsiniz.",
      "dl.title": "Uygulamayı indirin",
      "dl.lead": "iOS için Swift Playgrounds paketi ve tüm kaynak kod GitHub'da.",
      "dl.github": "GitHub'da görüntüle",
      "dl.ipa": "IPA indir",
      "dl.note": "App Store sürümü hazırlanıyor. IPA dosyası Swift Playgrounds ile açılabilen uygulama paketini içerir.",
      "footer.tagline": "Çocuğunuzun sağlık bilgileri tek yerde, güvenle.",
      "footer.by": "Dr. Talat Özünal"
    },

    en: {
      "meta.title": "Child Health — Your child's health cards, always with you",
      "meta.description": "Vaccination schedule, blood group and allergy records in one app. All data stays on your device — no account, no server, no ads.",
      "a11y.skip": "Skip to content",
      "nav.features": "Features",
      "nav.screens": "Screens",
      "nav.privacy": "Privacy",
      "nav.faq": "FAQ",
      "nav.cta": "Download",
      "hero.badge": "5 languages · Fully on-device",
      "hero.title": "Your child's health cards,",
      "hero.titleAccent": "always with you.",
      "hero.lead": "Vaccination schedule, blood group and allergy records in one app. All data stays on your device — no account, no server, no ads.",
      "hero.cta1": "Download the app",
      "hero.cta2": "See features",
      "hero.chip1": "No ads",
      "hero.chip2": "Works offline",
      "hero.chip3": "Data on device",
      "hero.note": "iOS 16+ · Turkish, English, German, French, Italian",
      "float.vaccine": "Vaccination schedule",
      "float.vaccineSub": "Overdue doses in red",
      "float.blood": "Blood group card",
      "float.bloodSub": "At a glance",
      "float.lang": "5 languages",
      "stats.1": "vaccine rows",
      "stats.2": "calendar cells",
      "stats.3": "digital cards",
      "stats.4": "languages",
      "stats.5": "servers",
      "features.eyebrow": "Features",
      "features.title": "Everything you need to follow your child's health",
      "features.lead": "Three cards, an automatic schedule and full privacy in a single app.",
      "f1.title": "Vaccination Schedule",
      "f1.text": "Ten vaccine rows planned automatically from the date of birth. Given, pending and overdue doses at a glance.",
      "f2.title": "Blood Group Card",
      "f2.text": "A card that looks official: institution, place of birth, blood group and approving physician.",
      "f3.title": "Allergies & Chronic Conditions",
      "f3.text": "Unlimited records, together with medication, dose and frequency.",
      "f4.title": "Multiple Children",
      "f4.text": "A separate card for each child with a colour theme by gender. Siblings in one list.",
      "f5.title": "Shareable Cards",
      "f5.text": "Share cards as an image or print them. The national ID number is masked automatically.",
      "f6.title": "Five Languages",
      "f6.text": "Turkish, English, German, French, Italian. Switch without restarting.",
      "screens.eyebrow": "Screens",
      "screens.title": "Inside the app",
      "screens.lead": "A calm interface, large touch targets and readable type on every screen.",
      "s1": "Children list",
      "s2": "Vaccination card",
      "s3": "Blood group card",
      "s4": "Allergies & conditions",
      "s5": "Language selection",
      "how.eyebrow": "How it works",
      "how.title": "Ready in three steps",
      "how.1t": "Add your child",
      "how.1d": "A name, date of birth and gender are enough. The schedule builds itself.",
      "how.2t": "Fill in the cards",
      "how.2d": "Mark the vaccines given; add blood group and health records.",
      "how.3t": "Share safely",
      "how.3d": "Share the card as an image or print it. The ID number is masked.",
      "privacy.eyebrow": "Privacy",
      "privacy.title": "Your data never leaves the device.",
      "privacy.lead": "Child Health never asks you to create an account and sends no data to a server.",
      "privacy.1": "Records are stored in the app's folder on the device with file protection.",
      "privacy.2": "No analytics, no ad SDK, no tracking code.",
      "privacy.3": "Deleting the app removes the data from the device.",
      "privacy.link": "Read the privacy policy",
      "privacy.badge": "Encrypted on-device storage",
      "faq.eyebrow": "FAQ",
      "faq.title": "Frequently asked questions",
      "faq.1q": "Is the app free?",
      "faq.1a": "Yes, it is free. The source code is open on GitHub.",
      "faq.2q": "Where is my data stored?",
      "faq.2a": "Only on your device. No account, no cloud, no server.",
      "faq.3q": "Which country's schedule does it use?",
      "faq.3a": "It follows Türkiye's routine childhood immunisation schedule with 10 rows and 100 cells. For the official schedule, consult your health provider.",
      "faq.4q": "How do I share the cards?",
      "faq.4a": "Use “Share card” on the card screen to share an image. The national ID is masked except the first and last three digits.",
      "faq.5q": "How do I change the language?",
      "faq.5a": "Tap the globe icon at the top left of the children list. The choice applies without restarting the app.",
      "faq.6q": "Is there an Android version?",
      "faq.6a": "iOS is available today. Follow the repository for the Android source.",
      "dl.title": "Download the app",
      "dl.lead": "Swift Playgrounds package for iOS and all source code on GitHub.",
      "dl.github": "View on GitHub",
      "dl.ipa": "Download IPA",
      "dl.note": "The App Store version is in progress. The IPA contains the app package that opens in Swift Playgrounds.",
      "footer.tagline": "Your child's health information in one place, safely.",
      "footer.by": "Dr. Talat Özünal"
    },

    de: {
      "meta.title": "Child Health — Die Gesundheitskarten Ihres Kindes, immer dabei",
      "meta.description": "Impfplan, Blutgruppe und Allergien in einer App. Alle Daten bleiben auf Ihrem Gerät — kein Konto, kein Server, keine Werbung.",
      "a11y.skip": "Zum Inhalt springen",
      "nav.features": "Funktionen",
      "nav.screens": "Screens",
      "nav.privacy": "Datenschutz",
      "nav.faq": "FAQ",
      "nav.cta": "Laden",
      "hero.badge": "5 Sprachen · Vollständig auf dem Gerät",
      "hero.title": "Die Gesundheitskarten Ihres Kindes,",
      "hero.titleAccent": "immer dabei.",
      "hero.lead": "Impfplan, Blutgruppe und Allergien in einer App. Alle Daten bleiben auf Ihrem Gerät — kein Konto, kein Server, keine Werbung.",
      "hero.cta1": "App herunterladen",
      "hero.cta2": "Funktionen ansehen",
      "hero.chip1": "Keine Werbung",
      "hero.chip2": "Funktioniert offline",
      "hero.chip3": "Daten auf dem Gerät",
      "hero.note": "iOS 16+ · Türkisch, Englisch, Deutsch, Französisch, Italienisch",
      "float.vaccine": "Impfplan",
      "float.vaccineSub": "Überfällige Dosen rot",
      "float.blood": "Blutgruppenkarte",
      "float.bloodSub": "Auf einen Blick",
      "float.lang": "5 Sprachen",
      "stats.1": "Impfstoffzeilen",
      "stats.2": "Kalenderzellen",
      "stats.3": "digitale Karten",
      "stats.4": "Sprachen",
      "stats.5": "Server",
      "features.eyebrow": "Funktionen",
      "features.title": "Alles, um die Gesundheit Ihres Kindes zu verfolgen",
      "features.lead": "Drei Karten, ein automatischer Plan und volle Privatsphäre in einer App.",
      "f1.title": "Impfplan",
      "f1.text": "Zehn Impfstoffzeilen, automatisch aus dem Geburtsdatum geplant. Gegebene, offene und überfällige Dosen auf einen Blick.",
      "f2.title": "Blutgruppenkarte",
      "f2.text": "Eine amtlich wirkende Karte: Einrichtung, Geburtsort, Blutgruppe und bestätigende Ärztin.",
      "f3.title": "Allergien & chronische Krankheiten",
      "f3.text": "Unbegrenzte Einträge, zusammen mit Medikament, Dosis und Häufigkeit.",
      "f4.title": "Mehrere Kinder",
      "f4.text": "Für jedes Kind eine eigene Karte mit Farbthema nach Geschlecht. Geschwister in einer Liste.",
      "f5.title": "Teilbare Karten",
      "f5.text": "Karten als Bild teilen oder drucken. Die Ausweisnummer wird automatisch maskiert.",
      "f6.title": "Fünf Sprachen",
      "f6.text": "Türkisch, Englisch, Deutsch, Französisch, Italienisch. Wechsel ohne Neustart.",
      "screens.eyebrow": "Screens",
      "screens.title": "Aus der App",
      "screens.lead": "Ruhige Oberfläche, große Tippflächen und gut lesbare Schrift auf jedem Screen.",
      "s1": "Kinderliste",
      "s2": "Impfnachweis",
      "s3": "Blutgruppenkarte",
      "s4": "Allergien & Krankheiten",
      "s5": "Sprachauswahl",
      "how.eyebrow": "So funktioniert es",
      "how.title": "In drei Schritten bereit",
      "how.1t": "Kind anlegen",
      "how.1d": "Name, Geburtsdatum und Geschlecht genügen. Der Plan entsteht automatisch.",
      "how.2t": "Karten ausfüllen",
      "how.2d": "Gegebene Impfungen markieren, Blutgruppe und Befunde eintragen.",
      "how.3t": "Sicher teilen",
      "how.3d": "Karte als Bild teilen oder drucken. Die Ausweisnummer wird maskiert.",
      "privacy.eyebrow": "Datenschutz",
      "privacy.title": "Ihre Daten verlassen das Gerät nicht.",
      "privacy.lead": "Child Health verlangt kein Konto und sendet keine Daten an einen Server.",
      "privacy.1": "Einträge liegen im App-Ordner des Geräts, geschützt durch Dateischutz.",
      "privacy.2": "Keine Analyse, kein Werbe-SDK, kein Tracking-Code.",
      "privacy.3": "Beim Löschen der App werden auch die Daten vom Gerät entfernt.",
      "privacy.link": "Datenschutzerklärung lesen",
      "privacy.badge": "Verschlüsselt auf dem Gerät",
      "faq.eyebrow": "FAQ",
      "faq.title": "Häufige Fragen",
      "faq.1q": "Ist die App kostenlos?",
      "faq.1a": "Ja, sie ist kostenlos. Der Quellcode ist auf GitHub offen.",
      "faq.2q": "Wo werden meine Daten gespeichert?",
      "faq.2a": "Nur auf Ihrem Gerät. Kein Konto, keine Cloud, kein Server.",
      "faq.3q": "Nach welchem Land richtet sich der Impfplan?",
      "faq.3a": "Nach dem Routine-Impfplan der Türkei mit 10 Zeilen und 100 Feldern. Für den offiziellen Plan wenden Sie sich an Ihre Gesundheitseinrichtung.",
      "faq.4q": "Wie teile ich die Karten?",
      "faq.4a": "Über „Karte teilen“ im Kartenbildschirm als Bild. Die Ausweisnummer wird bis auf die ersten und letzten drei Ziffern maskiert.",
      "faq.5q": "Wie ändere ich die Sprache?",
      "faq.5a": "Tippen Sie oben links in der Kinderliste auf das Globus-Symbol. Die Auswahl gilt ohne Neustart.",
      "faq.6q": "Gibt es eine Android-Version?",
      "faq.6a": "Derzeit gibt es iOS. Für den Android-Quellcode folgen Sie dem Repository.",
      "dl.title": "App herunterladen",
      "dl.lead": "Swift-Playgrounds-Paket für iOS und der gesamte Quellcode auf GitHub.",
      "dl.github": "Auf GitHub ansehen",
      "dl.ipa": "IPA laden",
      "dl.note": "Die App-Store-Version ist in Arbeit. Die IPA enthält das in Swift Playgrounds öffnungsfähige App-Paket.",
      "footer.tagline": "Die Gesundheitsdaten Ihres Kindes an einem Ort, sicher.",
      "footer.by": "Dr. Talat Özünal"
    },

    fr: {
      "meta.title": "Child Health — Les cartes de santé de votre enfant, toujours avec vous",
      "meta.description": "Calendrier vaccinal, groupe sanguin et allergies dans une seule app. Toutes les données restent sur votre appareil — sans compte, sans serveur, sans publicité.",
      "a11y.skip": "Aller au contenu",
      "nav.features": "Fonctionnalités",
      "nav.screens": "Écrans",
      "nav.privacy": "Confidentialité",
      "nav.faq": "FAQ",
      "nav.cta": "Télécharger",
      "hero.badge": "5 langues · Entièrement sur l'appareil",
      "hero.title": "Les cartes de santé de votre enfant,",
      "hero.titleAccent": "toujours avec vous.",
      "hero.lead": "Calendrier vaccinal, groupe sanguin et allergies dans une seule app. Toutes les données restent sur votre appareil — sans compte, sans serveur, sans publicité.",
      "hero.cta1": "Télécharger l'app",
      "hero.cta2": "Voir les fonctionnalités",
      "hero.chip1": "Sans publicité",
      "hero.chip2": "Fonctionne hors ligne",
      "hero.chip3": "Données sur l'appareil",
      "hero.note": "iOS 16+ · Turc, anglais, allemand, français, italien",
      "float.vaccine": "Calendrier vaccinal",
      "float.vaccineSub": "Doses en retard en rouge",
      "float.blood": "Carte de groupe sanguin",
      "float.bloodSub": "En un coup d'œil",
      "float.lang": "5 langues",
      "stats.1": "lignes de vaccins",
      "stats.2": "cases de calendrier",
      "stats.3": "cartes numériques",
      "stats.4": "langues",
      "stats.5": "serveur",
      "features.eyebrow": "Fonctionnalités",
      "features.title": "Tout pour suivre la santé de votre enfant",
      "features.lead": "Trois cartes, un calendrier automatique et une confidentialité totale dans une seule app.",
      "f1.title": "Calendrier vaccinal",
      "f1.text": "Dix lignes de vaccins planifiées automatiquement selon la date de naissance. Doses faites, à venir et en retard en un coup d'œil.",
      "f2.title": "Carte de groupe sanguin",
      "f2.text": "Une carte à l'allure officielle : établissement, lieu de naissance, groupe sanguin et médecin validateur.",
      "f3.title": "Allergies et maladies chroniques",
      "f3.text": "Entrées illimitées, avec médicament, dose et fréquence.",
      "f4.title": "Plusieurs enfants",
      "f4.text": "Une carte par enfant avec un thème de couleur selon le sexe. Les frères et sœurs dans une seule liste.",
      "f5.title": "Cartes partageables",
      "f5.text": "Partagez les cartes en image ou imprimez-les. Le numéro d'identité est masqué automatiquement.",
      "f6.title": "Cinq langues",
      "f6.text": "Turc, anglais, allemand, français, italien. Changement sans redémarrage.",
      "screens.eyebrow": "Écrans",
      "screens.title": "À l'intérieur de l'app",
      "screens.lead": "Une interface calme, de grandes zones tactiles et une typographie lisible sur chaque écran.",
      "s1": "Liste des enfants",
      "s2": "Carnet de vaccination",
      "s3": "Carte de groupe sanguin",
      "s4": "Allergies et maladies",
      "s5": "Choix de la langue",
      "how.eyebrow": "Comment ça marche",
      "how.title": "Prêt en trois étapes",
      "how.1t": "Ajoutez votre enfant",
      "how.1d": "Un prénom, une date de naissance et un sexe suffisent. Le calendrier se crée tout seul.",
      "how.2t": "Remplissez les cartes",
      "how.2d": "Cochez les vaccins faits, ajoutez le groupe sanguin et les antécédents.",
      "how.3t": "Partagez sereinement",
      "how.3d": "Partagez la carte en image ou imprimez-la. Le numéro d'identité est masqué.",
      "privacy.eyebrow": "Confidentialité",
      "privacy.title": "Vos données ne quittent pas l'appareil.",
      "privacy.lead": "Child Health ne demande aucun compte et n'envoie aucune donnée à un serveur.",
      "privacy.1": "Les données sont stockées dans le dossier de l'app, protégées par le chiffrement de fichier.",
      "privacy.2": "Aucune analyse, aucun SDK publicitaire, aucun code de suivi.",
      "privacy.3": "Supprimer l'app efface aussi les données de l'appareil.",
      "privacy.link": "Lire la politique de confidentialité",
      "privacy.badge": "Stockage chiffré sur l'appareil",
      "faq.eyebrow": "FAQ",
      "faq.title": "Questions fréquentes",
      "faq.1q": "L'app est-elle payante ?",
      "faq.1a": "Non, elle est gratuite. Le code source est ouvert sur GitHub.",
      "faq.2q": "Où sont stockées mes données ?",
      "faq.2a": "Uniquement sur votre appareil. Sans compte, sans cloud, sans serveur.",
      "faq.3q": "Quel pays pour le calendrier vaccinal ?",
      "faq.3a": "Il suit le calendrier vaccinal de routine de la Türkiye, avec 10 lignes et 100 cases. Pour le calendrier officiel, consultez votre centre de santé.",
      "faq.4q": "Comment partager les cartes ?",
      "faq.4a": "Avec « Partager la carte » sur l'écran de la carte, en image. Le numéro d'identité est masqué sauf les trois premiers et derniers chiffres.",
      "faq.5q": "Comment changer la langue ?",
      "faq.5a": "Touchez l'icône globe en haut à gauche de la liste des enfants. Le choix s'applique sans redémarrage.",
      "faq.6q": "Y a-t-il une version Android ?",
      "faq.6a": "iOS est disponible aujourd'hui. Suivez le dépôt pour le code Android.",
      "dl.title": "Télécharger l'app",
      "dl.lead": "Paquet Swift Playgrounds pour iOS et tout le code source sur GitHub.",
      "dl.github": "Voir sur GitHub",
      "dl.ipa": "Télécharger l'IPA",
      "dl.note": "La version App Store est en préparation. L'IPA contient le paquet de l'app ouvrable dans Swift Playgrounds.",
      "footer.tagline": "Les informations de santé de votre enfant en un seul endroit, en sécurité.",
      "footer.by": "Dr. Talat Özünal"
    },

    it: {
      "meta.title": "Child Health — Le schede sanitarie di tuo figlio, sempre con te",
      "meta.description": "Calendario vaccinale, gruppo sanguigno e allergie in un'unica app. Tutti i dati restano sul dispositivo — nessun account, nessun server, nessuna pubblicità.",
      "a11y.skip": "Vai al contenuto",
      "nav.features": "Funzioni",
      "nav.screens": "Schermate",
      "nav.privacy": "Privacy",
      "nav.faq": "FAQ",
      "nav.cta": "Scarica",
      "hero.badge": "5 lingue · Tutto sul dispositivo",
      "hero.title": "Le schede sanitarie di tuo figlio,",
      "hero.titleAccent": "sempre con te.",
      "hero.lead": "Calendario vaccinale, gruppo sanguigno e allergie in un'unica app. Tutti i dati restano sul dispositivo — nessun account, nessun server, nessuna pubblicità.",
      "hero.cta1": "Scarica l'app",
      "hero.cta2": "Vedi le funzioni",
      "hero.chip1": "Senza pubblicità",
      "hero.chip2": "Funziona offline",
      "hero.chip3": "Dati sul dispositivo",
      "hero.note": "iOS 16+ · Turco, inglese, tedesco, francese, italiano",
      "float.vaccine": "Calendario vaccinale",
      "float.vaccineSub": "Dosi in ritardo in rosso",
      "float.blood": "Scheda gruppo sanguigno",
      "float.bloodSub": "A colpo d'occhio",
      "float.lang": "5 lingue",
      "stats.1": "righe di vaccini",
      "stats.2": "celle del calendario",
      "stats.3": "schede digitali",
      "stats.4": "lingue",
      "stats.5": "server",
      "features.eyebrow": "Funzioni",
      "features.title": "Tutto per seguire la salute di tuo figlio",
      "features.lead": "Tre schede, un calendario automatico e piena riservatezza in un'unica app.",
      "f1.title": "Calendario vaccinale",
      "f1.text": "Dieci righe di vaccini pianificate automaticamente dalla data di nascita. Dosi fatte, in attesa e in ritardo a colpo d'occhio.",
      "f2.title": "Scheda gruppo sanguigno",
      "f2.text": "Una scheda dall'aspetto ufficiale: struttura, luogo di nascita, gruppo sanguigno e medico che approva.",
      "f3.title": "Allergie e malattie croniche",
      "f3.text": "Voci illimitate, con farmaco, dose e frequenza.",
      "f4.title": "Più bambini",
      "f4.text": "Una scheda per ogni bambino con tema di colore in base al sesso. I fratelli in un unico elenco.",
      "f5.title": "Schede condivisibili",
      "f5.text": "Condividi le schede come immagine o stampale. Il numero di identità viene mascherato automaticamente.",
      "f6.title": "Cinque lingue",
      "f6.text": "Turco, inglese, tedesco, francese, italiano. Cambio senza riavvio.",
      "screens.eyebrow": "Schermate",
      "screens.title": "Dentro l'app",
      "screens.lead": "Interfaccia essenziale, aree di tocco ampie e tipografia leggibile su ogni schermata.",
      "s1": "Elenco bambini",
      "s2": "Scheda vaccini",
      "s3": "Scheda gruppo sanguigno",
      "s4": "Allergie e malattie",
      "s5": "Scelta della lingua",
      "how.eyebrow": "Come funziona",
      "how.title": "Pronto in tre passi",
      "how.1t": "Aggiungi il bambino",
      "how.1d": "Nome, data di nascita e sesso bastano. Il calendario si crea da solo.",
      "how.2t": "Compila le schede",
      "how.2d": "Segna i vaccini fatti, aggiungi gruppo sanguigno e dati sanitari.",
      "how.3t": "Condividi in sicurezza",
      "how.3d": "Condividi la scheda come immagine o stampala. Il numero di identità è mascherato.",
      "privacy.eyebrow": "Privacy",
      "privacy.title": "I tuoi dati non lasciano il dispositivo.",
      "privacy.lead": "Child Health non richiede account e non invia dati a un server.",
      "privacy.1": "I dati sono salvati nella cartella dell'app, protetti dalla cifratura dei file.",
      "privacy.2": "Nessuna analisi, nessun SDK pubblicitario, nessun codice di tracciamento.",
      "privacy.3": "Eliminando l'app i dati vengono rimossi dal dispositivo.",
      "privacy.link": "Leggi l'informativa sulla privacy",
      "privacy.badge": "Archiviazione cifrata sul dispositivo",
      "faq.eyebrow": "FAQ",
      "faq.title": "Domande frequenti",
      "faq.1q": "L'app è a pagamento?",
      "faq.1a": "No, è gratuita. Il codice sorgente è aperto su GitHub.",
      "faq.2q": "Dove sono salvati i miei dati?",
      "faq.2a": "Solo sul tuo dispositivo. Nessun account, nessun cloud, nessun server.",
      "faq.3q": "A quale paese si riferisce il calendario?",
      "faq.3a": "Al calendario vaccinale di routine della Türkiye, con 10 righe e 100 celle. Per il calendario ufficiale rivolgiti alla tua struttura sanitaria.",
      "faq.4q": "Come condivido le schede?",
      "faq.4a": "Con «Condividi la scheda» nella schermata della scheda, come immagine. Il numero di identità è mascherato tranne le prime e le ultime tre cifre.",
      "faq.5q": "Come cambio la lingua?",
      "faq.5a": "Tocca l'icona del globo in alto a sinistra nell'elenco bambini. La scelta si applica senza riavviare.",
      "faq.6q": "Esiste una versione Android?",
      "faq.6a": "Oggi è disponibile iOS. Segui il repository per il codice Android.",
      "dl.title": "Scarica l'app",
      "dl.lead": "Pacchetto Swift Playgrounds per iOS e tutto il codice sorgente su GitHub.",
      "dl.github": "Vedi su GitHub",
      "dl.ipa": "Scarica l'IPA",
      "dl.note": "La versione App Store è in preparazione. L'IPA contiene il pacchetto dell'app apribile in Swift Playgrounds.",
      "footer.tagline": "Le informazioni sanitarie di tuo figlio in un unico posto, al sicuro.",
      "footer.by": "Dr. Talat Özünal"
    }
  };

  var STORAGE_KEY = "cocukKartlarim.lang";
  var DEFAULT_LANG = "tr";
  var SUPPORTED = ["tr", "en", "de", "fr", "it"];
  var CODES = { tr: "TR", en: "EN", de: "DE", fr: "FR", it: "IT" };

  var root = document.documentElement;
  var langBox = document.getElementById("lang");
  var langButton = document.getElementById("langButton");
  var langMenu = document.getElementById("langMenu");
  var langCode = document.getElementById("langCode");
  var burger = document.getElementById("burger");
  var nav = document.getElementById("nav");
  var header = document.getElementById("header");

  function normalize(code) {
    if (!code) return null;
    var base = String(code).toLowerCase().split("-")[0];
    return SUPPORTED.indexOf(base) >= 0 ? base : null;
  }

  function storedLang() {
    try { return normalize(localStorage.getItem(STORAGE_KEY)); } catch (e) { return null; }
  }

  function browserLang() {
    var list = navigator.languages || [navigator.language || ""];
    for (var i = 0; i < list.length; i++) {
      var found = normalize(list[i]);
      if (found) return found;
    }
    return null;
  }

  function translate(code) {
    var dict = I18N[code] || I18N[DEFAULT_LANG];
    var nodes = document.querySelectorAll("[data-i18n]");
    for (var i = 0; i < nodes.length; i++) {
      var key = nodes[i].getAttribute("data-i18n");
      if (Object.prototype.hasOwnProperty.call(dict, key)) {
        nodes[i].textContent = dict[key];
      }
    }
    document.title = dict["meta.title"] || document.title;
    var desc = document.querySelector('meta[name="description"]');
    if (desc && dict["meta.description"]) desc.setAttribute("content", dict["meta.description"]);
    root.setAttribute("lang", code);
    if (langCode) langCode.textContent = CODES[code] || code.toUpperCase();

    var items = document.querySelectorAll(".lang__item");
    for (var j = 0; j < items.length; j++) {
      var active = items[j].getAttribute("data-lang") === code;
      items[j].classList.toggle("is-active", active);
      items[j].setAttribute("aria-current", active ? "true" : "false");
    }
  }

  function setLang(code, remember) {
    var safe = SUPPORTED.indexOf(code) >= 0 ? code : DEFAULT_LANG;
    translate(safe);
    if (remember) {
      try { localStorage.setItem(STORAGE_KEY, safe); } catch (e) { /* yoksay */ }
    }
  }

  /* --- dil menüsü --- */
  function openLang(open) {
    if (!langBox || !langButton) return;
    langBox.classList.toggle("is-open", open);
    langButton.setAttribute("aria-expanded", open ? "true" : "false");
  }

  if (langButton) {
    langButton.addEventListener("click", function (event) {
      event.stopPropagation();
      openLang(!langBox.classList.contains("is-open"));
    });
  }

  if (langMenu) {
    langMenu.addEventListener("click", function (event) {
      var button = event.target.closest(".lang__item");
      if (!button) return;
      setLang(button.getAttribute("data-lang"), true);
      openLang(false);
      if (langButton) langButton.focus();
    });
  }

  document.addEventListener("click", function (event) {
    if (langBox && !langBox.contains(event.target)) openLang(false);
  });

  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
      openLang(false);
      closeNav();
    }
  });

  /* --- mobil menü --- */
  function closeNav() {
    if (!nav || !burger) return;
    nav.classList.remove("is-open");
    burger.setAttribute("aria-expanded", "false");
  }

  if (burger) {
    burger.addEventListener("click", function () {
      var open = !nav.classList.contains("is-open");
      nav.classList.toggle("is-open", open);
      burger.setAttribute("aria-expanded", open ? "true" : "false");
    });
  }

  if (nav) {
    nav.addEventListener("click", function (event) {
      if (event.target.closest("a")) closeNav();
    });
  }

  /* --- kaydırma durumu --- */
  function onScroll() {
    if (!header) return;
    header.classList.toggle("is-scrolled", window.scrollY > 8);
  }
  window.addEventListener("scroll", onScroll, { passive: true });
  onScroll();

  /* --- görünürlük animasyonu --- */
  var revealItems = document.querySelectorAll("[data-reveal]");
  if ("IntersectionObserver" in window) {
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-in");
          observer.unobserve(entry.target);
        }
      });
    }, { rootMargin: "0px 0px -8% 0px", threshold: 0.08 });

    for (var r = 0; r < revealItems.length; r++) {
      revealItems[r].classList.add("will-reveal");
      observer.observe(revealItems[r]);
    }
  } else {
    for (var s = 0; s < revealItems.length; s++) revealItems[s].classList.add("is-in");
  }

  /* --- SSS: aynı anda tek soru açık kalsın --- */
  var faqItems = document.querySelectorAll(".faq__item");
  for (var f = 0; f < faqItems.length; f++) {
    faqItems[f].addEventListener("toggle", function () {
      if (!this.open) return;
      for (var k = 0; k < faqItems.length; k++) {
        if (faqItems[k] !== this) faqItems[k].open = false;
      }
    });
  }

  /* --- başlangıç dili --- */
  var initial = storedLang() || DEFAULT_LANG;
  setLang(initial, false);
  if (!storedLang()) {
    var detected = browserLang();
    if (detected && detected !== DEFAULT_LANG) setLang(detected, false);
  }
})();
