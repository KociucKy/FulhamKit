import SwiftUI

/// Shadow / elevation tokens for FulhamKit.
///
/// Each token bundles the color, radius, and offset needed for a consistent
/// shadow at a given elevation level. Apply them via the `fkShadow(_:)`
/// modifier rather than using `.shadow()` directly.
///
/// ```swift
/// CardView()
///     .fkShadow(.low)
///
/// ModalView()
///     .fkShadow(.high)
/// ```
public struct FKShadow: Sendable {
    /// The shadow color.
    public let color: Color
    /// The blur radius of the shadow.
    public let radius: CGFloat
    /// The horizontal offset.
    public let x: CGFloat
    /// The vertical offset.
    public let y: CGFloat

    // MARK: - Elevation levels

    /// Subtle shadow for resting cards and list rows.
    ///
    /// `radius: 4, y: 2`
    public static let low = FKShadow(
        color: .black.opacity(0.08),
        radius: 4,
        x: 0,
        y: 2
    )

    /// Medium shadow for interactive cards and raised surfaces.
    ///
    /// `radius: 8, y: 4`
    public static let medium = FKShadow(
        color: .black.opacity(0.10),
        radius: 8,
        x: 0,
        y: 4
    )

    /// Strong shadow for modals, sheets, and popovers.
    ///
    /// `radius: 16, y: 8`
    public static let high = FKShadow(
        color: .black.opacity(0.14),
        radius: 16,
        x: 0,
        y: 8
    )

    /// Very prominent shadow for floating action buttons or drag-preview
    /// elements lifted above the rest of the UI.
    ///
    /// `radius: 24, y: 12`
    public static let lifted = FKShadow(
        color: .black.opacity(0.18),
        radius: 24,
        x: 0,
        y: 12
    )
}

// MARK: - View modifier

public extension View {
    /// Applies an ``FKShadow`` elevation token as a drop shadow.
    ///
    /// ```swift
    /// RoundedRectangle(cornerRadius: FKRadius.medium)
    ///     .fkShadow(.medium)
    /// ```
    func fkShadow(_ shadow: FKShadow) -> some View {
        self.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
}
