import SwiftUI

public extension ColorScheme {
    /// The card/surface background for this color scheme.
    ///
    /// A convenience wrapper around `FKColor.backgroundPrimary(for:)`.
    ///
    /// > Tip: In SwiftUI views, prefer `FKColor.backgroundPrimary` directly —
    /// > it resolves adaptively without needing a `ColorScheme` in scope.
    ///
    /// Use this when you already hold a `ColorScheme` value in a non-`View` context.
    var backgroundPrimary: Color {
        FKColor.backgroundPrimary(for: self)
    }

    /// The page/canvas background for this color scheme.
    ///
    /// A convenience wrapper around `FKColor.backgroundCanvas(for:)`.
    ///
    /// > Tip: In SwiftUI views, prefer `FKColor.backgroundCanvas` directly —
    /// > it resolves adaptively without needing a `ColorScheme` in scope.
    ///
    /// Use this when you already hold a `ColorScheme` value in a non-`View` context.
    var backgroundCanvas: Color {
        FKColor.backgroundCanvas(for: self)
    }
}
