import SwiftUI

// MARK: - View Modifier

/// Styles a view as a full-width call-to-action button.
///
/// Applies the standard FulhamKit CTA appearance:
/// - Accent color background
/// - White foreground
/// - `FKTypography.ctaLabel` font
/// - Full width with `FKRadius.medium` corner radius
/// - Fixed height of 55pt
///
/// Typically used on a `Text` or `Label` that is then wrapped in a `Button`.
///
/// ```swift
/// Button { startRoutine() } label: {
///     Text("Start Routine")
///         .callToActionButton()
/// }
/// ```
struct CTAButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(FKTypography.ctaLabel)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(Color.accentColor)
            .clipShape(.rect(cornerRadius: FKRadius.medium))
    }
}

// MARK: - View extension

public extension View {
    /// Styles the view as a full-width call-to-action button.
    ///
    /// See ``CTAButtonModifier`` for full documentation.
    func callToActionButton() -> some View {
        modifier(CTAButtonModifier())
    }
}
