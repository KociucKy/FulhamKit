import SwiftUI

// MARK: - Button Styles

/// Scales the button down to 95% on press with a smooth spring animation.
///
/// Produces a light impact haptic on press. Haptics can be suppressed by
/// applying ``SwiftUI/View/hapticFeedback(enabled:)`` on a parent view.
///
/// ```swift
/// Button("Start") { startRoutine() }
///     .buttonStyle(.fkPressable)
/// ```
public struct FKPressableButtonStyle: ButtonStyle {
    @Environment(\.fkHapticsEnabled) private var hapticsEnabled

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(FKAnimation.interactive, value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, isPressed in
                guard isPressed, hapticsEnabled else { return }
                FKHaptics.impact(.light)
            }
    }
}

/// Overlays the accent color at 40% opacity on press.
///
/// Works best on views with a defined background — the overlay
/// tints the entire button surface.
///
/// ```swift
/// Button("Start") { startRoutine() }
///     .buttonStyle(.fkHighlight)
/// ```
public struct FKHighlightButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay {
                Color.accentColor.opacity(configuration.isPressed ? 0.4 : 0)
            }
            .animation(FKAnimation.interactive, value: configuration.isPressed)
    }
}

/// Fades the button to 50% opacity on press.
///
/// A subtle, non-intrusive press effect suitable for text buttons and
/// list rows where a scale or overlay effect would feel heavy.
///
/// ```swift
/// Button("See all") { showAll() }
///     .buttonStyle(.fkFade)
/// ```
public struct FKFadeButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1)
            .animation(FKAnimation.interactive, value: configuration.isPressed)
    }
}

// MARK: - Shorthand extensions

public extension ButtonStyle where Self == FKPressableButtonStyle {
    /// Scales down to 95% on press.
    static var fkPressable: Self { .init() }
}

public extension ButtonStyle where Self == FKHighlightButtonStyle {
    /// Overlays the accent color at 40% opacity on press.
    static var fkHighlight: Self { .init() }
}

public extension ButtonStyle where Self == FKFadeButtonStyle {
    /// Fades to 50% opacity on press.
    static var fkFade: Self { .init() }
}
