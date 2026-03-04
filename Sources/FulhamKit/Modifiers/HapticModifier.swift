import SwiftUI

// MARK: - Environment key

/// The environment key that controls whether FulhamKit components
/// produce haptic feedback.
///
/// Read this key inside any component that triggers haptics:
///
/// ```swift
/// @Environment(\.fkHapticsEnabled) private var hapticsEnabled
///
/// // then guard each haptic call:
/// if hapticsEnabled { FKHaptics.selection() }
/// ```
struct FKHapticsEnabledKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

public extension EnvironmentValues {
    /// When `false`, all FulhamKit components suppress haptic feedback.
    ///
    /// Defaults to `true`. Set to `false` to opt a view hierarchy out
    /// of design-system haptics:
    ///
    /// ```swift
    /// MyView()
    ///     .hapticFeedback(enabled: false)
    /// ```
    var fkHapticsEnabled: Bool {
        get { self[FKHapticsEnabledKey.self] }
        set { self[FKHapticsEnabledKey.self] = newValue }
    }
}

// MARK: - View extension

public extension View {
    /// Controls whether FulhamKit components in this view hierarchy
    /// produce haptic feedback.
    ///
    /// Pass `false` to silence all design-system haptics beneath this
    /// modifier. This does not affect haptics triggered directly by the
    /// consumer — only those baked into FulhamKit components.
    ///
    /// ```swift
    /// FormView()
    ///     .hapticFeedback(enabled: false)
    /// ```
    ///
    /// - Parameter enabled: `true` (default) to allow haptics; `false` to suppress them.
    /// - Returns: A view with the haptic feedback preference applied.
    func hapticFeedback(enabled: Bool) -> some View {
        environment(\.fkHapticsEnabled, enabled)
    }
}
