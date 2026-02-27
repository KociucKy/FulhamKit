import SwiftUI

/// A styled container that applies the standard card appearance.
///
/// `FKCardView` handles the background color, corner radius, shadow, and optional
/// border in one composable wrapper — no need to assemble these tokens manually
/// every time.
///
/// ```swift
/// // Default card (medium radius, low shadow)
/// FKCardView {
///     Text("Hello")
///         .padding()
/// }
///
/// // Larger radius, stronger shadow, no border
/// FKCardView(radius: FKRadius.large, shadow: .medium, showBorder: false) {
///     RoutineRow(routine: routine)
/// }
/// ```
public struct FKCardView<Content: View>: View {
    private let radius: CGFloat
    private let shadow: FKShadow?
    private let showBorder: Bool
    @ViewBuilder private let content: () -> Content

    /// Creates a card container.
    ///
    /// - Parameters:
    ///   - radius: Corner radius. Defaults to ``FKRadius/medium``.
    ///   - shadow: Shadow elevation. Pass `nil` for no shadow. Defaults to ``FKShadow/low``.
    ///   - showBorder: Whether to draw a subtle separator border. Defaults to `true`.
    ///   - content: The content to place inside the card.
    public init(
        radius: CGFloat = FKRadius.medium,
        shadow: FKShadow? = .low,
        showBorder: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.radius = radius
        self.shadow = shadow
        self.showBorder = showBorder
        self.content = content
    }

    public var body: some View {
        content()
            .background(FKColor.Background.primary)
            .clipShape(.rect(cornerRadius: radius))
            .overlay {
                if showBorder {
                    RoundedRectangle(cornerRadius: radius)
                        .strokeBorder(FKColor.Separator.default, lineWidth: FKBorder.hairline)
                }
            }
            .shadow(
                color: shadow?.color ?? .clear,
                radius: shadow?.radius ?? 0,
                x: shadow?.x ?? 0,
                y: shadow?.y ?? 0
            )
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: FKSpacing.large) {
            // Default
            FKCardView {
                VStack(alignment: .leading, spacing: FKSpacing.small) {
                    Text("Default Card")
                        .font(FKTypography.cardTitle)
                    Text("radius: medium · shadow: low · border: on")
                        .font(FKTypography.caption)
                        .foregroundStyle(FKColor.Label.secondary)
                }
                .padding(FKSpacing.large)
            }

            // Large radius, medium shadow
            FKCardView(radius: FKRadius.large, shadow: .medium) {
                VStack(alignment: .leading, spacing: FKSpacing.small) {
                    Text("Large Radius")
                        .font(FKTypography.cardTitle)
                    Text("radius: large · shadow: medium · border: on")
                        .font(FKTypography.caption)
                        .foregroundStyle(FKColor.Label.secondary)
                }
                .padding(FKSpacing.large)
            }

            // No shadow, no border
            FKCardView(shadow: nil, showBorder: false) {
                VStack(alignment: .leading, spacing: FKSpacing.small) {
                    Text("Flat Card")
                        .font(FKTypography.cardTitle)
                    Text("radius: medium · shadow: none · border: off")
                        .font(FKTypography.caption)
                        .foregroundStyle(FKColor.Label.secondary)
                }
                .padding(FKSpacing.large)
            }

            // High elevation
            FKCardView(radius: FKRadius.large, shadow: .high, showBorder: false) {
                VStack(alignment: .leading, spacing: FKSpacing.small) {
                    Text("High Elevation")
                        .font(FKTypography.cardTitle)
                    Text("radius: large · shadow: high · border: off")
                        .font(FKTypography.caption)
                        .foregroundStyle(FKColor.Label.secondary)
                }
                .padding(FKSpacing.large)
            }
        }
        .padding(FKSpacing.large)
    }
    .background(FKColor.Background.canvas)
}
