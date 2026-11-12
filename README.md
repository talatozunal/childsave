# Child Health (Çocuk Kartlarım)

Anne ve babaların çocuklarının sağlık bilgilerini yakından takip etmesi ve paylaşması için; çocuğunuzun aşı takibini, kan grubu bilgisini ve alerji / kronik hastalık kayıtlarını tek yerde tutan, tamamen cihaz üzerinde çalışan bir mobil uygulama.

## Özellikler

- **Aşı Takip Kartı:** Doğum tarihine göre otomatik aşı takvimi, uygulanan aşı tarihlerinin girilmesi, geciken aşıların kırmızı ile gösterilmesi
- **Kan Grubu Kartı:** Kurum, doğum yeri, kan grubu ve onaylayan bilgileri
- **Alerji ve Kronik Hastalık Kartı:** Sınırsız kayıt, kullanılan ilaç, doz ve kullanım sıklığı
- **Çoklu çocuk desteği:** Her çocuk için ayrı kartlar, cinsiyete göre renk teması
- **Kartları paylaşma:** Kartlar görsel olarak paylaşılabilir. Paylaşılan görselde T.C. Kimlik No maskelenir (ilk 2 ve son 2 hane görünür, örn. `12*******01`)
- **Beş dil:** Türkçe, İngilizce, Almanca, Fransızca ve İtalyanca; dil uygulama içinden, yeniden başlatmadan değiştirilebilir
- **Gizlilik:** Veriler yalnızca cihazda saklanır, hiçbir sunucuya gönderilmez

## Platformlar

| Platform | Klasör | Durum |
|----------|--------|-------|
| iOS (SwiftUI, iOS 16+) | [`ios/`](ios) | Hazır |
| Android | [`android/`](android) | Kaynak kod eklenecek |

Derlenmiş `.ipa` ve `.apk` dosyaları depo içine değil, **Releases** bölümüne eklenir.
Depodaki `Child Health.ipa`, Swift Playgrounds uyumlu uygulama paketini içeren
dağıtım arşividir.

## Dil desteği

Arayüz beş dilde gelir: Türkçe (varsayılan), İngilizce, Almanca, Fransızca ve
İtalyanca. Dil, uygulama yeniden başlatılmadan değişir; seçim `UserDefaults`
içinde `appLanguage` anahtarında saklanır.

- **Dil düğmesi:** Çocuk listesi ekranının sol üst köşesindeki küre simgesi.
- **Çeviriler:** [`ios/Dil.swift`](ios/Dil.swift) içindeki `Yerellestirme` sınıfında,
  dil başına anahtar-değer tablosu olarak tutulur.
- **Tarihler:** Seçilen dilin biçimine göre gösterilir (ör. `12 Kasım 2026`,
  `November 12, 2026`, `12. November 2026`).
- **Paylaşılan kartlar:** Kart görselleri de seçilen dilde üretilir.

## Kurulum (iOS)

Kaynak kod [`ios/`](ios) klasöründedir ve Swift Playgrounds uyumlu bir paket
olarak da açılabilir.

1. `ios/` klasörünü (veya `ios/Package.swift` dosyasını) Xcode'da açın
2. `childsave` şemasını seçip bir iOS simülatöründe veya cihazda çalıştırın
3. Kendi projenize taşıyacaksanız `ContentView.swift`, `Dil.swift` ve
   `MyApp.swift` dosyalarını birlikte ekleyin; `MyApp.swift` kök görünümü dil
   yöneticisine bağlar

## Android APK kurulumu

1. **Releases** bölümünden en son `.apk` dosyasını indirin
2. Telefonda "Bilinmeyen kaynaklardan yüklemeye izin ver" seçeneğini açın
3. APK dosyasına dokunup kurun

## Uyarı

Uygulamadaki aşı takvimi bilgilendirme amaçlıdır. Resmi takvim ve tedavi kararları için sağlık kuruluşunuza veya doktorunuza danışın.

## Gizlilik

Ayrıntılar için [PRIVACY.md](PRIVACY.md) dosyasına bakın.

## Geri bildirim

Hata bildirimi ve önerileri GitHub **Issues** bölümünden iletebilirsiniz.
