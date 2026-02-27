import SwiftUI

/// A tag cell displaying a coloured icon badge above a label.
///
/// The badge color is resolved from a hex string. If the hex string is
/// invalid, the badge falls back to the accent color at 50% opacity.
///
/// ```swift
/// TagCellView(name: "Weekly", icon: "calendar", hexColor: "#5174F8")
/// TagCellView(name: "Morning", icon: "sunrise.fill", hexColor: "#EF7B98")
/// ```
public struct FKTagCellView: View {
    let name: String
    let icon: String
    let hexColor: String

    /// Creates a tag cell.
    ///
    /// - Parameters:
    ///   - name: The label shown below the badge.
    ///   - icon: An SF Symbol name displayed inside the badge.
    ///   - hexColor: A hex string (e.g. `"#EF7B98"`) for the badge background.
    ///     Falls back to `.accentColor.opacity(0.5)` if the string is invalid.
    public init(name: String, icon: String, hexColor: String) {
        self.name = name
        self.icon = icon
        self.hexColor = hexColor
    }

    private var badgeColor: Color {
        Color(hex: hexColor) ?? Color.accentColor.opacity(0.5)
    }

    public var body: some View {
        VStack(spacing: FKSpacing.small) {
            RoundedRectangle(cornerRadius: FKRadius.medium)
                .fill(badgeColor)
                .overlay(alignment: .center) {
                    Image(systemName: icon)
                        .foregroundStyle(.white)
                        .imageScale(.large)
                        .font(FKTypography.ctaLabel)
                }
                .frame(width: 50, height: 50)

            Text(name)
                .font(FKTypography.secondaryLabel)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    HStack(spacing: FKSpacing.extraLarge) {
        FKTagCellView(name: "Weekly", icon: "calendar", hexColor: "#5174F8")
        FKTagCellView(name: "Morning", icon: "sunrise.fill", hexColor: "#EF7B98")
        FKTagCellView(name: "Invalid", icon: "questionmark", hexColor: "not-a-hex")
    }
    .padding()
}
