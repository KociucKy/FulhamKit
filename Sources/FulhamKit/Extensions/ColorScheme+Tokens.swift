import SwiftUI

public extension ColorScheme {
    /// The card/surface background for this color scheme.
    ///
    /// A convenience wrapper around `FKColor.backgroundPrimary(for:)`.
    /// Use this when you have a `ColorScheme` value already in scope.
    ///
    /// ```swift
    /// @Environment(\.colorScheme) private var colorScheme
    ///
    /// var body: some View {
    ///     content
    ///         .background(colorScheme.backgroundPrimary)
    /// }
    /// ```
    var backgroundPrimary: Color {
        FKColor.backgroundPrimary(for: self)
    }

    /// The page/canvas background for this color scheme.
    ///
    /// A convenience wrapper around `FKColor.backgroundCanvas(for:)`.
    var backgroundCanvas: Color {
        FKColor.backgroundCanvas(for: self)
    }
}
