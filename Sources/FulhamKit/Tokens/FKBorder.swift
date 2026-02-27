import SwiftUI

/// Border and stroke tokens for FulhamKit.
///
/// Use these to apply consistent outlines to cards, inputs, and dividers
/// rather than hardcoding line widths or colors.
///
/// ```swift
/// // Stroke a card outline
/// RoundedRectangle(cornerRadius: FKRadius.medium)
///     .strokeBorder(FKBorder.color, lineWidth: FKBorder.thin)
///
/// // Apply via the convenience modifier
/// cardView
///     .fkBorder(cornerRadius: FKRadius.medium)
/// ```
public enum FKBorder {

    // MARK: - Line widths

    /// 0.5pt — hairline separator, table row dividers
    public static let hairline: CGFloat = 0.5
    /// 1pt — standard border for cards, inputs, chips
    public static let thin: CGFloat = 1
    /// 2pt — emphasis border for selected or focused states
    public static let medium: CGFloat = 2
    /// 3pt — strong border for high-visibility indicators
    public static let thick: CGFloat = 3

    // MARK: - Colors

    /// Default border color — maps to `UIColor.separator` (adaptive).
    ///
    /// Use for subtle outlines on cards and containers.
    public static let color: Color = Color(UIColor.separator)

    /// Stronger border color — maps to `UIColor.opaqueSeparator` (adaptive).
    ///
    /// Use when the border needs to be clearly visible against the background.
    public static let colorEmphasis: Color = Color(UIColor.opaqueSeparator)
}

// MARK: - View modifier

public extension View {
    /// Applies a rounded-rect stroke border using FulhamKit border tokens.
    ///
    /// Defaults to ``FKBorder/thin`` width and ``FKBorder/color``.
    ///
    /// ```swift
    /// cardContent
    ///     .fkBorder(cornerRadius: FKRadius.medium)
    ///
    /// // Custom width and color:
    /// inputField
    ///     .fkBorder(cornerRadius: FKRadius.small, lineWidth: FKBorder.medium, color: FKColor.Status.error)
    /// ```
    func fkBorder(
        cornerRadius: CGFloat,
        lineWidth: CGFloat = FKBorder.thin,
        color: Color = FKBorder.color
    ) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(color, lineWidth: lineWidth)
        )
    }
}
