import SwiftUI

/// A section header with a title and an optional trailing chevron.
///
/// When `action` is provided, the entire header becomes tappable and
/// a `chevron.right` icon appears to signal navigability.
///
/// ```swift
/// // Non-tappable header
/// SectionHeaderView(title: "Tags")
///
/// // Tappable header with chevron
/// SectionHeaderView(title: "Routines") {
///     navigateToRoutines()
/// }
/// ```
public struct FKSectionHeaderView: View {
    var title: String
    var action: (() -> Void)?

    /// Creates a section header.
    ///
    /// - Parameters:
    ///   - title: The header text.
    ///   - action: An optional tap handler. When provided, a chevron is shown
    ///     and the header becomes a button.
    public init(title: String, action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        let label = HStack {
            Text(title)
                .foregroundStyle(.primary)
                .font(FKTypography.sectionHeader)

            if action != nil {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .font(FKTypography.sectionHeaderEmphasis)
                    .accessibilityHidden(true)
            }

            Spacer()
        }

        if let action {
            Button(action: action) { label }
                .buttonStyle(.fkFade)
                .accessibilityHint("Show all")
        } else {
            label
                .accessibilityAddTraits(.isHeader)
        }
    }
}

#Preview {
    VStack(spacing: FKSpacing.large) {
        FKSectionHeaderView(title: "Tags")
        FKSectionHeaderView(title: "Routines") { }
    }
    .padding()
}
