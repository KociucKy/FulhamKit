import SwiftUI

/// A full-screen (or container-filling) empty state built on `ContentUnavailableView`.
///
/// Wraps the system `ContentUnavailableView` to provide a consistent empty-state
/// appearance while staying in sync with platform conventions.
///
/// ```swift
/// // Icon + title only
/// FKEmptyStateView(
///     icon: "tray",
///     title: "No Routines Yet"
/// )
///
/// // Full variant with message and CTA
/// FKEmptyStateView(
///     icon: "figure.run",
///     title: "No Workouts",
///     message: "Add your first workout to get started.",
///     action: ("Create Workout", { showSheet = true })
/// )
/// ```
public struct FKEmptyStateView: View {
    private let icon: String
    private let title: String
    private let message: String?
    private let action: (label: String, handler: () -> Void)?

    /// Creates an empty state view.
    ///
    /// - Parameters:
    ///   - icon: An SF Symbol name for the illustration icon.
    ///   - title: The primary empty-state headline.
    ///   - message: Optional supporting body text.
    ///   - action: An optional tuple of a button label and its tap handler.
    public init(
        icon: String,
        title: String,
        message: String? = nil,
        action: (label: String, handler: () -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.action = action
    }

    public var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: icon)
        } description: {
            if let message {
                Text(message)
            }
        } actions: {
            if let action {
                Button(action.label, action: action.handler)
                    .callToActionButton()
                    .frame(maxWidth: 280)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TabView {
        FKEmptyStateView(
            icon: "tray",
            title: "No Routines Yet"
        )
        .tabItem { Label("Minimal", systemImage: "tray") }

        FKEmptyStateView(
            icon: "figure.run",
            title: "No Workouts",
            message: "You haven't logged any workouts yet. Add your first one to get started."
        )
        .tabItem { Label("With message", systemImage: "figure.run") }

        FKEmptyStateView(
            icon: "bell.slash",
            title: "No Notifications",
            message: "You're all caught up! Check back later for updates.",
            action: ("Enable Notifications", { })
        )
        .tabItem { Label("With CTA", systemImage: "bell.slash") }
    }
    .background(FKColor.Background.canvas)
}
