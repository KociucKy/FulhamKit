import SwiftUI

/// Semantic color tokens for FulhamKit.
///
/// These tokens map to adaptive system colors and provide a consistent
/// card-on-canvas layering model that works in both light and dark mode.
///
/// The background model intentionally inverts system levels to create
/// contrast between page backgrounds and card surfaces:
///
/// | Mode  | Canvas (page)                | Card surface                 |
/// |-------|------------------------------|------------------------------|
/// | Light | `.systemBackground`          | `.secondarySystemBackground` |
/// | Dark  | `.secondarySystemBackground` | `.systemBackground`          |
///
/// ## Usage
///
/// Prefer the static `Color` properties — SwiftUI resolves them adaptively
/// without needing an explicit `ColorScheme`:
///
/// ```swift
/// var body: some View {
///     cardContent
///         .background(FKColor.backgroundPrimary)
/// }
/// ```
///
/// The `(for:)` variants are still available for non-`View` contexts where
/// you already hold a `ColorScheme` value.
public enum FKColor {
    /// The card/surface background — sits on top of `backgroundCanvas`.
    ///
    /// Light: `.secondarySystemBackground` · Dark: `.systemBackground`
    ///
    /// SwiftUI resolves this adaptively; no `ColorScheme` needed.
    public static let backgroundPrimary: Color = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor.systemBackground
            : UIColor.secondarySystemBackground
    })

    /// The page/canvas background — the base layer beneath cards.
    ///
    /// Light: `.systemBackground` · Dark: `.secondarySystemBackground`
    ///
    /// SwiftUI resolves this adaptively; no `ColorScheme` needed.
    public static let backgroundCanvas: Color = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor.secondarySystemBackground
            : UIColor.systemBackground
    })

    // MARK: - ColorScheme overloads (for non-View contexts)

    /// The card/surface background for a given color scheme.
    ///
    /// Prefer ``backgroundPrimary`` in SwiftUI views. Use this overload
    /// when you need to resolve the color outside of a view hierarchy.
    public static func backgroundPrimary(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark: Color(UIColor.systemBackground)
        default:    Color(UIColor.secondarySystemBackground)
        }
    }

    /// The page/canvas background for a given color scheme.
    ///
    /// Prefer ``backgroundCanvas`` in SwiftUI views. Use this overload
    /// when you need to resolve the color outside of a view hierarchy.
    public static func backgroundCanvas(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark: Color(UIColor.secondarySystemBackground)
        default:    Color(UIColor.systemBackground)
        }
    }
}
