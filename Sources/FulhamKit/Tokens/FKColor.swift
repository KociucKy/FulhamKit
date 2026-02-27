import SwiftUI

/// Semantic color tokens for FulhamKit.
///
/// Colors are organised into sub-namespaces by role. Use dot-completion to
/// browse by category:
///
/// ```swift
/// view.background(FKColor.Background.primary)
/// text.foregroundStyle(FKColor.Label.secondary)
/// icon.foregroundStyle(FKColor.Status.error)
/// ```
public enum FKColor {

    // MARK: - Background

    /// Background layer colors for the card-on-canvas elevation model.
    ///
    /// The model intentionally inverts system levels between light and dark
    /// mode to create contrast between page backgrounds and card surfaces:
    ///
    /// | Mode  | Canvas                       | Primary (card)               |
    /// |-------|------------------------------|------------------------------|
    /// | Light | `.systemBackground`          | `.secondarySystemBackground` |
    /// | Dark  | `.secondarySystemBackground` | `.systemBackground`          |
    public enum Background {
        /// The card/surface background — sits on top of ``canvas``.
        ///
        /// Light: `.secondarySystemBackground` · Dark: `.systemBackground`
        ///
        /// SwiftUI resolves this adaptively; no `ColorScheme` needed.
        public static let primary: Color = Color(UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor.systemBackground
                : UIColor.secondarySystemBackground
        })

        /// The page/canvas background — the base layer beneath cards.
        ///
        /// Light: `.systemBackground` · Dark: `.secondarySystemBackground`
        ///
        /// SwiftUI resolves this adaptively; no `ColorScheme` needed.
        public static let canvas: Color = Color(UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor.secondarySystemBackground
                : UIColor.systemBackground
        })

        // MARK: ColorScheme overloads (for non-View contexts)

        /// The card/surface background for a given color scheme.
        ///
        /// Prefer ``primary`` in SwiftUI views. Use this overload when you
        /// need to resolve the color outside of a view hierarchy.
        public static func primary(for colorScheme: ColorScheme) -> Color {
            switch colorScheme {
            case .dark: Color(UIColor.systemBackground)
            default:    Color(UIColor.secondarySystemBackground)
            }
        }

        /// The page/canvas background for a given color scheme.
        ///
        /// Prefer ``canvas`` in SwiftUI views. Use this overload when you
        /// need to resolve the color outside of a view hierarchy.
        public static func canvas(for colorScheme: ColorScheme) -> Color {
            switch colorScheme {
            case .dark: Color(UIColor.secondarySystemBackground)
            default:    Color(UIColor.systemBackground)
            }
        }
    }

    // MARK: - Label

    /// Text and icon foreground colors.
    public enum Label {
        /// Primary text — maps to `UIColor.label`.
        public static let primary: Color = Color(UIColor.label)

        /// Secondary text — maps to `UIColor.secondaryLabel`.
        ///
        /// Use for supporting info, subtitles, and metadata.
        public static let secondary: Color = Color(UIColor.secondaryLabel)

        /// Tertiary text — maps to `UIColor.tertiaryLabel`.
        ///
        /// Use for disabled text, hints, and placeholder-level info.
        public static let tertiary: Color = Color(UIColor.tertiaryLabel)

        /// Placeholder text — maps to `UIColor.placeholderText`.
        public static let placeholder: Color = Color(UIColor.placeholderText)
    }

    // MARK: - Separator

    /// Divider and border colors.
    public enum Separator {
        /// Standard separator — maps to `UIColor.separator` (adaptive).
        public static let `default`: Color = Color(UIColor.separator)

        /// Opaque separator for contexts where transparency is not desired —
        /// maps to `UIColor.opaqueSeparator`.
        public static let opaque: Color = Color(UIColor.opaqueSeparator)
    }

    // MARK: - Interactive

    /// Colors for interactive control states.
    public enum Interactive {
        /// Destructive action color — maps to `UIColor.systemRed`.
        ///
        /// Use for delete buttons, error-state CTAs, and irreversible actions.
        public static let destructive: Color = Color(UIColor.systemRed)

        /// Confirmation / positive action color — maps to `UIColor.systemGreen`.
        ///
        /// Use for confirmation actions and success-state CTAs.
        public static let tinted: Color = Color(UIColor.systemGreen)

        /// Disabled foreground — `UIColor.tertiaryLabel` at reduced prominence.
        ///
        /// Use for disabled controls and inactive text.
        public static let disabled: Color = Color(UIColor.tertiaryLabel)
    }

    // MARK: - Status

    /// Semantic status indicator colors.
    public enum Status {
        /// Success — maps to `UIColor.systemGreen`.
        public static let success: Color = Color(UIColor.systemGreen)

        /// Warning — maps to `UIColor.systemOrange`.
        public static let warning: Color = Color(UIColor.systemOrange)

        /// Error / danger — maps to `UIColor.systemRed`.
        public static let error: Color = Color(UIColor.systemRed)

        /// Informational — maps to `UIColor.systemBlue`.
        public static let info: Color = Color(UIColor.systemBlue)
    }
}
