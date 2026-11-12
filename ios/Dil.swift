import SwiftUI

// MARK: - Desteklenen diller

enum UygulamaDili: String, CaseIterable, Identifiable {
    case sistem
    case tr, en, de, fr, it

    var id: String { rawValue }

    /// Seçicide gösterilen dilin kendi adı.
    var ozAd: String {
        switch self {
        case .sistem: return ""
        case .tr: return "Türkçe"
        case .en: return "English"
        case .de: return "Deutsch"
        case .fr: return "Français"
        case .it: return "Italiano"
        }
    }

    /// Tarih ve sayı biçimlendirmesinde kullanılan dil kodu.
    var kod: String {
        switch self {
        case .sistem:
            let kod = Locale.current.language.languageCode?.identifier ?? "tr"
            return UygulamaDili(rawValue: kod) == nil ? "tr" : kod
        default:
            return rawValue
        }
    }
}

// MARK: - Dil yöneticisi

/// Uygulama içi dil seçimini yönetir. Seçim `UserDefaults` içinde saklanır ve
/// değiştiğinde tüm ekranlar yeniden başlatmaya gerek kalmadan güncellenir.
final class Yerellestirme: ObservableObject {
    static let paylasilan = Yerellestirme()

    private static let anahtar = "appLanguage"

    @Published var secim: String {
        didSet {
            UserDefaults.standard.set(secim, forKey: Self.anahtar)
        }
    }

    private init() {
        let kayitli = UserDefaults.standard.string(forKey: Self.anahtar)
        let gecerli = kayitli.flatMap(UygulamaDili.init(rawValue:))
        secim = (gecerli ?? .sistem).rawValue
    }

    var dil: UygulamaDili {
        UygulamaDili(rawValue: secim) ?? .sistem
    }

    var locale: Locale { Locale(identifier: dil.kod) }

    /// Seçicinin satırında gösterilen dil adı.
    var seciliDilAdi: String {
        dil == .sistem ? metin("dil.sistem") : dil.ozAd
    }

    /// Bir dil seçeneğinin listede görünen adı.
    func dilAdi(_ secenek: UygulamaDili) -> String {
        secenek == .sistem ? metin("dil.sistem") : secenek.ozAd
    }

    /// Anahtarı seçili dile çevirir. Çeviri yoksa Türkçeye, o da yoksa
    /// anahtarın kendisine düşer.
    func metin(_ anahtar: String) -> String {
        if let deger = Self.tablo[dil.kod]?[anahtar] { return deger }
        if let deger = Self.tablo["tr"]?[anahtar] { return deger }
        return anahtar
    }

    /// Biçimlendirilebilir metinler için (`%@`, `%d`).
    func metin(_ anahtar: String, _ argumanlar: CVarArg...) -> String {
        String(format: metin(anahtar), locale: locale, arguments: argumanlar)
    }

    /// Sayıya göre tekil (`<anahtar>.tek`) veya çoğul metni seçer.
    func sayili(_ anahtar: String, _ sayi: Int) -> String {
        metin(sayi == 1 ? anahtar + ".tek" : anahtar, sayi)
    }

    /// Uzun tarih (gün ay yıl) biçimi.
    func uzunTarih(_ tarih: Date) -> String {
        tarih.formatted(Date.FormatStyle(date: .long, time: .omitted).locale(locale))
    }

    // MARK: Çeviriler

    private static let tablo: [String: [String: String]] = [
        "tr": tr,
        "en": en,
        "de": de,
        "fr": fr,
        "it": it
    ]

    private static let tr: [String: String] = [
        "dil.baslik": "Dil",
        "dil.sistem": "Sistem",
        "dil.kapat": "Kapat",

        "common.cancel": "İptal",
        "common.save": "Kaydet",
        "common.delete": "Sil",
        "common.edit": "Bilgileri Düzenle",
        "common.share": "Kartı Paylaş",
        "common.ok": "Tamam",

        "cinsiyet.baslik": "Cinsiyet",
        "cinsiyet.erkek": "Erkek",
        "cinsiyet.kiz": "Kız",

        "liste.baslik": "Çocuk Kartlarım",
        "liste.bos.baslik": "Henüz çocuk eklenmedi",
        "liste.bos.alt": "Aşı, kan grubu ve alerji kartları oluşturmak için çocuk ekleyin.",
        "liste.cocukEkle": "Çocuk Ekle",
        "liste.kayitli": "Kayıtlı Çocuklar",
        "liste.dogum": "Doğum: %@",
        "liste.kanGrubu": "Kan grubu: %@",
        "liste.geciken": "%d geciken aşı",
        "liste.geciken.tek": "%d geciken aşı",
        "liste.silOnay": "Bu çocuğun tüm kartları (aşı ve kan grubu) silinsin mi?",
        "liste.vazgec": "Vazgeç",

        "geri.baslik": "Hata / Geri Bildirim Gönder",
        "geri.kopyala": "E-posta Adresini Kopyala",
        "geri.kopyalandi": "E-posta adresi kopyalandı",
        "geri.konu": "Çocuk Kartlarım - Geri Bildirim",
        "geri.govde.satir": "Lütfen sorunu yukarıya yazın. Çocuğa ait kişisel bilgi paylaşmayın.",
        "geri.govde.surum": "Uygulama sürümü: %@ (%@)",
        "geri.govde.cihaz": "Cihaz: %@",

        "menu.asiKarti": "Aşı Kartı",
        "menu.asiGuncel": "Aşı takvimi güncel",
        "menu.kanKarti": "Kan Grubu Kartı",
        "menu.kanYok": "Henüz girilmedi",
        "menu.saglikKarti": "Alerji ve Kronik Hastalık Kartı",
        "menu.kayitYok": "Kayıt yok",
        "menu.kayitSayisi": "%d kayıt",
        "menu.kayitSayisi.tek": "%d kayıt",

        "form.ad": "Bebek/Çocuğun Adı",
        "form.soyad": "Bebek/Çocuğun Soyadı",
        "form.kimlik": "Bebek/Çocuğun T.C. Kimlik No",
        "form.dogum": "Bebek/Çocuğun Doğum Tarihi",
        "form.bolum": "Bebek/Çocuk Bilgileri",
        "form.kimlikHata": "T.C. Kimlik No 11 haneli olmalıdır.",

        "asi.baslik": "AŞI TAKİP KARTI 2026",
        "asi.kimlik": "T.C. Kimlik No: %@",
        "asi.dogumTarihi": "Doğum Tarihi: %@",
        "asi.cinsiyetSatir": "Cinsiyet: %@",
        "asi.zamaninda": "Zamanında yapıldı",
        "asi.planlandi": "Planlandı",
        "asi.gec": "Geç yapıldı / yapılmadı",
        "asi.not": "Resmi takvim için sağlık kuruluşunuza danışın.",
        "asi.paylas": "Aşı Takip Kartı – %@",

        "tarih.uygulama": "Uygulama Tarihi",
        "tarih.kaydiSil": "Kaydı Sil",

        "kan.baslik": "KAN GRUBU KARTI",
        "kan.adSoyad": "Ad Soyad",
        "kan.dogumYeri": "Doğum Yeri",
        "kan.dogumTarihi": "Doğum Tarihi",
        "kan.onaylayan": "Onaylayan",
        "kan.kartBilgileri": "Kart Bilgileri",
        "kan.kurum": "Kurum Adı",
        "kan.bolum": "Kan Grubu",
        "kan.bilgiBaslik": "Kan Grubu Bilgileri",
        "kan.paylas": "Kan Grubu Kartı – %@",

        "saglik.baslik": "ALERJİ VE KRONİK HASTALIK KARTI",
        "saglik.baslikKisa": "Alerji ve Kronik Hastalık",
        "saglik.bos": "Kayıtlı alerji veya kronik hastalık yok.",
        "saglik.alerjiler": "ALERJİLER",
        "saglik.kronikler": "KRONİK HASTALIKLAR",
        "saglik.tedavi": "Tedavi alıyor",
        "saglik.tur": "Tür",
        "saglik.alerji": "Alerji",
        "saglik.kronik": "Kronik Hastalık",
        "saglik.alerjiOrnek": "Alerji (ör. fıstık, penisilin)",
        "saglik.hastalikOrnek": "Hastalık (ör. astım, diyabet)",
        "saglik.aciklama": "Açıklama / reaksiyon (isteğe bağlı)",
        "saglik.ilaclar": "İlaçlar",
        "saglik.ilacEkle": "İlaç Ekle",
        "saglik.ilacAdi": "İlaç adı",
        "saglik.doz": "Doz (ör. 5 ml, 1 tablet)",
        "saglik.siklik": "Kullanım sıklığı (ör. günde 2 kez)",
        "saglik.ilacNot": "Birden fazla ilaç ekleyebilirsiniz. Silmek için satırı sola kaydırın.",
        "saglik.kaydiDuzenle": "Kaydı Düzenle",
        "saglik.ekle": "Alerji / Hastalık Ekle",
        "saglik.paylas": "Alerji ve Kronik Hastalık Kartı – %@",
        "saglik.uyari": "Kayıtlı bilgiler bilgilendirme amaçlıdır. Tedavi ve ilaç kararları için doktorunuza danışın.",

        "sutun.0": "Doğum",
        "sutun.2": "2. Ay",
        "sutun.4": "4. Ay",
        "sutun.6": "6. Ay",
        "sutun.9": "9. Ay",
        "sutun.12": "12. Ay",
        "sutun.18": "18. Ay",
        "sutun.24": "24. Ay",
        "sutun.48": "48. Ay",
        "sutun.156": "13 Yaş",

        "doz.Rapel": "Rapel",
        "doz.EkDoz": "Ek Doz",

        "asi.Hep-B": "Hep-B",
        "asi.BCG": "BCG",
        "asi.KPA": "KPA",
        "asi.DaBT-İPA-Hib-HepB": "DaBT-İPA-Hib-HepB",
        "asi.OPA": "OPA",
        "asi.Suçiçeği": "Suçiçeği",
        "asi.KKK": "KKK",
        "asi.Hep-A": "Hep-A",
        "asi.DaBT-İPA": "DaBT-İPA",
        "asi.Td": "Td"
    ]

    private static let en: [String: String] = [
        "dil.baslik": "Language",
        "dil.sistem": "System",
        "dil.kapat": "Close",

        "common.cancel": "Cancel",
        "common.save": "Save",
        "common.delete": "Delete",
        "common.edit": "Edit details",
        "common.share": "Share card",
        "common.ok": "OK",

        "cinsiyet.baslik": "Sex",
        "cinsiyet.erkek": "Boy",
        "cinsiyet.kiz": "Girl",

        "liste.baslik": "My Child Cards",
        "liste.bos.baslik": "No children added yet",
        "liste.bos.alt": "Add a child to create vaccination, blood group and allergy cards.",
        "liste.cocukEkle": "Add child",
        "liste.kayitli": "Children",
        "liste.dogum": "Born: %@",
        "liste.kanGrubu": "Blood group: %@",
        "liste.geciken": "%d overdue vaccines",
        "liste.geciken.tek": "%d overdue vaccine",
        "liste.silOnay": "Delete all cards for this child (vaccination and blood group)?",
        "liste.vazgec": "Cancel",

        "geri.baslik": "Send error / feedback",
        "geri.kopyala": "Copy email address",
        "geri.kopyalandi": "Email address copied",
        "geri.konu": "My Child Cards - Feedback",
        "geri.govde.satir": "Please describe the problem above. Do not share personal information about the child.",
        "geri.govde.surum": "App version: %@ (%@)",
        "geri.govde.cihaz": "Device: %@",

        "menu.asiKarti": "Vaccination card",
        "menu.asiGuncel": "Vaccination schedule up to date",
        "menu.kanKarti": "Blood group card",
        "menu.kanYok": "Not entered yet",
        "menu.saglikKarti": "Allergy and chronic illness card",
        "menu.kayitYok": "No records",
        "menu.kayitSayisi": "%d records",
        "menu.kayitSayisi.tek": "%d record",

        "form.ad": "Child's first name",
        "form.soyad": "Child's last name",
        "form.kimlik": "Child's national ID no.",
        "form.dogum": "Child's date of birth",
        "form.bolum": "Child details",
        "form.kimlikHata": "The national ID must be 11 digits.",

        "asi.baslik": "VACCINATION RECORD 2026",
        "asi.kimlik": "National ID: %@",
        "asi.dogumTarihi": "Date of birth: %@",
        "asi.cinsiyetSatir": "Sex: %@",
        "asi.zamaninda": "Done on time",
        "asi.planlandi": "Planned",
        "asi.gec": "Late / not done",
        "asi.not": "Consult your health provider for the official schedule.",
        "asi.paylas": "Vaccination record – %@",

        "tarih.uygulama": "Date given",
        "tarih.kaydiSil": "Delete record",

        "kan.baslik": "BLOOD GROUP CARD",
        "kan.adSoyad": "Full name",
        "kan.dogumYeri": "Place of birth",
        "kan.dogumTarihi": "Date of birth",
        "kan.onaylayan": "Approved by",
        "kan.kartBilgileri": "Card details",
        "kan.kurum": "Institution",
        "kan.bolum": "Blood group",
        "kan.bilgiBaslik": "Blood group details",
        "kan.paylas": "Blood group card – %@",

        "saglik.baslik": "ALLERGY AND CHRONIC ILLNESS CARD",
        "saglik.baslikKisa": "Allergy and chronic illness",
        "saglik.bos": "No allergies or chronic illnesses recorded.",
        "saglik.alerjiler": "ALLERGIES",
        "saglik.kronikler": "CHRONIC ILLNESSES",
        "saglik.tedavi": "On treatment",
        "saglik.tur": "Type",
        "saglik.alerji": "Allergy",
        "saglik.kronik": "Chronic illness",
        "saglik.alerjiOrnek": "Allergy (e.g. peanut, penicillin)",
        "saglik.hastalikOrnek": "Illness (e.g. asthma, diabetes)",
        "saglik.aciklama": "Description / reaction (optional)",
        "saglik.ilaclar": "Medication",
        "saglik.ilacEkle": "Add medication",
        "saglik.ilacAdi": "Medication name",
        "saglik.doz": "Dose (e.g. 5 ml, 1 tablet)",
        "saglik.siklik": "Frequency (e.g. twice a day)",
        "saglik.ilacNot": "You can add more than one medication. Swipe a row left to delete it.",
        "saglik.kaydiDuzenle": "Edit record",
        "saglik.ekle": "Add allergy / illness",
        "saglik.paylas": "Allergy and chronic illness card – %@",
        "saglik.uyari": "The recorded information is for reference only. Consult your doctor for treatment and medication decisions.",

        "sutun.0": "Birth",
        "sutun.2": "2 months",
        "sutun.4": "4 months",
        "sutun.6": "6 months",
        "sutun.9": "9 months",
        "sutun.12": "12 months",
        "sutun.18": "18 months",
        "sutun.24": "24 months",
        "sutun.48": "48 months",
        "sutun.156": "13 years",

        "doz.Rapel": "Booster",
        "doz.EkDoz": "Extra dose",

        "asi.Hep-B": "Hep-B",
        "asi.BCG": "BCG",
        "asi.KPA": "PCV",
        "asi.DaBT-İPA-Hib-HepB": "DTaP-IPV-Hib-HepB",
        "asi.OPA": "OPV",
        "asi.Suçiçeği": "Chickenpox",
        "asi.KKK": "MMR",
        "asi.Hep-A": "Hep-A",
        "asi.DaBT-İPA": "DTaP-IPV",
        "asi.Td": "Td"
    ]

    private static let de: [String: String] = [
        "dil.baslik": "Sprache",
        "dil.sistem": "System",
        "dil.kapat": "Schließen",

        "common.cancel": "Abbrechen",
        "common.save": "Speichern",
        "common.delete": "Löschen",
        "common.edit": "Angaben bearbeiten",
        "common.share": "Karte teilen",
        "common.ok": "OK",

        "cinsiyet.baslik": "Geschlecht",
        "cinsiyet.erkek": "Junge",
        "cinsiyet.kiz": "Mädchen",

        "liste.baslik": "Meine Kinderkarten",
        "liste.bos.baslik": "Noch kein Kind angelegt",
        "liste.bos.alt": "Fügen Sie ein Kind hinzu, um Impf-, Blutgruppen- und Allergiekarten zu erstellen.",
        "liste.cocukEkle": "Kind hinzufügen",
        "liste.kayitli": "Gespeicherte Kinder",
        "liste.dogum": "Geboren: %@",
        "liste.kanGrubu": "Blutgruppe: %@",
        "liste.geciken": "%d überfällige Impfungen",
        "liste.geciken.tek": "%d überfällige Impfung",
        "liste.silOnay": "Alle Karten dieses Kindes (Impfung und Blutgruppe) löschen?",
        "liste.vazgec": "Abbrechen",

        "geri.baslik": "Fehler / Feedback senden",
        "geri.kopyala": "E-Mail-Adresse kopieren",
        "geri.kopyalandi": "E-Mail-Adresse kopiert",
        "geri.konu": "Meine Kinderkarten - Feedback",
        "geri.govde.satir": "Bitte beschreiben Sie das Problem oben. Teilen Sie keine persönlichen Daten des Kindes.",
        "geri.govde.surum": "App-Version: %@ (%@)",
        "geri.govde.cihaz": "Gerät: %@",

        "menu.asiKarti": "Impfpass",
        "menu.asiGuncel": "Impfplan aktuell",
        "menu.kanKarti": "Blutgruppenkarte",
        "menu.kanYok": "Noch nicht eingetragen",
        "menu.saglikKarti": "Allergie- und chronische Krankheiten-Karte",
        "menu.kayitYok": "Keine Einträge",
        "menu.kayitSayisi": "%d Einträge",
        "menu.kayitSayisi.tek": "%d Eintrag",

        "form.ad": "Vorname des Kindes",
        "form.soyad": "Nachname des Kindes",
        "form.kimlik": "Ausweisnummer des Kindes",
        "form.dogum": "Geburtsdatum des Kindes",
        "form.bolum": "Angaben zum Kind",
        "form.kimlikHata": "Die Ausweisnummer muss 11-stellig sein.",

        "asi.baslik": "IMPFPLAN 2026",
        "asi.kimlik": "Ausweisnr.: %@",
        "asi.dogumTarihi": "Geburtsdatum: %@",
        "asi.cinsiyetSatir": "Geschlecht: %@",
        "asi.zamaninda": "Rechtzeitig",
        "asi.planlandi": "Geplant",
        "asi.gec": "Verspätet / nicht erfolgt",
        "asi.not": "Wenden Sie sich für den offiziellen Impfplan an Ihre Gesundheitseinrichtung.",
        "asi.paylas": "Impfpass – %@",

        "tarih.uygulama": "Verabreichungsdatum",
        "tarih.kaydiSil": "Eintrag löschen",

        "kan.baslik": "BLUTGRUPPENKARTE",
        "kan.adSoyad": "Vor- und Nachname",
        "kan.dogumYeri": "Geburtsort",
        "kan.dogumTarihi": "Geburtsdatum",
        "kan.onaylayan": "Bestätigt von",
        "kan.kartBilgileri": "Kartenangaben",
        "kan.kurum": "Einrichtung",
        "kan.bolum": "Blutgruppe",
        "kan.bilgiBaslik": "Blutgruppen-Angaben",
        "kan.paylas": "Blutgruppenkarte – %@",

        "saglik.baslik": "ALLERGIE- UND CHRONISCHE KRANKHEITEN-KARTE",
        "saglik.baslikKisa": "Allergie und chronische Krankheit",
        "saglik.bos": "Keine Allergien oder chronischen Krankheiten eingetragen.",
        "saglik.alerjiler": "ALLERGIEN",
        "saglik.kronikler": "CHRONISCHE KRANKHEITEN",
        "saglik.tedavi": "In Behandlung",
        "saglik.tur": "Art",
        "saglik.alerji": "Allergie",
        "saglik.kronik": "Chronische Krankheit",
        "saglik.alerjiOrnek": "Allergie (z. B. Erdnuss, Penicillin)",
        "saglik.hastalikOrnek": "Krankheit (z. B. Asthma, Diabetes)",
        "saglik.aciklama": "Beschreibung / Reaktion (optional)",
        "saglik.ilaclar": "Medikamente",
        "saglik.ilacEkle": "Medikament hinzufügen",
        "saglik.ilacAdi": "Medikamentenname",
        "saglik.doz": "Dosis (z. B. 5 ml, 1 Tablette)",
        "saglik.siklik": "Häufigkeit (z. B. 2-mal täglich)",
        "saglik.ilacNot": "Sie können mehrere Medikamente hinzufügen. Wischen Sie eine Zeile nach links, um sie zu löschen.",
        "saglik.kaydiDuzenle": "Eintrag bearbeiten",
        "saglik.ekle": "Allergie / Krankheit hinzufügen",
        "saglik.paylas": "Allergie- und chronische Krankheiten-Karte – %@",
        "saglik.uyari": "Die Angaben dienen nur zur Information. Wenden Sie sich für Behandlungs- und Medikamentenentscheidungen an Ihren Arzt.",

        "sutun.0": "Geburt",
        "sutun.2": "2. Monat",
        "sutun.4": "4. Monat",
        "sutun.6": "6. Monat",
        "sutun.9": "9. Monat",
        "sutun.12": "12. Monat",
        "sutun.18": "18. Monat",
        "sutun.24": "24. Monat",
        "sutun.48": "48. Monat",
        "sutun.156": "13 Jahre",

        "doz.Rapel": "Auffrischung",
        "doz.EkDoz": "Zusatzdosis",

        "asi.Hep-B": "Hep-B",
        "asi.BCG": "BCG",
        "asi.KPA": "KPA",
        "asi.DaBT-İPA-Hib-HepB": "DTPa-IPV-Hib-HepB",
        "asi.OPA": "OPV",
        "asi.Suçiçeği": "Windpocken",
        "asi.KKK": "MMR",
        "asi.Hep-A": "Hep-A",
        "asi.DaBT-İPA": "DTPa-IPV",
        "asi.Td": "Td"
    ]

    private static let fr: [String: String] = [
        "dil.baslik": "Langue",
        "dil.sistem": "Système",
        "dil.kapat": "Fermer",

        "common.cancel": "Annuler",
        "common.save": "Enregistrer",
        "common.delete": "Supprimer",
        "common.edit": "Modifier les informations",
        "common.share": "Partager la carte",
        "common.ok": "OK",

        "cinsiyet.baslik": "Sexe",
        "cinsiyet.erkek": "Garçon",
        "cinsiyet.kiz": "Fille",

        "liste.baslik": "Mes cartes enfants",
        "liste.bos.baslik": "Aucun enfant ajouté",
        "liste.bos.alt": "Ajoutez un enfant pour créer les cartes de vaccination, de groupe sanguin et d'allergie.",
        "liste.cocukEkle": "Ajouter un enfant",
        "liste.kayitli": "Enfants enregistrés",
        "liste.dogum": "Né(e) le : %@",
        "liste.kanGrubu": "Groupe sanguin : %@",
        "liste.geciken": "%d vaccins en retard",
        "liste.geciken.tek": "%d vaccin en retard",
        "liste.silOnay": "Supprimer toutes les cartes de cet enfant (vaccination et groupe sanguin) ?",
        "liste.vazgec": "Annuler",

        "geri.baslik": "Envoyer une erreur / un commentaire",
        "geri.kopyala": "Copier l'adresse e-mail",
        "geri.kopyalandi": "Adresse e-mail copiée",
        "geri.konu": "Mes cartes enfants - Commentaires",
        "geri.govde.satir": "Décrivez le problème ci-dessus. Ne partagez pas d'informations personnelles sur l'enfant.",
        "geri.govde.surum": "Version de l'app : %@ (%@)",
        "geri.govde.cihaz": "Appareil : %@",

        "menu.asiKarti": "Carte de vaccination",
        "menu.asiGuncel": "Calendrier vaccinal à jour",
        "menu.kanKarti": "Carte de groupe sanguin",
        "menu.kanYok": "Pas encore saisi",
        "menu.saglikKarti": "Carte allergies et maladies chroniques",
        "menu.kayitYok": "Aucune entrée",
        "menu.kayitSayisi": "%d entrées",
        "menu.kayitSayisi.tek": "%d entrée",

        "form.ad": "Prénom de l'enfant",
        "form.soyad": "Nom de famille de l'enfant",
        "form.kimlik": "N° d'identité national de l'enfant",
        "form.dogum": "Date de naissance de l'enfant",
        "form.bolum": "Informations sur l'enfant",
        "form.kimlikHata": "Le n° d'identité doit comporter 11 chiffres.",

        "asi.baslik": "CARNET DE VACCINATION 2026",
        "asi.kimlik": "N° d'identité : %@",
        "asi.dogumTarihi": "Date de naissance : %@",
        "asi.cinsiyetSatir": "Sexe : %@",
        "asi.zamaninda": "Fait à temps",
        "asi.planlandi": "Prévu",
        "asi.gec": "En retard / non fait",
        "asi.not": "Consultez un professionnel de santé pour le calendrier officiel.",
        "asi.paylas": "Carnet de vaccination – %@",

        "tarih.uygulama": "Date d'administration",
        "tarih.kaydiSil": "Supprimer l'entrée",

        "kan.baslik": "CARTE DE GROUPE SANGUIN",
        "kan.adSoyad": "Nom complet",
        "kan.dogumYeri": "Lieu de naissance",
        "kan.dogumTarihi": "Date de naissance",
        "kan.onaylayan": "Approuvé par",
        "kan.kartBilgileri": "Informations de la carte",
        "kan.kurum": "Établissement",
        "kan.bolum": "Groupe sanguin",
        "kan.bilgiBaslik": "Informations sur le groupe sanguin",
        "kan.paylas": "Carte de groupe sanguin – %@",

        "saglik.baslik": "CARTE ALLERGIES ET MALADIES CHRONIQUES",
        "saglik.baslikKisa": "Allergies et maladies chroniques",
        "saglik.bos": "Aucune allergie ou maladie chronique enregistrée.",
        "saglik.alerjiler": "ALLERGIES",
        "saglik.kronikler": "MALADIES CHRONIQUES",
        "saglik.tedavi": "Sous traitement",
        "saglik.tur": "Type",
        "saglik.alerji": "Allergie",
        "saglik.kronik": "Maladie chronique",
        "saglik.alerjiOrnek": "Allergie (ex. arachide, pénicilline)",
        "saglik.hastalikOrnek": "Maladie (ex. asthme, diabète)",
        "saglik.aciklama": "Description / réaction (facultatif)",
        "saglik.ilaclar": "Médicaments",
        "saglik.ilacEkle": "Ajouter un médicament",
        "saglik.ilacAdi": "Nom du médicament",
        "saglik.doz": "Dose (ex. 5 ml, 1 comprimé)",
        "saglik.siklik": "Fréquence (ex. 2 fois par jour)",
        "saglik.ilacNot": "Vous pouvez ajouter plusieurs médicaments. Balayez une ligne vers la gauche pour la supprimer.",
        "saglik.kaydiDuzenle": "Modifier l'entrée",
        "saglik.ekle": "Ajouter une allergie / maladie",
        "saglik.paylas": "Carte allergies et maladies chroniques – %@",
        "saglik.uyari": "Les informations enregistrées sont indicatives. Consultez votre médecin pour les décisions de traitement et de médicament.",

        "sutun.0": "Naissance",
        "sutun.2": "2 mois",
        "sutun.4": "4 mois",
        "sutun.6": "6 mois",
        "sutun.9": "9 mois",
        "sutun.12": "12 mois",
        "sutun.18": "18 mois",
        "sutun.24": "24 mois",
        "sutun.48": "48 mois",
        "sutun.156": "13 ans",

        "doz.Rapel": "Rappel",
        "doz.EkDoz": "Dose supplémentaire",

        "asi.Hep-B": "Hep-B",
        "asi.BCG": "BCG",
        "asi.KPA": "PCV",
        "asi.DaBT-İPA-Hib-HepB": "DTPa-VPI-Hib-HepB",
        "asi.OPA": "VPO",
        "asi.Suçiçeği": "Varicelle",
        "asi.KKK": "ROR",
        "asi.Hep-A": "Hep-A",
        "asi.DaBT-İPA": "DTPa-VPI",
        "asi.Td": "Td"
    ]

    private static let it: [String: String] = [
        "dil.baslik": "Lingua",
        "dil.sistem": "Sistema",
        "dil.kapat": "Chiudi",

        "common.cancel": "Annulla",
        "common.save": "Salva",
        "common.delete": "Elimina",
        "common.edit": "Modifica dati",
        "common.share": "Condividi scheda",
        "common.ok": "OK",

        "cinsiyet.baslik": "Sesso",
        "cinsiyet.erkek": "Maschio",
        "cinsiyet.kiz": "Femmina",

        "liste.baslik": "Le mie schede bambini",
        "liste.bos.baslik": "Nessun bambino aggiunto",
        "liste.bos.alt": "Aggiungi un bambino per creare le schede vaccini, gruppo sanguigno e allergie.",
        "liste.cocukEkle": "Aggiungi bambino",
        "liste.kayitli": "Bambini salvati",
        "liste.dogum": "Nato il: %@",
        "liste.kanGrubu": "Gruppo sanguigno: %@",
        "liste.geciken": "%d vaccini in ritardo",
        "liste.geciken.tek": "%d vaccino in ritardo",
        "liste.silOnay": "Eliminare tutte le schede di questo bambino (vaccini e gruppo sanguigno)?",
        "liste.vazgec": "Annulla",

        "geri.baslik": "Invia errore / feedback",
        "geri.kopyala": "Copia indirizzo e-mail",
        "geri.kopyalandi": "Indirizzo e-mail copiato",
        "geri.konu": "Le mie schede bambini - Feedback",
        "geri.govde.satir": "Descrivi il problema sopra. Non condividere informazioni personali sul bambino.",
        "geri.govde.surum": "Versione app: %@ (%@)",
        "geri.govde.cihaz": "Dispositivo: %@",

        "menu.asiKarti": "Scheda vaccini",
        "menu.asiGuncel": "Calendario vaccinale aggiornato",
        "menu.kanKarti": "Scheda gruppo sanguigno",
        "menu.kanYok": "Non ancora inserito",
        "menu.saglikKarti": "Scheda allergie e malattie croniche",
        "menu.kayitYok": "Nessun dato",
        "menu.kayitSayisi": "%d voci",
        "menu.kayitSayisi.tek": "%d voce",

        "form.ad": "Nome del bambino",
        "form.soyad": "Cognome del bambino",
        "form.kimlik": "Codice ID nazionale del bambino",
        "form.dogum": "Data di nascita del bambino",
        "form.bolum": "Dati del bambino",
        "form.kimlikHata": "Il codice ID deve avere 11 cifre.",

        "asi.baslik": "LIBRETTO VACCINALE 2026",
        "asi.kimlik": "Codice ID: %@",
        "asi.dogumTarihi": "Data di nascita: %@",
        "asi.cinsiyetSatir": "Sesso: %@",
        "asi.zamaninda": "Fatto in tempo",
        "asi.planlandi": "Previsto",
        "asi.gec": "In ritardo / non fatto",
        "asi.not": "Consulta la struttura sanitaria per il calendario ufficiale.",
        "asi.paylas": "Libretto vaccinale – %@",

        "tarih.uygulama": "Data di somministrazione",
        "tarih.kaydiSil": "Elimina voce",

        "kan.baslik": "SCHEDA GRUPPO SANGUIGNO",
        "kan.adSoyad": "Nome e cognome",
        "kan.dogumYeri": "Luogo di nascita",
        "kan.dogumTarihi": "Data di nascita",
        "kan.onaylayan": "Convalidato da",
        "kan.kartBilgileri": "Dati della scheda",
        "kan.kurum": "Struttura",
        "kan.bolum": "Gruppo sanguigno",
        "kan.bilgiBaslik": "Dati del gruppo sanguigno",
        "kan.paylas": "Scheda gruppo sanguigno – %@",

        "saglik.baslik": "SCHEDA ALLERGIE E MALATTIE CRONICHE",
        "saglik.baslikKisa": "Allergie e malattie croniche",
        "saglik.bos": "Nessuna allergia o malattia cronica registrata.",
        "saglik.alerjiler": "ALLERGIE",
        "saglik.kronikler": "MALATTIE CRONICHE",
        "saglik.tedavi": "In trattamento",
        "saglik.tur": "Tipo",
        "saglik.alerji": "Allergia",
        "saglik.kronik": "Malattia cronica",
        "saglik.alerjiOrnek": "Allergia (es. arachidi, penicillina)",
        "saglik.hastalikOrnek": "Malattia (es. asma, diabete)",
        "saglik.aciklama": "Descrizione / reazione (facoltativa)",
        "saglik.ilaclar": "Farmaci",
        "saglik.ilacEkle": "Aggiungi farmaco",
        "saglik.ilacAdi": "Nome del farmaco",
        "saglik.doz": "Dose (es. 5 ml, 1 compressa)",
        "saglik.siklik": "Frequenza (es. 2 volte al giorno)",
        "saglik.ilacNot": "Puoi aggiungere più farmaci. Scorri una riga a sinistra per eliminarla.",
        "saglik.kaydiDuzenle": "Modifica voce",
        "saglik.ekle": "Aggiungi allergia / malattia",
        "saglik.paylas": "Scheda allergie e malattie croniche – %@",
        "saglik.uyari": "Le informazioni registrate sono indicative. Consulta il medico per le decisioni su trattamento e farmaci.",

        "sutun.0": "Nascita",
        "sutun.2": "2 mesi",
        "sutun.4": "4 mesi",
        "sutun.6": "6 mesi",
        "sutun.9": "9 mesi",
        "sutun.12": "12 mesi",
        "sutun.18": "18 mesi",
        "sutun.24": "24 mesi",
        "sutun.48": "48 mesi",
        "sutun.156": "13 anni",

        "doz.Rapel": "Richiamo",
        "doz.EkDoz": "Dose aggiuntiva",

        "asi.Hep-B": "Hep-B",
        "asi.BCG": "BCG",
        "asi.KPA": "PCV",
        "asi.DaBT-İPA-Hib-HepB": "DTPa-IPV-Hib-EpB",
        "asi.OPA": "VPO",
        "asi.Suçiçeği": "Varicella",
        "asi.KKK": "MPR",
        "asi.Hep-A": "Hep-A",
        "asi.DaBT-İPA": "DTPa-IPV",
        "asi.Td": "Td"
    ]
}

// MARK: - Dil seçici

/// Uygulama içinden dil değiştirmeyi sağlayan sayfa.
struct DilSecici: View {
    @ObservedObject private var dil = Yerellestirme.paylasilan
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(UygulamaDili.allCases) { secenek in
                    Button {
                        dil.secim = secenek.rawValue
                    } label: {
                        HStack {
                            Text(dil.dilAdi(secenek))
                                .foregroundStyle(.primary)
                            Spacer()
                            if dil.secim == secenek.rawValue {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.tint)
                            }
                        }
                    }
                }
            }
            .navigationTitle(dil.metin("dil.baslik"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(dil.metin("dil.kapat")) { dismiss() }
                }
            }
        }
    }
}
