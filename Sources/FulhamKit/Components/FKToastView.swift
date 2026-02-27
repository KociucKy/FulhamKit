import SwiftUI

// MARK: - Toast model

/// The data model for a toast notification.
public struct FKToast: Equatable {
    /// The style controls the icon and accent color of the toast.
    public enum Style: Equatable {
        case info
        case success
        case warning
        case error

        var icon: String {
            switch self {
            case .info:    "info.circle.fill"
            case .success: "checkmark.circle.fill"
            case .warning: "exclamationmark.triangle.fill"
            case .error:   "xmark.circle.fill"
            }
        }

        var color: Color {
            switch self {
            case .info:    FKColor.Status.info
            case .success: FKColor.Status.success
            case .warning: FKColor.Status.warning
            case .error:   FKColor.Status.error
            }
        }
    }

    /// The message text shown in the toast.
    public let message: String
    /// The visual style (icon + accent color).
    public let style: Style
    /// How long (in seconds) the toast stays visible before auto-dismissing.
    public let duration: TimeInterval

    /// Creates a toast.
    ///
    /// - Parameters:
    ///   - message: The message to display.
    ///   - style: The visual style. Defaults to `.info`.
    ///   - duration: Auto-dismiss delay in seconds. Defaults to `3`.
    public init(message: String, style: Style = .info, duration: TimeInterval = 3) {
        self.message = message
        self.style = style
        self.duration = duration
    }
}

// MARK: - Toast view

/// The visual toast pill displayed on screen.
struct ToastView: View {
    let toast: FKToast

    var body: some View {
        HStack(spacing: FKSpacing.default) {
            Image(systemName: toast.style.icon)
                .foregroundStyle(toast.style.color)
                .font(FKTypography.ctaLabel)

            Text(toast.message)
                .font(FKTypography.secondaryLabel)
                .foregroundStyle(FKColor.Label.primary)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
        .padding(.horizontal, FKSpacing.large)
        .padding(.vertical, FKSpacing.medium)
        .background(.regularMaterial)
        .clipShape(.capsule)
        .fkShadow(.medium)
    }
}

// MARK: - View modifier

struct ToastModifier: ViewModifier {
    @Binding var toast: FKToast?

    @State private var isVisible = false
    @State private var dismissTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if let toast, isVisible {
                    ToastView(toast: toast)
                        .padding(.top, FKSpacing.large)
                        .transition(
                            .move(edge: .top)
                            .combined(with: .opacity)
                        )
                }
            }
            .onChange(of: toast) { _, newToast in
                dismissTask?.cancel()
                guard let newToast else {
                    withAnimation(FKAnimation.dismiss) { isVisible = false }
                    return
                }

                withAnimation(FKAnimation.spring) { isVisible = true }
                dismissTask = Task {
                    try? await Task.sleep(for: .seconds(newToast.duration))
                    guard !Task.isCancelled else { return }
                    withAnimation(FKAnimation.dismiss) { isVisible = false }
                    try? await Task.sleep(for: .seconds(0.3))
                    guard !Task.isCancelled else { return }
                    toast = nil
                }
            }
    }
}

public extension View {
    /// Presents a toast notification driven by a binding.
    ///
    /// Set the binding to an ``FKToast`` to show the toast. It auto-dismisses
    /// after `toast.duration` seconds, or set the binding to `nil` to dismiss
    /// it manually.
    ///
    /// ```swift
    /// @State private var toast: FKToast?
    ///
    /// var body: some View {
    ///     ContentView()
    ///         .toast($toast)
    ///         .onAppear {
    ///             toast = FKToast(message: "Saved!", style: .success)
    ///         }
    /// }
    /// ```
    func toast(_ toast: Binding<FKToast?>) -> some View {
        modifier(ToastModifier(toast: toast))
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var toast: FKToast? = nil

    ZStack {
        FKColor.Background.canvas.ignoresSafeArea()

        ScrollView {
            VStack(spacing: FKSpacing.medium) {
                Button("Show Info") {
                    toast = FKToast(message: "Routine saved successfully.", style: .info)
                }
                .callToActionButton()

                Button("Show Success") {
                    toast = FKToast(message: "Workout logged!", style: .success)
                }
                .callToActionButton()

                Button("Show Warning") {
                    toast = FKToast(message: "Your session is about to expire.", style: .warning)
                }
                .callToActionButton()

                Button("Show Error") {
                    toast = FKToast(message: "Failed to sync. Check your connection.", style: .error)
                }
                .callToActionButton()
            }
            .padding(FKSpacing.large)
        }
    }
    .toast($toast)
}
