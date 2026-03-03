import SwiftUI

// MARK: - Binding extension

/// Box that opts a non-Sendable value into Sendable checking.
///
/// `Binding<T?>` is not `Sendable`, but SwiftUI guarantees the setter closure
/// is always called on the main actor. This wrapper silences the Swift 6
/// strict-concurrency warning without changing runtime behaviour.
private struct _UncheckedSendableBox<Wrapped>: @unchecked Sendable {
    var value: Wrapped
}

public extension Binding where Value == Bool {
    /// Creates a `Binding<Bool>` driven by an optional `Binding<T?>`.
    ///
    /// - Reading: returns `true` when the underlying optional is non-nil, `false` when nil.
    /// - Writing `false`: sets the underlying optional back to `nil`, dismissing the presentation.
    /// - Writing `true`: has no effect — set the optional directly to present it.
    ///
    /// > Important: Writing `true` is intentionally a no-op. In debug builds an
    /// > `assertionFailure` is raised if the caller writes `true`, since this
    /// > binding is read-only in that direction. To present, assign a non-nil
    /// > value to the underlying optional instead.
    ///
    /// This is the standard way to drive `.sheet(isPresented:)`, `.alert(isPresented:)`, or
    /// any other `Binding<Bool>`-based API from optional state without introducing a separate
    /// Boolean flag.
    ///
    /// ```swift
    /// @State private var selectedPlayer: Player?
    ///
    /// // Present a sheet while selectedPlayer is non-nil;
    /// // setting isPresented to false clears selectedPlayer automatically.
    /// .sheet(isPresented: Binding(ifNotNil: $selectedPlayer)) {
    ///     if let player = selectedPlayer {
    ///         PlayerDetailView(player: player)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter binding: A `Binding` wrapping an optional value.
    init<T>(ifNotNil binding: Binding<T?>) {
        let box = _UncheckedSendableBox(value: binding)
        self.init(
            get: { box.value.wrappedValue != nil },
            set: { isPresented in
                if isPresented {
                    assertionFailure(
                        "Binding(ifNotNil:) is read-only in the true direction. " +
                        "Assign a non-nil value to the underlying optional to present."
                    )
                    return
                }
                box.value.wrappedValue = nil
            }
        )
    }
}
