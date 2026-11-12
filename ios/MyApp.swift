import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            Kok()
        }
    }
}

/// Dil seçimini izleyen kök görünüm: seçim değişince tüm ağaç yenilenir.
private struct Kok: View {
    @ObservedObject private var dil = Yerellestirme.paylasilan

    var body: some View {
        ContentView()
            .environmentObject(dil)
            .environment(\.locale, dil.locale)
    }
}
