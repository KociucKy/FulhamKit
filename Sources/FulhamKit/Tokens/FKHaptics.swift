import UIKit

/// Haptic feedback tokens for FulhamKit.
///
/// Provides a unified, accessibility-aware interface for all haptic feedback
/// in the design system. All methods respect the system's Reduce Motion
/// setting — when the user has enabled Reduce Motion, haptics are suppressed.
///
/// Use the static methods directly at interaction sites:
///
/// ```swift
/// Button("Save") {
///     FKHaptics.impact(.medium)
///     save()
/// }
///
/// .onChange(of: state) {
///     if state == .error { FKHaptics.notification(.error) }
/// }
/// ```
///
/// To opt a view hierarchy out of haptics, apply the ``SwiftUI/View/hapticFeedback(enabled:)``
/// modifier:
///
/// ```swift
/// MyView()
///     .hapticFeedback(enabled: false)
/// ```
public enum FKHaptics {

    // MARK: - Impact

    /// Triggers a physical impact haptic at the specified intensity.
    ///
    /// Use for direct-manipulation events — button presses, drag completions,
    /// or selection changes.
    ///
    /// - Parameter style: The impact intensity. Use `.light` for minor
    ///   interactions, `.medium` for confirmations, and `.heavy` for
    ///   destructive or significant actions.
    ///
    /// ```swift
    /// FKHaptics.impact(.medium)
    /// ```
    @MainActor
    public static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard !UIAccessibility.isReduceMotionEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    // MARK: - Notification

    /// Triggers a notification haptic communicating the outcome of an operation.
    ///
    /// Use to reinforce success, warning, or error states — typically in
    /// response to a form submission, validation result, or system event.
    ///
    /// - Parameter type: The feedback type: `.success`, `.warning`, or `.error`.
    ///
    /// ```swift
    /// FKHaptics.notification(.success)
    /// FKHaptics.notification(.error)
    /// ```
    @MainActor
    public static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard !UIAccessibility.isReduceMotionEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }

    // MARK: - Selection

    /// Triggers a light selection-change haptic.
    ///
    /// Use for low-weight interactions such as navigating between items,
    /// changing a page indicator, or toggling a secondary control.
    ///
    /// ```swift
    /// FKHaptics.selection()
    /// ```
    @MainActor
    public static func selection() {
        guard !UIAccessibility.isReduceMotionEnabled else { return }
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
