import SwiftUI

/// A layout that arranges children left-to-right, wrapping to the next row
/// when there is not enough horizontal space.
///
/// `FKFlowLayout` conforms to SwiftUI's `Layout` protocol, so it composes
/// naturally with other layout containers and supports all standard modifiers.
///
/// ```swift
/// // Default spacing
/// FKFlowLayout {
///     ForEach(tags, id: \.self) { tag in
///         FKBadgeView(label: tag)
///     }
/// }
///
/// // Custom spacing
/// FKFlowLayout(horizontalSpacing: FKSpacing.large, verticalSpacing: FKSpacing.medium) {
///     ForEach(tags, id: \.self) { tag in
///         FKBadgeView(label: tag)
///     }
/// }
/// ```
///
/// - Note: All children are laid out eagerly. For very large collections,
///   consider paginating or filtering the data before passing it in.
public struct FKFlowLayout: Layout {

    // MARK: - Configuration

    /// Horizontal gap between items on the same row.
    public var horizontalSpacing: CGFloat

    /// Vertical gap between rows.
    public var verticalSpacing: CGFloat

    // MARK: - Init

    /// Creates a flow layout.
    ///
    /// - Parameters:
    ///   - horizontalSpacing: Gap between items on the same row. Defaults to ``FKSpacing/default``.
    ///   - verticalSpacing: Gap between rows. Defaults to ``FKSpacing/default``.
    public init(
        horizontalSpacing: CGFloat = FKSpacing.default,
        verticalSpacing: CGFloat = FKSpacing.default
    ) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    // MARK: - Layout

    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        let rows = computeRows(subviews: subviews, maxWidth: maxWidth)
        return totalSize(rows: rows)
    }

    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        let maxWidth = bounds.width
        let rows = computeRows(subviews: subviews, maxWidth: maxWidth)

        var y = bounds.minY

        for row in rows {
            let rowHeight = row.map { $0.size.height }.max() ?? 0
            var x = bounds.minX

            for item in row {
                let itemProposal = ProposedViewSize(item.size)
                subviews[item.index].place(
                    at: CGPoint(x: x, y: y),
                    anchor: .topLeading,
                    proposal: itemProposal
                )
                x += item.size.width + horizontalSpacing
            }

            y += rowHeight + verticalSpacing
        }
    }

    // MARK: - Helpers

    private struct RowItem {
        let index: Int
        let size: CGSize
    }

    private func computeRows(subviews: Subviews, maxWidth: CGFloat) -> [[RowItem]] {
        var rows: [[RowItem]] = []
        var currentRow: [RowItem] = []
        var currentRowWidth: CGFloat = 0

        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(.unspecified)
            let requiredWidth = currentRow.isEmpty
                ? size.width
                : currentRowWidth + horizontalSpacing + size.width

            if requiredWidth > maxWidth, !currentRow.isEmpty {
                rows.append(currentRow)
                currentRow = [RowItem(index: index, size: size)]
                currentRowWidth = size.width
            } else {
                currentRow.append(RowItem(index: index, size: size))
                currentRowWidth = requiredWidth
            }
        }

        if !currentRow.isEmpty {
            rows.append(currentRow)
        }

        return rows
    }

    private func totalSize(rows: [[RowItem]]) -> CGSize {
        guard !rows.isEmpty else { return .zero }

        let width = rows.map { row -> CGFloat in
            let itemWidths = row.map(\.size.width).reduce(0, +)
            let gaps = CGFloat(max(row.count - 1, 0)) * horizontalSpacing
            return itemWidths + gaps
        }.max() ?? 0

        let rowHeights = rows.map { $0.map(\.size.height).max() ?? 0 }
        let totalRowHeight = rowHeights.reduce(0, +)
        let totalGapHeight = CGFloat(max(rows.count - 1, 0)) * verticalSpacing
        let height = totalRowHeight + totalGapHeight

        return CGSize(width: width, height: height)
    }
}

// MARK: - Preview

#Preview("Flow Layout — Tags") {
    let tags = [
        "Fulham", "Premier League", "Craven Cottage", "Whites",
        "Championship", "London", "Football", "Season Ticket",
        "Away Days", "Cup Runs", "Promotion", "Relegation",
        "Transfer Window", "Match Day"
    ]

    ScrollView {
        VStack(alignment: .leading, spacing: FKSpacing.large) {
            Text("Default spacing")
                .font(FKTypography.sectionHeader)
                .foregroundStyle(FKColor.Label.primary)

            FKFlowLayout {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(FKTypography.secondaryLabel)
                        .padding(.horizontal, FKSpacing.medium)
                        .padding(.vertical, FKSpacing.small)
                        .background(FKColor.Background.primary)
                        .clipShape(.capsule)
                        .overlay {
                            Capsule()
                                .strokeBorder(FKColor.Separator.default, lineWidth: FKBorder.hairline)
                        }
                }
            }

            Text("Large spacing")
                .font(FKTypography.sectionHeader)
                .foregroundStyle(FKColor.Label.primary)

            FKFlowLayout(
                horizontalSpacing: FKSpacing.large,
                verticalSpacing: FKSpacing.large
            ) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(FKTypography.secondaryLabel)
                        .padding(.horizontal, FKSpacing.medium)
                        .padding(.vertical, FKSpacing.small)
                        .background(FKColor.Status.info.opacity(0.12))
                        .clipShape(.capsule)
                }
            }
        }
        .padding(FKSpacing.large)
    }
    .background(FKColor.Background.canvas)
}
