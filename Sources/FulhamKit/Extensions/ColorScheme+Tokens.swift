import SwiftUI

public extension ColorScheme {
    /// The card/surface background for this color scheme.
    ///
    /// A convenience wrapper around `FKColor.Background.primary(for:)`.
    ///
    /// > Tip: In SwiftUI views, prefer `FKColor.Background.primary` directly —
    /// > it resolves adaptively without needing a `ColorScheme` in scope.
    ///
    /// Use this when you already hold a `ColorScheme` value in a non-`View` context.
    var backgroundPrimary: Color {
        FKColor.Background.primary(for: self)
    }

    /// The page/canvas background for this color scheme.
    ///
    /// A convenience wrapper around `FKColor.Background.canvas(for:)`.
    ///
    /// > Tip: In SwiftUI views, prefer `FKColor.Background.canvas` directly —
    /// > it resolves adaptively without needing a `ColorScheme` in scope.
    ///
    /// Use this when you already hold a `ColorScheme` value in a non-`View` context.
    var backgroundCanvas: Color {
        FKColor.Background.canvas(for: self)
    }
}
