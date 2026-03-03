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
