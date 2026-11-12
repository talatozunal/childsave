import SwiftUI
import UIKit

// MARK: - Modeller

enum Cinsiyet: String, Codable, CaseIterable, Identifiable {
    case erkek = "Erkek"
    case kiz = "Kız"
    
    var id: String { rawValue }
    
    /// Ekranda gösterilen yerelleştirilmiş ad. `rawValue` kayıt dosyasında
    /// anahtar olarak kaldığı için değiştirilmez.
    var etiket: String {
        self == .erkek
            ? Yerellestirme.paylasilan.metin("cinsiyet.erkek")
            : Yerellestirme.paylasilan.metin("cinsiyet.kiz")
    }
    
    // Kart başlığı ve çerçeve rengi: erkek mavi, kız pembe
    var renk: Color {
        switch self {
        case .erkek: return Color(red: 0.10, green: 0.40, blue: 0.85)
        case .kiz:   return Color(red: 0.90, green: 0.30, blue: 0.60)
        }
    }
}

struct Kisi: Codable, Equatable {
    var ad = ""
    var soyad = ""
    var kimlikNo = ""
    var dogumTarihi = Date()
    var cinsiyet: Cinsiyet? = nil   // eski kayıtlarda boş olabilir
    
    enum CodingKeys: String, CodingKey {
        case ad, soyad, kimlikNo, dogumTarihi, cinsiyet
    }
    
    init() {}
    
    // Cinsiyet alanı olmayan eski kayıtlar da sorunsuz yüklensin
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        ad = try c.decodeIfPresent(String.self, forKey: .ad) ?? ""
        soyad = try c.decodeIfPresent(String.self, forKey: .soyad) ?? ""
        kimlikNo = try c.decodeIfPresent(String.self, forKey: .kimlikNo) ?? ""
        dogumTarihi = try c.decodeIfPresent(Date.self, forKey: .dogumTarihi) ?? Date()
        cinsiyet = try c.decodeIfPresent(Cinsiyet.self, forKey: .cinsiyet)
    }
    
    // Kart teması: cinsiyet seçilmemişse lacivert
    var tema: Color {
        cinsiyet?.renk ?? Color(red: 0.0, green: 0.2, blue: 0.35)
    }
    
    var adSoyad: String { "\(ad) \(soyad)" }
    
    // Ekranda ve paylaşılan görselde kimlik no'nun yalnızca bir kısmı gösterilir
    var maskeliKimlik: String {
        guard kimlikNo.count == 11 else { return kimlikNo }
        return kimlikNo.prefix(3) + "•••••" + kimlikNo.suffix(3)
    }
}

// Kan grubu kartına özgü bilgiler (ad soyad ve doğum tarihi Kisi'den gelir)
struct KanKarti: Codable, Equatable {
    var kurum = ""
    var dogumYeri = ""
    var kanGrubu = ""
    var onaylayan = ""
}

// Her çocuğun kartları: kişi bilgileri + aşı tarihleri + kan grubu kartı
struct Cocuk: Identifiable, Codable, Equatable {
    var id = UUID()
    var kisi: Kisi
    var uygulananlar: [String: Date] = [:]
    var kanKarti = KanKarti()
    var saglikKayitlari: [SaglikKaydi] = []   // alerji ve kronik hastalıklar
    
    enum CodingKeys: String, CodingKey {
        case id, kisi, uygulananlar, kanKarti, saglikKayitlari
    }
    
    init(id: UUID = UUID(), kisi: Kisi,
         uygulananlar: [String: Date] = [:], kanKarti: KanKarti = KanKarti(),
         saglikKayitlari: [SaglikKaydi] = []) {
        self.id = id
        self.kisi = kisi
        self.uygulananlar = uygulananlar
        self.kanKarti = kanKarti
        self.saglikKayitlari = saglikKayitlari
    }
    
    // Kan kartı alanı olmayan eski kayıtlar da sorunsuz yüklensin
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        kisi = try c.decode(Kisi.self, forKey: .kisi)
        uygulananlar = try c.decodeIfPresent([String: Date].self, forKey: .uygulananlar) ?? [:]
        kanKarti = try c.decodeIfPresent(KanKarti.self, forKey: .kanKarti) ?? KanKarti()
        saglikKayitlari = try c.decodeIfPresent([SaglikKaydi].self,
                                                forKey: .saglikKayitlari) ?? []
    }
}

struct AsiSatiri: Identifiable {
    let ad: String              // kayıt anahtarı, çevrilmez
    let dozlar: [Int: String]   // ay -> doz etiketi
    var id: String { ad }
    
    var yerelAd: String { Yerellestirme.paylasilan.metin("asi.\(ad)") }
}

struct Secim: Identifiable {
    let anahtar: String
    let baslik: String
    var id: String { anahtar }
}

// MARK: - Kalıcı saklama

// İlk (tek çocuklu) sürümden geçiş için
struct KayitVerisi: Codable {
    var kisi: Kisi
    var uygulananlar: [String: Date]
}

// Veriler cihazdaki uygulama klasörüne yazılır. .completeFileProtection ile
// cihaz kilitliyken dosya şifreli kalır.
enum Depo {
    static var url: URL {
        let dizin = FileManager.default.urls(for: .applicationSupportDirectory,
                                             in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dizin, withIntermediateDirectories: true)
        return dizin.appendingPathComponent("asi_karti.json")
    }
    
    static func kaydet(_ cocuklar: [Cocuk]) {
        guard let data = try? JSONEncoder().encode(cocuklar) else { return }
        try? data.write(to: url, options: [.atomic, .completeFileProtection])
    }
    
    static func yukle() -> [Cocuk] {
        guard let data = try? Data(contentsOf: url) else { return [] }
        if let liste = try? JSONDecoder().decode([Cocuk].self, from: data) {
            return liste
        }
        if let eski = try? JSONDecoder().decode(KayitVerisi.self, from: data) {
            return [Cocuk(kisi: eski.kisi, uygulananlar: eski.uygulananlar)]
        }
        return []
    }
}

// MARK: - Takvim verisi

let sutunlar: [Int] = [0, 2, 4, 6, 9, 12, 18, 24, 48, 156]

/// Sütun başlığını seçili dilde döndürür.
func sutunAdi(_ ay: Int) -> String {
    Yerellestirme.paylasilan.metin("sutun.\(ay)")
}

/// "Rapel" ve "Ek Doz" etiketlerini seçili dile çevirir; I/II/III aynı kalır.
func dozEtiketi(_ doz: String) -> String {
    switch doz {
    case "Rapel": return Yerellestirme.paylasilan.metin("doz.Rapel")
    case "Ek Doz": return Yerellestirme.paylasilan.metin("doz.EkDoz")
    default: return doz
    }
}

let satirlar: [AsiSatiri] = [
    AsiSatiri(ad: "Hep-B", dozlar: [0: "I"]),
    AsiSatiri(ad: "BCG", dozlar: [2: "I"]),
    AsiSatiri(ad: "KPA", dozlar: [2: "I", 4: "II", 12: "Rapel"]),
    AsiSatiri(ad: "DaBT-İPA-Hib-HepB", dozlar: [2: "I", 4: "II", 6: "III", 18: "Rapel"]),
    AsiSatiri(ad: "OPA", dozlar: [6: "I", 18: "II"]),
    AsiSatiri(ad: "Suçiçeği", dozlar: [12: "I"]),
    AsiSatiri(ad: "KKK", dozlar: [9: "Ek Doz", 12: "I", 48: "II"]),
    AsiSatiri(ad: "Hep-A", dozlar: [18: "I", 24: "II"]),
    AsiSatiri(ad: "DaBT-İPA", dozlar: [48: "Rapel"]),
    AsiSatiri(ad: "Td", dozlar: [156: "Rapel"])
]

func anahtar(_ satir: AsiSatiri, _ ay: Int) -> String { "\(satir.ad)-\(ay)" }

// MARK: - Tarih ve renk mantığı

struct KartVerisi {
    let kisi: Kisi
    let uygulananlar: [String: Date]
    
    // 0 = planlanan günden 1 gün bile geç olursa kırmızı
    let toleransGun = 0
    
    func planTarihi(_ ay: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: ay, to: kisi.dogumTarihi)!
    }
    
    func sonGun(_ ay: Int) -> Date {
        let sinir = Calendar.current.date(byAdding: .day, value: toleransGun, to: planTarihi(ay))!
        return Calendar.current.startOfDay(for: sinir)
    }
    
    func gosterilenTarih(_ k: String, _ ay: Int) -> Date {
        uygulananlar[k] ?? planTarihi(ay)
    }
    
    // Kırmızı: geç yapılmış VEYA zamanı geçtiği halde yapılmamış
    func kirmizi(_ k: String, _ ay: Int) -> Bool {
        if let yapilan = uygulananlar[k] {
            return Calendar.current.startOfDay(for: yapilan) > sonGun(ay)
        }
        return sonGun(ay) < Calendar.current.startOfDay(for: Date())
    }
    
    func renk(_ k: String, _ ay: Int) -> Color {
        if kirmizi(k, ay) { return .red.opacity(0.35) }
        if uygulananlar[k] != nil { return .green.opacity(0.35) }
        return .cyan.opacity(0.25)
    }
    
    func tarihRengi(_ k: String, _ ay: Int) -> Color {
        if kirmizi(k, ay) { return .red }
        return uygulananlar[k] == nil ? .secondary : .primary
    }
    
    // Kırmızı (geciken) doz sayısı
    var gecikenSayisi: Int {
        var sayi = 0
        for satir in satirlar {
            for ay in satir.dozlar.keys where kirmizi(anahtar(satir, ay), ay) {
                sayi += 1
            }
        }
        return sayi
    }
}

// MARK: - iOS 16 ve 17 uyumlu onChange

extension View {
    // iOS 17+ için yeni, iOS 16 için eski onChange yazımını kullanır
    @ViewBuilder
    func degisince<V: Equatable>(of deger: V, _ islem: @escaping (V) -> Void) -> some View {
        if #available(iOS 17.0, *) {
            self.onChange(of: deger) { _, yeni in islem(yeni) }
        } else {
            self.onChange(of: deger) { yeni in islem(yeni) }
        }
    }
}

// MARK: - Geri bildirim / destek

// BURAYI KENDİ E-POSTA ADRESİNİZLE DEĞİŞTİRİN
let destekEposta = "talatozunal@yahoo.com"

enum GeriBildirim {
    // Hazır konu ve teknik bilgilerle (sürüm, iOS, cihaz) e-posta taslağı açar.
    // Çocuğa ait hiçbir kişisel bilgi e-postaya eklenmez.
    static var url: URL? {
        let bilgi = Bundle.main.infoDictionary
        let surum = bilgi?["CFBundleShortVersionString"] as? String ?? "?"
        let build = bilgi?["CFBundleVersion"] as? String ?? "?"
        let dil = Yerellestirme.paylasilan
        let govde = """
        
        
        ---
        \(dil.metin("geri.govde.satir"))
        \(dil.metin("geri.govde.surum", surum, build))
        iOS: \(UIDevice.current.systemVersion)
        \(dil.metin("geri.govde.cihaz", UIDevice.current.model))
        """
        
        var parcalar = URLComponents()
        parcalar.scheme = "mailto"
        parcalar.path = destekEposta
        parcalar.queryItems = [
            URLQueryItem(name: "subject", value: Yerellestirme.paylasilan.metin("geri.konu")),
            URLQueryItem(name: "body", value: govde)
        ]
        return parcalar.url
    }
}

// MARK: - 1. Ekran: Çocuk listesi

struct ContentView: View {
    @EnvironmentObject private var dil: Yerellestirme
    @State private var cocuklar = Depo.yukle()
    @State private var dilAcik = false
    @State private var yol: [UUID] = []
    @State private var yeniCocukAcik = false
    @State private var silinecek: Cocuk?
    @State private var kopyalandiUyarisi = false
    
    var body: some View {
        NavigationStack(path: $yol) {
            Group {
                if cocuklar.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 44))
                            .foregroundStyle(.white)
                            .frame(width: 96, height: 96)
                            .background(Circle().fill(uygulamaRengi))
                        Text(dil.metin("liste.bos.baslik"))
                            .font(.title3.bold())
                        Text(dil.metin("liste.bos.alt"))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Button(dil.metin("liste.cocukEkle")) { yeniCocukAcik = true }
                            .buttonStyle(.borderedProminent)
                    }
                    .padding(32)
                } else {
                    List {
                        Section {
                            Button {
                                yeniCocukAcik = true
                            } label: {
                                Label(dil.metin("liste.cocukEkle"), systemImage: "plus.circle.fill")
                            }
                        }
                        Section(dil.metin("liste.kayitli")) {
                            ForEach(cocuklar) { c in
                                NavigationLink(value: c.id) {
                                    HStack(spacing: 12) {
                                        Avatar(kisi: c.kisi)
                                        satir(c)
                                    }
                                }
                                .swipeActions {
                                    Button(dil.metin("common.delete"), role: .destructive) { silinecek = c }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(dil.metin("liste.baslik"))
            .scrollContentBackground(.hidden)
            .background(ArkaPlan().ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dilAcik = true
                    } label: {
                        Label(dil.metin("dil.baslik"), systemImage: "globe")
                    }
                    .sheet(isPresented: $dilAcik) {
                        DilSecici()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        if let url = GeriBildirim.url {
                            Link(destination: url) {
                                Label(dil.metin("geri.baslik"), systemImage: "envelope")
                            }
                        }
                        // Cihazda Mail uygulaması kurulu değilse adresi kopyalayıp başka yerden yazabilir
                        Button {
                            UIPasteboard.general.string = destekEposta
                            kopyalandiUyarisi = true
                        } label: {
                            Label(dil.metin("geri.kopyala"), systemImage: "doc.on.doc")
                        }
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
            .alert(dil.metin("geri.kopyalandi"), isPresented: $kopyalandiUyarisi) {
                Button(dil.metin("common.ok"), role: .cancel) {}
            } message: {
                Text(destekEposta)
            }
            .navigationDestination(for: UUID.self) { id in
                if let i = cocuklar.firstIndex(where: { $0.id == id }) {
                    CocukMenusu(cocuk: $cocuklar[i])
                }
            }
            .sheet(isPresented: $yeniCocukAcik) {
                CocukFormu(kisi: Kisi(), baslik: dil.metin("liste.cocukEkle")) { yeni in
                    let c = Cocuk(kisi: yeni)
                    cocuklar.append(c)
                    yol.append(c.id)   // yeni çocuğun kart menüsünü hemen aç
                }
            }
            .confirmationDialog(
                dil.metin("liste.silOnay"),
                isPresented: Binding(get: { silinecek != nil },
                                     set: { if !$0 { silinecek = nil } }),
                titleVisibility: .visible
            ) {
                Button(dil.metin("common.delete"), role: .destructive) {
                    if let s = silinecek { cocuklar.removeAll { $0.id == s.id } }
                    silinecek = nil
                }
                Button(dil.metin("liste.vazgec"), role: .cancel) { silinecek = nil }
            }
            .degisince(of: cocuklar) { yeni in Depo.kaydet(yeni) }
        }
        .tint(uygulamaRengi)
    }
    
    func satir(_ c: Cocuk) -> some View {
        let geciken = KartVerisi(kisi: c.kisi, uygulananlar: c.uygulananlar).gecikenSayisi
        return VStack(alignment: .leading, spacing: 3) {
            Text(c.kisi.adSoyad).font(.headline)
            Text(dil.metin("liste.dogum", dil.uzunTarih(c.kisi.dogumTarihi)))
                .font(.caption)
                .foregroundStyle(.secondary)
            if !c.kanKarti.kanGrubu.isEmpty {
                Text(dil.metin("liste.kanGrubu", c.kanKarti.kanGrubu))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if geciken > 0 {
                Text(dil.sayili("liste.geciken", geciken))
                    .font(.caption.bold())
                    .foregroundStyle(.red)
            }
        }
    }
}

// MARK: - 2. Ekran: Çocuğun kart menüsü

// Uygulamanın genel vurgu rengi (turkuaz)
let uygulamaRengi = Color(red: 0.0, green: 0.55, blue: 0.55)

// Hafif renk geçişli, açık/koyu temaya uyumlu arka plan
struct ArkaPlan: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
            LinearGradient(colors: [uygulamaRengi.opacity(0.18), Color.clear],
                           startPoint: .top, endPoint: .center)
        }
    }
}

// Çocuğun adının baş harfini gösteren yuvarlak simge (cinsiyet renginde)
struct Avatar: View {
    let kisi: Kisi
    var boyut: CGFloat = 44
    var ters = false   // renkli zemin üzerinde beyaz simge
    
    var body: some View {
        Text(String(kisi.ad.prefix(1)).uppercased(with: Yerellestirme.paylasilan.locale))
            .font(.system(size: boyut * 0.45, weight: .bold))
            .foregroundStyle(ters ? kisi.tema : Color.white)
            .frame(width: boyut, height: boyut)
            .background(Circle().fill(ters ? Color.white : kisi.tema))
    }
}

// Menüdeki renkli kart kutusu
struct KartKutusu: View {
    let baslik: String
    let alt: String
    let simge: String
    let renk: Color
    var uyari = false
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: simge)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(
                    LinearGradient(colors: [renk, renk.opacity(0.7)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
            
            VStack(alignment: .leading, spacing: 3) {
                Text(baslik).font(.headline)
                Text(alt)
                    .font(.caption)
                    .foregroundStyle(uyari ? Color.red : Color.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(renk.opacity(0.10))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(renk.opacity(0.35), lineWidth: 1.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct CocukMenusu: View {
    @EnvironmentObject private var dil: Yerellestirme
    @Binding var cocuk: Cocuk
    @State private var duzenleAcik = false
    
    var geciken: Int {
        KartVerisi(kisi: cocuk.kisi, uygulananlar: cocuk.uygulananlar).gecikenSayisi
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Üstte çocuğun renkli kimlik kartı
                HStack(spacing: 14) {
                    Avatar(kisi: cocuk.kisi, boyut: 60, ters: true)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(cocuk.kisi.adSoyad).font(.title3.bold())
                        Text(dil.metin("liste.dogum", dil.uzunTarih(cocuk.kisi.dogumTarihi)))
                            .font(.subheadline)
                        if let c = cocuk.kisi.cinsiyet {
                            Text(c.etiket).font(.caption.bold())
                        }
                    }
                    Spacer()
                }
                .foregroundStyle(.white)
                .padding(16)
                .background(
                    LinearGradient(colors: [cocuk.kisi.tema, cocuk.kisi.tema.opacity(0.7)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                NavigationLink {
                    AsiKartiEkrani(cocuk: $cocuk)
                } label: {
                    KartKutusu(baslik: dil.metin("menu.asiKarti"),
                               alt: geciken > 0
                               ? dil.sayili("liste.geciken", geciken)
                               : dil.metin("menu.asiGuncel"),
                               simge: "syringe",
                               renk: cocuk.kisi.tema,
                               uyari: geciken > 0)
                }
                .buttonStyle(.plain)
                
                NavigationLink {
                    KanGrubuKartiEkrani(cocuk: $cocuk)
                } label: {
                    KartKutusu(baslik: dil.metin("menu.kanKarti"),
                               alt: cocuk.kanKarti.kanGrubu.isEmpty
                               ? dil.metin("menu.kanYok") : cocuk.kanKarti.kanGrubu,
                               simge: "drop.fill",
                               renk: .red)
                }
                .buttonStyle(.plain)
                
                NavigationLink {
                    SaglikKartiEkrani(cocuk: $cocuk)
                } label: {
                    KartKutusu(baslik: dil.metin("menu.saglikKarti"),
                               alt: cocuk.saglikKayitlari.isEmpty
                               ? dil.metin("menu.kayitYok")
                               : dil.sayili("menu.kayitSayisi", cocuk.saglikKayitlari.count),
                               simge: "cross.case.fill",
                               renk: saglikCerceveRengi)
                }
                .buttonStyle(.plain)
                
                Button {
                    duzenleAcik = true
                } label: {
                    Label(dil.metin("common.edit"), systemImage: "pencil")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(cocuk.kisi.tema)
                .padding(.top, 6)
            }
            .padding()
            .frame(maxWidth: 520)
            .frame(maxWidth: .infinity)
        }
        .background(cocuk.kisi.tema.opacity(0.07).ignoresSafeArea())
        .navigationTitle(cocuk.kisi.ad)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $duzenleAcik) {
            CocukFormu(kisi: cocuk.kisi, baslik: dil.metin("common.edit")) { yeni in
                cocuk.kisi = yeni
            }
        }
    }
}

// MARK: - Çocuk ekleme / düzenleme formu

struct CocukFormu: View {
    @EnvironmentObject private var dil: Yerellestirme
    @State var kisi: Kisi
    var baslik: String
    var onKaydet: (Kisi) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var kimlikGecerli: Bool {
        kisi.kimlikNo.count == 11 && kisi.kimlikNo.first != "0"
    }
    
    var formGecerli: Bool {
        !kisi.ad.trimmingCharacters(in: .whitespaces).isEmpty &&
        !kisi.soyad.trimmingCharacters(in: .whitespaces).isEmpty &&
        kisi.cinsiyet != nil &&
        kimlikGecerli
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(dil.metin("form.ad"), text: $kisi.ad)
                    TextField(dil.metin("form.soyad"), text: $kisi.soyad)
                    TextField(dil.metin("form.kimlik"), text: $kisi.kimlikNo)
                        .keyboardType(.numberPad)
                        .degisince(of: kisi.kimlikNo) { yeni in
                            kisi.kimlikNo = String(yeni.filter(\.isNumber).prefix(11))
                        }
                    DatePicker(dil.metin("form.dogum"),
                               selection: $kisi.dogumTarihi,
                               in: ...Date(),
                               displayedComponents: .date)
                    .environment(\.locale, dil.locale)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(dil.metin("cinsiyet.baslik"))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Picker(dil.metin("cinsiyet.baslik"), selection: $kisi.cinsiyet) {
                            ForEach(Cinsiyet.allCases) { c in
                                Text(c.etiket).tag(Optional(c))
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                } header: {
                    Text(dil.metin("form.bolum"))
                } footer: {
                    if !kimlikGecerli && !kisi.kimlikNo.isEmpty {
                        Text(dil.metin("form.kimlikHata"))
                    }
                }
            }
            .navigationTitle(baslik)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(dil.metin("common.cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(dil.metin("common.save")) {
                        onKaydet(kisi)
                        dismiss()
                    }
                    .disabled(!formGecerli)
                }
            }
        }
    }
}

// MARK: - Aşı kartı parçaları

struct KartBasligi: View {
    let kisi: Kisi
    
    private var dil: Yerellestirme { .paylasilan }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(dil.metin("asi.baslik"))
                .font(.headline.bold())
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(kisi.tema)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(dil.metin("form.ad"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(kisi.adSoyad).font(.title2.bold())
                Text(dil.metin("asi.kimlik", kisi.maskeliKimlik))
                Text(dil.metin("asi.dogumTarihi", dil.uzunTarih(kisi.dogumTarihi)))
                if let c = kisi.cinsiyet {
                    Text(dil.metin("asi.cinsiyetSatir", c.etiket))
                }
            }
            .font(.subheadline)
        }
    }
}

struct Aciklama: View {
    private var dil: Yerellestirme { .paylasilan }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            satir(.green.opacity(0.35), dil.metin("asi.zamaninda"))
            satir(.cyan.opacity(0.25), dil.metin("asi.planlandi"))
            satir(.red.opacity(0.35), dil.metin("asi.gec"))
        }
        .font(.caption)
    }
    
    func satir(_ renk: Color, _ metin: String) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 3).fill(renk).frame(width: 14, height: 14)
            Text(metin)
        }
    }
}

// Geniş ekran (iPad) için tablo görünümü; paylaşılan görselde de bu kullanılır
struct KartTablosu: View {
    let veri: KartVerisi
    var onSec: ((Secim) -> Void)? = nil
    
    var body: some View {
        Grid(horizontalSpacing: 2, verticalSpacing: 2) {
            GridRow {
                Text("").frame(width: 110)
                ForEach(sutunlar, id: \.self) { ay in
                    Text(sutunAdi(ay))
                        .font(.caption.bold())
                        .frame(width: 72, height: 36)
                }
            }
            ForEach(satirlar) { satir in
                GridRow {
                    Text(satir.yerelAd)
                        .font(.caption.bold())
                        .frame(width: 110, alignment: .leading)
                    ForEach(sutunlar, id: \.self) { ay in
                        hucre(satir: satir, ay: ay)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func hucre(satir: AsiSatiri, ay: Int) -> some View {
        if let doz = satir.dozlar[ay] {
            let k = anahtar(satir, ay)
            if let onSec {
                Button {
                    onSec(Secim(anahtar: k, baslik: "\(satir.yerelAd) – \(dozEtiketi(doz))"))
                } label: {
                    hucreIcerik(doz: doz, k: k, ay: ay)
                }
                .buttonStyle(.plain)
            } else {
                hucreIcerik(doz: doz, k: k, ay: ay)
            }
        } else {
            Color.clear.frame(width: 72, height: 44)
        }
    }
    
    func hucreIcerik(doz: String, k: String, ay: Int) -> some View {
        VStack(spacing: 2) {
            Text(dozEtiketi(doz)).font(.caption.bold())
            Text(veri.gosterilenTarih(k, ay), format: .dateTime.day().month().year(.twoDigits))
                .font(.system(size: 10))
                .foregroundStyle(veri.tarihRengi(k, ay))
        }
        .frame(width: 72, height: 44)
        .background(veri.renk(k, ay))
    }
}

// Dar ekran (iPhone) için liste görünümü
struct KartListesi: View {
    let veri: KartVerisi
    let onSec: (Secim) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(satirlar) { satir in
                VStack(alignment: .leading, spacing: 6) {
                    Text(satir.yerelAd).font(.subheadline.bold())
                    ForEach(sutunlar.filter { satir.dozlar[$0] != nil }, id: \.self) { ay in
                        let doz = satir.dozlar[ay] ?? ""
                        let k = anahtar(satir, ay)
                        Button {
                            onSec(Secim(anahtar: k, baslik: "\(satir.yerelAd) – \(dozEtiketi(doz))"))
                        } label: {
                            HStack {
                                Text("\(sutunAdi(ay)) · \(dozEtiketi(doz))")
                                    .font(.footnote.bold())
                                Spacer()
                                Text(veri.gosterilenTarih(k, ay),
                                     format: .dateTime.day().month().year())
                                .font(.footnote)
                                .foregroundStyle(veri.tarihRengi(k, ay))
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 10)
                            .background(veri.renk(k, ay))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

// Paylaşılacak görsel: her zaman tablo düzeni, açık tema, beyaz zemin
struct PaylasimKarti: View {
    let veri: KartVerisi
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            KartBasligi(kisi: veri.kisi)
            KartTablosu(veri: veri)
            Aciklama()
        }
        .padding(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(veri.kisi.tema, lineWidth: 3)
        )
        .padding(12)
        .frame(width: 900)
        .background(Color.white)
        .foregroundStyle(Color.black)
        .environment(\.colorScheme, .light)
        .environment(\.locale, Yerellestirme.paylasilan.locale)
    }
}

// MARK: - Aşı kartı ekranı

struct AsiKartiEkrani: View {
    @EnvironmentObject private var dil: Yerellestirme
    @Binding var cocuk: Cocuk
    @State private var secim: Secim?
    @Environment(\.horizontalSizeClass) private var sinif
    
    var kisi: Kisi { cocuk.kisi }
    var veri: KartVerisi { KartVerisi(kisi: cocuk.kisi, uygulananlar: cocuk.uygulananlar) }
    
    @MainActor
    var paylasimGorseli: Image {
        let renderer = ImageRenderer(content: PaylasimKarti(veri: veri))
        renderer.scale = 3
        if let ui = renderer.uiImage {
            return Image(uiImage: ui)
        }
        return Image(systemName: "square.and.arrow.up")
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                KartBasligi(kisi: kisi)
                
                if sinif == .compact {
                    KartListesi(veri: veri) { secim = $0 }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        KartTablosu(veri: veri) { secim = $0 }
                    }
                }
                
                Aciklama()
                
                Text(dil.metin("asi.not"))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                ShareLink(
                    item: paylasimGorseli,
                    preview: SharePreview(dil.metin("asi.paylas", kisi.adSoyad),
                                          image: paylasimGorseli)
                ) {
                    Label(dil.metin("common.share"), systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(kisi.tema, lineWidth: 3)
            )
            .padding()
        }
        .navigationTitle(dil.metin("menu.asiKarti"))
        .background(kisi.tema.opacity(0.07).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $secim) { s in
            TarihSecici(secim: s, uygulananlar: $cocuk.uygulananlar)
                .presentationDetents([.medium])
        }
    }
}

// MARK: - Uygulama tarihi seçici

struct TarihSecici: View {
    @EnvironmentObject private var dil: Yerellestirme
    let secim: Secim
    @Binding var uygulananlar: [String: Date]
    @Environment(\.dismiss) private var dismiss
    @State private var tarih = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker(dil.metin("tarih.uygulama"), selection: $tarih,
                           in: ...Date(), displayedComponents: .date)
                .environment(\.locale, dil.locale)
                Button(dil.metin("common.save")) {
                    uygulananlar[secim.anahtar] = tarih
                    dismiss()
                }
                if uygulananlar[secim.anahtar] != nil {
                    Button(dil.metin("tarih.kaydiSil"), role: .destructive) {
                        uygulananlar[secim.anahtar] = nil
                        dismiss()
                    }
                }
            }
            .navigationTitle(secim.baslik)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { tarih = uygulananlar[secim.anahtar] ?? Date() }
        }
    }
}

// MARK: - Kan grubu kartı

// Kan grubu seçici (A/B/AB/0 ve Rh +/−)
struct KanGrubuSecici: View {
    @Binding var secilen: String
    let secenekler = ["A Rh+", "A Rh−", "B Rh+", "B Rh−",
                      "AB Rh+", "AB Rh−", "0 Rh+", "0 Rh−"]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4),
                  spacing: 8) {
            ForEach(secenekler, id: \.self) { s in
                Button {
                    secilen = s
                } label: {
                    Text(s)
                        .font(.footnote.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(secilen == s ? Color.red : Color.gray.opacity(0.15))
                        .foregroundStyle(secilen == s ? Color.white : Color.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// Kartın görünümü (ekranda ve paylaşılan görselde ortak)
struct KanKartiGorunumu: View {
    let kisi: Kisi
    let kart: KanKarti
    
    private var dil: Yerellestirme { .paylasilan }
    
    var body: some View {
        VStack(spacing: 12) {
            Text(dil.metin("kan.baslik"))
                .font(.headline.bold())
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(kisi.tema)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            if !kart.kurum.isEmpty {
                Text(kart.kurum)
                    .font(.subheadline.bold())
                    .multilineTextAlignment(.center)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                bilgi(dil.metin("kan.adSoyad"), kisi.adSoyad)
                bilgi(dil.metin("kan.dogumYeri"), kart.dogumYeri)
                bilgi(dil.metin("kan.dogumTarihi"), dil.uzunTarih(kisi.dogumTarihi))
                if let c = kisi.cinsiyet {
                    bilgi(dil.metin("cinsiyet.baslik"), c.etiket)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(kart.kanGrubu.isEmpty ? "—" : kart.kanGrubu)
                .font(.system(size: 44, weight: .heavy))
                .foregroundStyle(.red)
                .padding(.vertical, 4)
            
            bilgi(dil.metin("kan.onaylayan"), kart.onaylayan)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    func bilgi(_ baslik: String, _ deger: String) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(baslik).font(.caption).foregroundStyle(.secondary)
            Text(deger.isEmpty ? "—" : deger).font(.body.bold())
        }
    }
}

// Paylaşılacak görsel: açık tema, beyaz zemin
struct KanKartiPaylasim: View {
    let kisi: Kisi
    let kart: KanKarti
    
    var body: some View {
        KanKartiGorunumu(kisi: kisi, kart: kart)
            .padding(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(kisi.tema, lineWidth: 3)
            )
            .padding(12)
            .frame(width: 380)
            .background(Color.white)
            .foregroundStyle(Color.black)
            .environment(\.colorScheme, .light)
            .environment(\.locale, Yerellestirme.paylasilan.locale)
    }
}

// Kan grubu kartına özgü bilgilerin girildiği form
struct KanKartiFormu: View {
    @EnvironmentObject private var dil: Yerellestirme
    @State var kart: KanKarti
    var onKaydet: (KanKarti) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(dil.metin("kan.kartBilgileri")) {
                    TextField(dil.metin("kan.kurum"), text: $kart.kurum)
                    TextField(dil.metin("kan.dogumYeri"), text: $kart.dogumYeri)
                    TextField(dil.metin("kan.onaylayan"), text: $kart.onaylayan)
                }
                Section(dil.metin("kan.bolum")) {
                    KanGrubuSecici(secilen: $kart.kanGrubu)
                        .padding(.vertical, 4)
                }
            }
            .navigationTitle(dil.metin("kan.bilgiBaslik"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(dil.metin("common.cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(dil.metin("common.save")) {
                        onKaydet(kart)
                        dismiss()
                    }
                    .disabled(kart.kanGrubu.isEmpty)
                }
            }
        }
    }
}

struct KanGrubuKartiEkrani: View {
    @EnvironmentObject private var dil: Yerellestirme
    @Binding var cocuk: Cocuk
    @State private var duzenleAcik = false
    
    @MainActor
    var paylasimGorseli: Image {
        let renderer = ImageRenderer(
            content: KanKartiPaylasim(kisi: cocuk.kisi, kart: cocuk.kanKarti))
        renderer.scale = 3
        if let ui = renderer.uiImage {
            return Image(uiImage: ui)
        }
        return Image(systemName: "square.and.arrow.up")
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                KanKartiGorunumu(kisi: cocuk.kisi, kart: cocuk.kanKarti)
                    .padding(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(cocuk.kisi.tema, lineWidth: 3)
                    )
                
                Button {
                    duzenleAcik = true
                } label: {
                    Label(dil.metin("common.edit"), systemImage: "pencil")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                ShareLink(
                    item: paylasimGorseli,
                    preview: SharePreview(dil.metin("kan.paylas", cocuk.kisi.adSoyad),
                                          image: paylasimGorseli)
                ) {
                    Label(dil.metin("common.share"), systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(cocuk.kanKarti.kanGrubu.isEmpty)
            }
            .padding()
            .frame(maxWidth: 480)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(dil.metin("menu.kanKarti"))
        .background(cocuk.kisi.tema.opacity(0.07).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $duzenleAcik) {
            KanKartiFormu(kart: cocuk.kanKarti) { yeni in
                cocuk.kanKarti = yeni
            }
        }
        .onAppear {
            // Kan grubu henüz girilmediyse formu otomatik aç
            if cocuk.kanKarti.kanGrubu.isEmpty { duzenleAcik = true }
        }
    }
}

// MARK: - Alerji ve kronik hastalık kartı

// Alerji ve kronik hastalık kartının dış çerçeve rengi (turkuaz)
let saglikCerceveRengi = Color(red: 0.0, green: 0.55, blue: 0.55)

enum SaglikTuru: String, Codable, CaseIterable, Identifiable {
    case alerji = "Alerji"
    case kronik = "Kronik Hastalık"
    
    var id: String { rawValue }
    
    /// Seçicide gösterilen yerelleştirilmiş ad. `rawValue` kayıt dosyasında
    /// anahtar olarak kaldığı için değiştirilmez.
    var etiket: String {
        self == .alerji
            ? Yerellestirme.paylasilan.metin("saglik.alerji")
            : Yerellestirme.paylasilan.metin("saglik.kronik")
    }
    
    var baslik: String {
        self == .alerji
            ? Yerellestirme.paylasilan.metin("saglik.alerjiler")
            : Yerellestirme.paylasilan.metin("saglik.kronikler")
    }
    
    var simge: String {
        self == .alerji ? "exclamationmark.triangle.fill" : "heart.text.square.fill"
    }
    
    var renk: Color {
        self == .alerji ? .orange : .purple
    }
}

// Bir hastalık/alerji için kullanılan ilaç ve dozu
struct Ilac: Codable, Equatable, Identifiable {
    var id = UUID()
    var ad = ""
    var doz = ""      // ör. 5 ml, 1 tablet
    var siklik = ""   // ör. günde 2 kez
    
    var ozet: String {
        [ad, doz, siklik].filter { !$0.isEmpty }.joined(separator: " · ")
    }
}

// Sınırsız sayıda eklenebilen alerji / kronik hastalık kaydı
struct SaglikKaydi: Codable, Equatable, Identifiable {
    var id = UUID()
    var tur: SaglikTuru = .alerji
    var ad = ""
    var aciklama = ""            // reaksiyon, not vb. (isteğe bağlı)
    var tedaviAliyor = false
    var ilaclar: [Ilac] = []
}

// Kartın görünümü (ekranda ve paylaşılan görselde ortak)
struct SaglikKartiGorunumu: View {
    let kisi: Kisi
    let kayitlar: [SaglikKaydi]
    var onSec: ((SaglikKaydi) -> Void)? = nil
    
    private var dil: Yerellestirme { .paylasilan }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(dil.metin("saglik.baslik"))
                .font(.headline.bold())
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(kisi.tema)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(dil.metin("form.ad"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(kisi.adSoyad).font(.title2.bold())
                Text(dil.metin("asi.dogumTarihi", dil.uzunTarih(kisi.dogumTarihi)))
                    .font(.subheadline)
            }
            
            if kayitlar.isEmpty {
                Text(dil.metin("saglik.bos"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            ForEach(SaglikTuru.allCases) { tur in
                let liste = kayitlar.filter { $0.tur == tur }
                if !liste.isEmpty {
                    Text(tur.baslik)
                        .font(.caption.bold())
                        .foregroundStyle(tur.renk)
                    ForEach(liste) { k in
                        satir(k)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func satir(_ k: SaglikKaydi) -> some View {
        if let onSec {
            Button {
                onSec(k)
            } label: {
                satirIcerik(k)
            }
            .buttonStyle(.plain)
        } else {
            satirIcerik(k)
        }
    }
    
    func satirIcerik(_ k: SaglikKaydi) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: k.tur.simge)
                    .foregroundStyle(k.tur.renk)
                Text(k.ad).font(.body.bold())
                Spacer()
                if k.tedaviAliyor {
                    Text(dil.metin("saglik.tedavi"))
                        .font(.caption2.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.green.opacity(0.25))
                        .clipShape(Capsule())
                }
            }
            if !k.aciklama.isEmpty {
                Text(k.aciklama)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            if k.tedaviAliyor {
                ForEach(k.ilaclar) { ilac in
                    Label(ilac.ozet, systemImage: "pills")
                        .font(.footnote)
                }
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(k.tur.renk.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// Paylaşılacak görsel: açık tema, beyaz zemin
struct SaglikKartiPaylasim: View {
    let kisi: Kisi
    let kayitlar: [SaglikKaydi]
    
    var body: some View {
        SaglikKartiGorunumu(kisi: kisi, kayitlar: kayitlar)
            .padding(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(kisi.tema, lineWidth: 3)
            )
            .padding(6)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(saglikCerceveRengi, lineWidth: 5)
            )
            .padding(12)
            .frame(width: 400)
            .background(Color.white)
            .foregroundStyle(Color.black)
            .environment(\.colorScheme, .light)
            .environment(\.locale, Yerellestirme.paylasilan.locale)
    }
}

// Alerji / hastalık ekleme ve düzenleme formu
struct SaglikFormu: View {
    @EnvironmentObject private var dil: Yerellestirme
    @State var kayit: SaglikKaydi
    var mevcut: Bool
    var onKaydet: (SaglikKaydi) -> Void
    var onSil: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker(dil.metin("saglik.tur"), selection: $kayit.tur) {
                        ForEach(SaglikTuru.allCases) { t in
                            Text(t.etiket).tag(t)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    TextField(kayit.tur == .alerji
                              ? dil.metin("saglik.alerjiOrnek")
                              : dil.metin("saglik.hastalikOrnek"),
                              text: $kayit.ad)
                    
                    TextField(dil.metin("saglik.aciklama"),
                              text: $kayit.aciklama, axis: .vertical)
                    .lineLimit(1...4)
                }
                
                Section {
                    Toggle(dil.metin("saglik.tedavi"), isOn: $kayit.tedaviAliyor)
                }
                
                if kayit.tedaviAliyor {
                    Section {
                        ForEach($kayit.ilaclar) { $ilac in
                            VStack(alignment: .leading, spacing: 6) {
                                TextField(dil.metin("saglik.ilacAdi"), text: $ilac.ad)
                                    .font(.body.bold())
                                TextField(dil.metin("saglik.doz"), text: $ilac.doz)
                                TextField(dil.metin("saglik.siklik"),
                                          text: $ilac.siklik)
                            }
                            .padding(.vertical, 2)
                        }
                        .onDelete { kayit.ilaclar.remove(atOffsets: $0) }
                        
                        Button {
                            kayit.ilaclar.append(Ilac())
                        } label: {
                            Label(dil.metin("saglik.ilacEkle"), systemImage: "plus.circle.fill")
                        }
                    } header: {
                        Text(dil.metin("saglik.ilaclar"))
                    } footer: {
                        Text(dil.metin("saglik.ilacNot"))
                    }
                }
                
                if mevcut {
                    Section {
                        Button(dil.metin("tarih.kaydiSil"), role: .destructive) {
                            onSil()
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle(mevcut
                             ? dil.metin("saglik.kaydiDuzenle")
                             : dil.metin("saglik.ekle"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(dil.metin("common.cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(dil.metin("common.save")) {
                        var temiz = kayit
                        temiz.ad = temiz.ad.trimmingCharacters(in: .whitespaces)
                        // Adı boş bırakılan ilaç satırlarını at
                        temiz.ilaclar.removeAll {
                            $0.ad.trimmingCharacters(in: .whitespaces).isEmpty
                        }
                        onKaydet(temiz)
                        dismiss()
                    }
                    .disabled(kayit.ad.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

struct SaglikKartiEkrani: View {
    @EnvironmentObject private var dil: Yerellestirme
    @Binding var cocuk: Cocuk
    @State private var duzenlenen: SaglikKaydi?
    
    @MainActor
    var paylasimGorseli: Image {
        let renderer = ImageRenderer(
            content: SaglikKartiPaylasim(kisi: cocuk.kisi, kayitlar: cocuk.saglikKayitlari))
        renderer.scale = 3
        if let ui = renderer.uiImage {
            return Image(uiImage: ui)
        }
        return Image(systemName: "square.and.arrow.up")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Kayıtlar çoğaldıkça kart bu alanda aşağı kaydırılır
            ScrollView {
                SaglikKartiGorunumu(kisi: cocuk.kisi, kayitlar: cocuk.saglikKayitlari) {
                    duzenlenen = $0
                }
                .padding(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(cocuk.kisi.tema, lineWidth: 3)
                )
                .padding(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(saglikCerceveRengi, lineWidth: 5)
                )
                .padding()
            }
            
            // Düğmeler altta sabit kalır, her zaman erişilebilir
            VStack(spacing: 10) {
                Button {
                    duzenlenen = SaglikKaydi()
                } label: {
                    Label(dil.metin("saglik.ekle"), systemImage: "plus.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                ShareLink(
                    item: paylasimGorseli,
                    preview: SharePreview(
                        dil.metin("saglik.paylas", cocuk.kisi.adSoyad),
                        image: paylasimGorseli)
                ) {
                    Label(dil.metin("common.share"), systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(cocuk.saglikKayitlari.isEmpty)
                
                Text(dil.metin("saglik.uyari"))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(.bar)
        }
        .frame(maxWidth: 520)
        .frame(maxWidth: .infinity)
        .navigationTitle(dil.metin("saglik.baslikKisa"))
        .background(cocuk.kisi.tema.opacity(0.07).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $duzenlenen) { k in
            let mevcut = cocuk.saglikKayitlari.contains { $0.id == k.id }
            SaglikFormu(
                kayit: k,
                mevcut: mevcut,
                onKaydet: { yeni in
                    if let i = cocuk.saglikKayitlari.firstIndex(where: { $0.id == yeni.id }) {
                        cocuk.saglikKayitlari[i] = yeni
                    } else {
                        cocuk.saglikKayitlari.append(yeni)
                    }
                },
                onSil: {
                    cocuk.saglikKayitlari.removeAll { $0.id == k.id }
                }
            )
        }
    }
}

