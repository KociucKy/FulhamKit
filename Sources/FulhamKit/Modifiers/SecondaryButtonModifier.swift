import SwiftUI

// MARK: - View Modifier

/// Styles a view as a full-width secondary (outline) button.
///
/// Applies the standard FulhamKit secondary button appearance:
/// - Accent color border with `FKRadius.medium` corner radius
/// - Text is punched through the background as a transparent cutout,
///   revealing whatever content lies behind the button
/// - `FKTypography.ctaLabel` font
/// - Full width with a fixed height of 55pt
///
/// The knockout effect is achieved by compositing the content label
/// (`foregroundStyle(.white)`) over a solid accent fill and then applying
/// `.blendMode(.destinationOut)` inside an isolated `compositingGroup()`,
/// so the letterforms become transparent windows into the background.
///
/// Typically used on a `Text` or `Label` that is then wrapped in a `Button`.
///
/// ```swift
/// Button { dismiss() } label: {
///     Text("Cancel")
///         .secondaryButton()
/// }
/// ```
public struct SecondaryButtonModifier: ViewModifier {
	public func body(content: Content) -> some View {
		ZStack {
			content
				.font(FKTypography.ctaLabel)
				.foregroundStyle(Color.accentColor)
		}
		.frame(maxWidth: .infinity)
		.frame(height: 55)
		.tappableBackground()
		.overlay {
			RoundedRectangle(cornerRadius: FKRadius.medium)
				.strokeBorder(Color.accentColor, lineWidth: FKBorder.medium)
		}
	}
}

// MARK: - Preview

#Preview {
	VStack(spacing: FKSpacing.large) {
		// Against a plain canvas background
		Button {} label: {
			Text("Cancel")
				.secondaryButton()
		}

		// Paired with a CTA to show the visual relationship
		Button {} label: {
			Text("Start Routine")
				.callToActionButton()
		}

		Button {} label: {
			Text("Maybe Later")
				.secondaryButton()
		}
		.buttonStyle(.fkPressable)
	}
	.padding(FKSpacing.large)
	.background(FKColor.Background.canvas)
}

// MARK: - View extension

public extension View {
	/// Styles the view as a full-width secondary (outline) button with a
	/// transparent text knockout effect.
	///
	/// See ``SecondaryButtonModifier`` for full documentation.
	func secondaryButton() -> some View {
		modifier(SecondaryButtonModifier())
	}
}
