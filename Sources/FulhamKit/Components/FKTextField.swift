import SwiftUI

// MARK: - State

/// The validation state of an ``FKTextField``.
public enum FKTextFieldState: Equatable {
    /// No validation feedback — the default state.
    case `default`
    /// The field value is valid.
    case success
    /// A warning that does not block submission.
    case warning(message: String)
    /// The field value is invalid and blocks submission.
    case error(message: String)

    var borderColor: Color {
        switch self {
        case .default:          FKBorder.color
        case .success:          FKColor.Status.success
        case .warning:          FKColor.Status.warning
        case .error:            FKColor.Status.error
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .default:          FKBorder.thin
        case .success, .warning, .error: FKBorder.medium
        }
    }

    var feedbackMessage: String? {
        switch self {
        case .warning(let msg), .error(let msg): msg
        default: nil
        }
    }

    var feedbackColor: Color {
        switch self {
        case .warning: FKColor.Status.warning
        case .error:   FKColor.Status.error
        default:       FKColor.Label.secondary
        }
    }

    var feedbackIcon: String? {
        switch self {
        case .success:  "checkmark.circle.fill"
        case .warning:  "exclamationmark.triangle.fill"
        case .error:    "xmark.circle.fill"
        default:        nil
        }
    }
}

// MARK: - Component

/// A styled text field that follows the FulhamKit design system.
///
/// Supports an optional label, placeholder, leading icon, trailing accessory,
/// secure entry, and validation state feedback.
///
/// ```swift
/// @State private var email = ""
/// @State private var fieldState = FKTextFieldState.default
///
/// FKTextField("Email", text: $email, state: $fieldState)
///     .keyboardType(.emailAddress)
///     .textContentType(.emailAddress)
///
/// // With a leading icon
/// FKTextField("Password", text: $password, isSecure: true, icon: "lock")
///
/// // Error state
/// FKTextField("Username", text: $username, state: .constant(.error(message: "Already taken")))
/// ```
public struct FKTextField: View {

    // MARK: Configuration

    private let label: String?
    private let placeholder: String
    private let icon: String?
    private let isSecure: Bool
    private let axis: Axis

    @Binding private var text: String
    @Binding private var state: FKTextFieldState

    // MARK: Internal state

    @FocusState private var isFocused: Bool
    @State private var isRevealed: Bool = false
    @Namespace private var accessibilityNamespace

    // MARK: Init

    /// Creates a styled text field.
    ///
    /// - Parameters:
    ///   - label: Optional label displayed above the field.
    ///   - placeholder: Placeholder shown when the field is empty.
    ///   - text: Binding to the field's string value.
    ///   - state: Binding to the current validation state. Defaults to `.default`.
    ///   - icon: Optional SF Symbol name shown as a leading icon inside the field.
    ///   - isSecure: When `true` the field obscures the text (like a password field).
    ///     A reveal toggle button is appended automatically. Defaults to `false`.
    ///   - axis: The axis along which the field expands. Defaults to `.horizontal`.
    public init(
        _ label: String? = nil,
        placeholder: String = "",
        text: Binding<String>,
        state: Binding<FKTextFieldState> = .constant(.default),
        icon: String? = nil,
        isSecure: Bool = false,
        axis: Axis = .horizontal
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self._state = state
        self.icon = icon
        self.isSecure = isSecure
        self.axis = axis
    }

    // MARK: Body

    public var body: some View {
        VStack(alignment: .leading, spacing: FKSpacing.extraSmall) {
            if let label {
                Text(label)
                    .font(FKTypography.footnoteEmphasis)
                    .foregroundStyle(FKColor.Label.secondary)
                    .accessibilityLabeledPair(role: .label, id: "field", in: accessibilityNamespace)
            }

            fieldBody
                .accessibilityLabeledPair(role: .content, id: "field", in: accessibilityNamespace)

            if let message = state.feedbackMessage {
                feedbackLabel(message)
            }
        }
    }

    // MARK: - Field body

    @ViewBuilder
    private var fieldBody: some View {
        HStack(spacing: FKSpacing.default) {
            if let icon {
                Image(systemName: icon)
                    .foregroundStyle(iconColor)
                    .font(FKTypography.body)
                    .frame(width: 20)
                    .accessibilityHidden(true)
            }

            inputField
                .font(FKTypography.body)
                .foregroundStyle(FKColor.Label.primary)
                .tint(FKColor.Status.info)
                .focused($isFocused)

            // Trailing accessory
            if isSecure {
                revealButton
            } else if state == .success {
                successIcon
            } else if !text.isEmpty {
                clearButton
            }
        }
        .padding(.horizontal, FKSpacing.large)
        .padding(.vertical, FKSpacing.medium)
        .background(FKColor.Background.primary)
        .clipShape(.rect(cornerRadius: FKRadius.small))
        .overlay(
            RoundedRectangle(cornerRadius: FKRadius.small)
                .strokeBorder(borderColor, lineWidth: state.borderWidth)
        )
        .animation(FKAnimation.interactive, value: state)
        .animation(FKAnimation.interactive, value: isFocused)
    }

    // MARK: - Input field variants

    @ViewBuilder
    private var inputField: some View {
        if isSecure && !isRevealed {
            SecureField(placeholder, text: $text)
        } else {
            TextField(placeholder, text: $text, axis: axis)
        }
    }

    // MARK: - Trailing accessories

    private var revealButton: some View {
        Button {
            isRevealed.toggle()
        } label: {
            Image(systemName: isRevealed ? "eye.slash" : "eye")
                .foregroundStyle(FKColor.Label.tertiary)
                .font(FKTypography.body)
                .frame(width: 20)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isRevealed ? "Hide password" : "Show password")
    }

    private var clearButton: some View {
        Button {
            text = ""
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(FKColor.Label.tertiary)
                .font(FKTypography.body)
                .frame(width: 20)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Clear text")
    }

    private var successIcon: some View {
        Image(systemName: "checkmark.circle.fill")
            .foregroundStyle(FKColor.Status.success)
            .font(FKTypography.body)
            .frame(width: 20)
            .accessibilityHidden(true)
    }

    // MARK: - Feedback label

    private func feedbackLabel(_ message: String) -> some View {
        HStack(spacing: FKSpacing.extraSmall) {
            if let icon = state.feedbackIcon {
                Image(systemName: icon)
                    .font(.caption2)
                    .accessibilityHidden(true)
            }
            Text(message)
                .font(FKTypography.caption)
        }
        .foregroundStyle(state.feedbackColor)
        .transition(.opacity.combined(with: .move(edge: .top)))
        .animation(FKAnimation.interactive, value: state)
    }

    // MARK: - Helpers

    private var borderColor: Color {
        if isFocused && state == .default {
            return FKColor.Status.info
        }
        return state.borderColor
    }

    private var iconColor: Color {
        if isFocused { return FKColor.Status.info }
        return FKColor.Label.tertiary
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var email = ""
    @Previewable @State var password = ""
    @Previewable @State var username = ""
    @Previewable @State var notes = ""
    @Previewable @State var emailState: FKTextFieldState = .default
    @Previewable @State var usernameState: FKTextFieldState = .error(message: "Username already taken")
    @Previewable @State var passwordState: FKTextFieldState = .success

    ScrollView {
        VStack(spacing: FKSpacing.large) {

            // Default with label and icon
            FKTextField(
                "Email Address",
                placeholder: "you@example.com",
                text: $email,
                state: $emailState,
                icon: "envelope"
            )
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .autocorrectionDisabled()

            // Success state
            FKTextField(
                "Password",
                placeholder: "At least 8 characters",
                text: $password,
                state: $passwordState,
                icon: "lock",
                isSecure: true
            )

            // Error state
            FKTextField(
                "Username",
                placeholder: "Choose a username",
                text: $username,
                state: $usernameState,
                icon: "person"
            )

            // Multi-line (no label, no icon)
            FKTextField(
                placeholder: "Add a note…",
                text: $notes,
                axis: .vertical
            )
            .lineLimit(3, reservesSpace: true)

            // Disabled appearance demo
            FKTextField(
                "Read-only field",
                placeholder: "",
                text: .constant("Cannot edit this"),
                icon: "lock.shield"
            )
            .disabled(true)
            .opacity(0.5)
        }
        .padding(FKSpacing.large)
    }
    .background(FKColor.Background.canvas)
    .ignoresSafeArea(edges: .bottom)
}
