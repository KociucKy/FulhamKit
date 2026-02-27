import SwiftUI

/// Spacing scale for FulhamKit.
///
/// Use these values for padding, spacing between elements, and layout gaps
/// rather than hardcoding numeric literals.
///
/// ```swift
/// .padding(FKSpacing.lg)
/// VStack(spacing: FKSpacing.sm) { ... }
/// ```
public enum FKSpacing {
    /// 4pt — tight gaps between closely related elements (e.g. icon + label)
    public static let extraSmall: CGFloat = 4
    /// 6pt — small gaps (e.g. icon + text in info labels)
    public static let small: CGFloat = 6
    /// 8pt — standard component internal spacing
    public static let `default`: CGFloat = 8
    /// 12pt — card internal padding (compact)
    public static let medium: CGFloat = 12
    /// 16pt — card internal padding (standard), section padding
    public static let large: CGFloat = 16
    /// 20pt — wider gaps between sibling components
    public static let extraLarge: CGFloat = 20
}
