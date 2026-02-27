import SwiftUI

public extension Color {
    /// Creates a `Color` from a hex string.
    ///
    /// Supports 6-character (`RRGGBB`) and 8-character (`RRGGBBAA`) formats,
    /// with or without a leading `#`.
    ///
    /// ```swift
    /// Color(hex: "#EF7B98")      // opaque pink
    /// Color(hex: "EF7B98")       // same, no hash
    /// Color(hex: "#EF7B98CC")    // pink at ~80% opacity
    /// ```
    ///
    /// Returns `nil` if the string is not a valid 6 or 8 character hex value.
    init?(hex: String) {
        let cleaned = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex

        guard cleaned.count == 6 || cleaned.count == 8 else { return nil }

        var value: UInt64 = 0
        guard Scanner(string: cleaned).scanHexInt64(&value) else { return nil }

        let r, g, b, a: Double
        if cleaned.count == 6 {
            r = Double((value >> 16) & 0xFF) / 255
            g = Double((value >> 8)  & 0xFF) / 255
            b = Double(value         & 0xFF) / 255
            a = 1.0
        } else {
            r = Double((value >> 24) & 0xFF) / 255
            g = Double((value >> 16) & 0xFF) / 255
            b = Double((value >> 8)  & 0xFF) / 255
            a = Double(value         & 0xFF) / 255
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
