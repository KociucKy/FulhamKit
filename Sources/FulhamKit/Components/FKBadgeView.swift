import SwiftUI

/// A small pill-shaped badge for displaying counts, labels, or status.
///
/// Badges auto-size to their content and cap numeric values at a configurable
/// maximum (e.g. `99+`).
///
/// ```swift
/// // Numeric count badge
/// FKBadgeView(count: unreadCount)
///
/// // Capped badge
/// FKBadgeView(count: 120, max: 99)
///
/// // Label badge with custom color
/// FKBadgeView(label: "NEW", color: FKColor.Status.success)
///
/// // Attached to another view via modifier
/// Image(systemName: "bell")
///     .badged(count: notificationCount)
/// ```
public struct FKBadgeView: View {
    private let label: String
    private let color: Color

    // MARK: - Init overloads

    /// Creates a badge with a plain text label.
    ///
    /// - Parameters:
    ///   - label: The text to display.
    ///   - color: Background color. Defaults to `.accentColor`.
    public init(label: String, color: Color = .accentColor) {
        self.label = label
        self.color = color
    }

    /// Creates a numeric count badge.
    ///
    /// - Parameters:
    ///   - count: The value to display.
    ///   - max: Values above this are shown as `"{max}+"`. Defaults to `99`.
    ///   - color: Background color. Defaults to `.accentColor`.
    public init(count: Int, max: Int = 99, color: Color = .accentColor) {
        self.label = count > max ? "\(max)+" : "\(count)"
        self.color = color
    }

    public var body: some View {
        Text(label)
            .font(FKTypography.footnoteEmphasis)
            .foregroundStyle(.white)
            .padding(.horizontal, FKSpacing.default)
            .padding(.vertical, FKSpacing.extraSmall)
            .background(color)
            .clipShape(.capsule)
    }
}

// MARK: - View modifier

public extension View {
    /// Overlays a numeric count badge in the top-trailing corner.
    ///
    /// The badge is hidden when `count` is zero.
    ///
    /// ```swift
    /// Image(systemName: "envelope")
    ///     .badged(count: unreadCount)
    /// ```
    func badged(count: Int, max: Int = 99, color: Color = .accentColor) -> some View {
        self.overlay(alignment: .topTrailing) {
            if count > 0 {
                FKBadgeView(count: count, max: max, color: color)
                    .offset(x: FKSpacing.medium, y: -FKSpacing.medium)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: FKSpacing.extraLarge) {
        // Label badges
        HStack(spacing: FKSpacing.medium) {
            FKBadgeView(label: "NEW")
            FKBadgeView(label: "PRO", color: FKColor.Status.warning)
            FKBadgeView(label: "SALE", color: FKColor.Status.error)
            FKBadgeView(label: "BETA", color: FKColor.Interactive.tinted)
        }

        // Count badges
        HStack(spacing: FKSpacing.medium) {
            FKBadgeView(count: 1)
            FKBadgeView(count: 9)
            FKBadgeView(count: 42)
            FKBadgeView(count: 120)        // capped at 99+
            FKBadgeView(count: 5, max: 4) // capped at 4+
        }

        // Attached to icons
        HStack(spacing: FKSpacing.extraLarge) {
            Image(systemName: "bell.fill")
                .font(.title)
                .foregroundStyle(FKColor.Label.secondary)
                .badged(count: 3)

            Image(systemName: "envelope.fill")
                .font(.title)
                .foregroundStyle(FKColor.Label.secondary)
                .badged(count: 120)

            Image(systemName: "cart.fill")
                .font(.title)
                .foregroundStyle(FKColor.Label.secondary)
                .badged(count: 0) // hidden when zero
        }
        .padding(.top, FKSpacing.medium)
    }
    .padding(FKSpacing.extraLarge)
    .background(FKColor.Background.canvas)
}
