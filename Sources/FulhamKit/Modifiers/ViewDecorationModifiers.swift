import SwiftUI

// MARK: - View extensions

public extension View {
    /// Makes the entire frame of a view hittable, including empty space.
    ///
    /// Adds a clear `Color` background with a `Rectangle` content shape so
    /// that `.onTapGesture` (and other gesture recognisers) fire in the gaps
    /// between subviews — not just over the rendered content.
    ///
    /// This is the standard fix for tap gestures that fail to trigger in the
    /// empty areas of a `VStack`, `HStack`, or other layout container.
    ///
    /// ```swift
    /// VStack(spacing: FKSpacing.medium) {
    ///     Image(systemName: "figure.soccer")
    ///     Text("Kick-off")
    /// }
    /// .tappableBackground()
    /// .onTapGesture { selectItem() }
    /// ```
    func tappableBackground() -> some View {
        background(Color.clear.contentShape(Rectangle()))
    }

    /// Overlays a vertical gradient behind content to improve text legibility over image backgrounds.
    ///
    /// Applies a `LinearGradient` from transparent at the top to `black` at
    /// the specified `scrimOpacity` at the bottom. Use this when laying text over
    /// a photo or hero image where contrast is otherwise unreliable.
    ///
    /// ```swift
    /// Image("match-hero")
    ///     .overlay(alignment: .bottom) {
    ///         VStack {
    ///             Text("Fulham vs Arsenal")
    ///                 .font(FKTypography.cardTitle)
    ///             Text("Saturday, 15:00").font(FKTypography.caption)
    ///         }
    ///         .padding(FKSpacing.large)
    ///         .imageScrimBackground()
    ///     }
    /// ```
    ///
    /// - Parameter scrimOpacity: The opacity of black at the bottom of the gradient. Defaults to `0.4`.
    func imageScrimBackground(scrimOpacity: Double = 0.4) -> some View {
        background(
            LinearGradient(
                colors: [.clear, .black.opacity(scrimOpacity)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    /// Wraps the view in a compact, pill-shaped badge with the given background colour.
    ///
    /// Applies `FKSpacing.default` horizontal padding and `FKSpacing.extraSmall`
    /// vertical padding, then clips to a `Capsule`. Pair with a small
    /// `Text` or `Label` for status chips, category tags, and inline labels.
    ///
    /// ```swift
    /// Text("Live")
    ///     .font(FKTypography.footnoteEmphasis)
    ///     .foregroundStyle(.white)
    ///     .badgeStyle(backgroundColor: FKColor.Status.error)
    ///
    /// Text("New")
    ///     .font(FKTypography.caption)
    ///     .badgeStyle(backgroundColor: FKColor.Interactive.tinted.opacity(0.15))
    /// ```
    ///
    /// - Parameter backgroundColor: The fill colour of the badge capsule.
    func badgeStyle(backgroundColor: Color) -> some View {
        padding(.horizontal, FKSpacing.default)
            .padding(.vertical, FKSpacing.extraSmall)
            .background(backgroundColor)
            .clipShape(Capsule())
    }
}
