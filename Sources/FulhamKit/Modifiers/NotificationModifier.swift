import SwiftUI

// MARK: - Modifier

/// Subscribes to a `NotificationCenter` notification for the lifetime of the view.
///
/// The subscription is established when the view appears and cancelled automatically
/// when the view is removed from the hierarchy. The `action` closure receives the
/// full `Notification` object so callers can inspect `userInfo` if needed.
///
/// ```swift
/// MyView()
///     .onNotificationReceived(.NSManagedObjectContextDidSave) { notification in
///         viewModel.refresh()
///     }
/// ```
public struct NotificationListenerModifier: ViewModifier {
    let name: Notification.Name
    let action: @Sendable (Notification) -> Void

    public init(name: Notification.Name, action: @escaping @Sendable (Notification) -> Void) {
        self.name = name
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: name), perform: action)
    }
}

// MARK: - View extension

public extension View {
    /// Subscribes to a `NotificationCenter` notification for the lifetime of the view.
    ///
    /// See ``NotificationListenerModifier`` for full documentation.
    ///
    /// ```swift
    /// MyView()
    ///     .onNotificationReceived(.NSManagedObjectContextDidSave) { notification in
    ///         viewModel.refresh()
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - name: The `Notification.Name` to observe.
    ///   - action: Closure invoked on the main actor each time the notification fires.
    func onNotificationReceived(
        _ name: Notification.Name,
        action: @escaping @Sendable (Notification) -> Void
    ) -> some View {
        modifier(NotificationListenerModifier(name: name, action: action))
    }
}
