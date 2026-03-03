import SwiftUI

// MARK: - View extension

public extension View {
    /// Conditionally applies a view transform when a condition is `true`.
    ///
    /// Avoids `if` / `AnyView` wrapping at call sites and preserves the
    /// concrete `some View` return type via `@ViewBuilder`.
    ///
    /// ```swift
    /// Text("Premium")
    ///     .applyIf(user.isPremium) { label in
    ///         label.bold()
    ///     }
    ///
    /// MyCard()
    ///     .applyIf(isSelected) { card in
    ///         card.fkBorder(cornerRadius: FKRadius.medium, lineWidth: FKBorder.medium)
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - condition: When `true`, `transform` is applied to `self`. When `false`, `self` is returned unchanged.
    ///   - transform: A closure that takes the receiver and returns a transformed view.
    ///
    /// > Warning: When `transform` changes the type of `self` (e.g. by adding a
    /// > modifier that returns a different concrete type), toggling `condition`
    /// > **breaks view identity**. SwiftUI will destroy and recreate the view
    /// > tree, losing any `@State`, focus state, and in-flight animations.
    /// > Prefer using modifier-based approaches (e.g. `.opacity`, `.overlay`)
    /// > that keep the same view type in both branches when view identity must
    /// > be preserved.
    @ViewBuilder
    func applyIf<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
