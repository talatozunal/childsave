# ChildSave (Çocuk Kartlarım)

Anne ve babaların çocuklarının sağlık bilgilerini yakından takip etmesi ve paylaşması için; çocuğunuzun aşı takibini, kan grubu bilgisini ve alerji / kronik hastalık kayıtlarını tek yerde tutan, tamamen cihaz üzerinde çalışan bir mobil uygulama.

## Özellikler

- **Aşı Takip Kartı:** Doğum tarihine göre otomatik aşı takvimi, uygulanan aşı tarihlerinin girilmesi, geciken aşıların kırmızı ile gösterilmesi
- **Kan Grubu Kartı:** Kurum, doğum yeri, kan grubu ve onaylayan bilgileri
- **Alerji ve Kronik Hastalık Kartı:** Sınırsız kayıt, kullanılan ilaç, doz ve kullanım sıklığı
- **Çoklu çocuk desteği:** Her çocuk için ayrı kartlar, cinsiyete göre renk teması
- **Kartları paylaşma:** Kartlar görsel olarak paylaşılabilir. Paylaşılan görselde T.C. Kimlik No maskelenir (ilk 2 ve son 2 hane görünür, örn. `12*******01`)
- **Gizlilik:** Veriler yalnızca cihazda saklanır, hiçbir sunucuya gönderilmez

## Platformlar

| Platform | Klasör | Durum |
|----------|--------|-------|
| iOS (SwiftUI, iOS 16+) | [`ios/`](ios) | Hazır |
| Android | [`android/`](android) | Kaynak kod eklenecek |

Derlenmiş `.ipa` ve `.apk` dosyaları depo içine değil, **Releases** bölümüne eklenir.

## Kurulum (iOS)

1. Xcode'da yeni bir **iOS App** projesi oluşturun (arayüz: SwiftUI)
2. Projedeki `ContentView.swift` dosyasını [`ios/ContentView.swift`](ios/ContentView.swift) ile değiştirin
3. `@main` App dosyanızın `ContentView()` açtığından emin olun
4. Çalıştırın

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
