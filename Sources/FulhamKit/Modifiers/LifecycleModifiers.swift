import SwiftUI

// MARK: - First Appear Modifier

/// Fires a synchronous closure exactly once — on the first `onAppear` only.
///
/// Subsequent appearances (e.g. after navigating away and back) are ignored.
/// Backed by a `@State` flag that persists for the lifetime of the view.
///
/// ```swift
/// MyView()
///     .onFirstAppear {
///         viewModel.loadInitialData()
///     }
/// ```
public struct FirstAppearModifier: ViewModifier {
    @State private var hasAppeared = false
    private let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true
                action()
            }
    }
}

// MARK: - First Task Modifier

/// Fires an async closure exactly once — on the first `task` only.
///
/// Subsequent appearances (e.g. after navigating away and back) are ignored.
/// Backed by a `@State` flag that persists for the lifetime of the view.
///
/// > Important: `hasRun` is set to `true` before `action()` completes. If the
/// > view disappears while the task is still running (cancelling it), the task
/// > will **not** re-run on the next appearance. This is intentional — the
/// > modifier provides a "fire at most once" guarantee, not a "fire until
/// > success" guarantee. Use `onFirstAppear` with explicit retry logic if
/// > re-running a cancelled task is required.
///
/// ```swift
/// MyView()
///     .onFirstTask {
///         await viewModel.fetchRemoteData()
///     }
/// ```
public struct FirstTaskModifier: ViewModifier {
    @State private var hasRun = false
    private let action: () async -> Void

    public init(action: @escaping () async -> Void) {
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .task {
                guard !hasRun else { return }
                hasRun = true
                await action()
            }
    }
}

// MARK: - View extensions

public extension View {
    /// Fires a closure exactly once, on the first appearance of this view.
    ///
    /// See ``FirstAppearModifier`` for full documentation.
    ///
    /// ```swift
    /// MyView()
    ///     .onFirstAppear {
    ///         viewModel.loadInitialData()
    ///     }
    /// ```
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(FirstAppearModifier(action: action))
    }

    /// Fires an async closure exactly once, on the first `task` of this view.
    ///
    /// See ``FirstTaskModifier`` for full documentation.
    ///
    /// ```swift
    /// MyView()
    ///     .onFirstTask {
    ///         await viewModel.fetchRemoteData()
    ///     }
    /// ```
    func onFirstTask(perform action: @escaping () async -> Void) -> some View {
        modifier(FirstTaskModifier(action: action))
    }
}
