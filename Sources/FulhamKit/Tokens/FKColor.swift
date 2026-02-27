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
/// ```swift
/// @Environment(\.colorScheme) private var colorScheme
///
/// var body: some View {
///     cardContent
///         .background(FKColor.backgroundPrimary(for: colorScheme))
/// }
/// ```
public enum FKColor {
	/// The card/surface background — sits on top of `backgroundCanvas`.
	///
	/// Light: `.secondarySystemBackground` · Dark: `.systemBackground`
	public static func backgroundPrimary(for colorScheme: ColorScheme) -> Color {
		switch colorScheme {
		case .dark:
			Color(UIColor.systemBackground)
		default:
			Color(UIColor.secondarySystemBackground)
		}
	}

	/// The page/canvas background — the base layer beneath cards.
	///
	/// Light: `.systemBackground` · Dark: `.secondarySystemBackground`
	public static func backgroundCanvas(for colorScheme: ColorScheme) -> Color {
		switch colorScheme {
		case .dark:
			Color(UIColor.secondarySystemBackground)
		default:
			Color(UIColor.systemBackground)
		}
	}
}
