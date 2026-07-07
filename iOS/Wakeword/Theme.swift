import SwiftUI

/// Bespoke palette + type for Wakeword - Morning Affirmation Log.
enum Theme {
    static let background = Color(hex: "#1C130A")
    static let primary = Color(hex: "#7A4E2D")
    static let secondary = Color(hex: "#B98A5E")
    static let accent = Color(hex: "#E8B04B")
    static let cardBackground = Color(hex: "#1C130A").opacity(0.6)

    static let titleFont = Font.custom("Baskerville", size: 28).weight(.bold)
    static let headlineFont = Font.custom("Baskerville", size: 18).weight(.semibold)
    static let bodyFont = Font.custom("Baskerville", size: 16)
    static let captionFont = Font.custom("Baskerville", size: 13)
}

extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
