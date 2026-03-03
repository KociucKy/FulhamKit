import SwiftUI

/// A horizontally paging carousel with dot-based pagination indicators.
///
/// Items snap one-at-a-time and apply a scale transition (0.9×) to
/// off-screen neighbours for depth. A row of dots below the scroll view
/// reflects the current page. VoiceOver users can swipe up/down on the
/// pagination control to move between pages.
///
/// ```swift
/// FKCarouselView(items: routines, height: 120) { routine in
///     RoutineCardView(routine: routine)
/// }
/// ```
///
/// - Note: `Item` must conform to `Identifiable & Hashable`. The `id` is
///   used as a stable scroll identity.
public struct FKCarouselView<Item: Identifiable & Hashable & Sendable, Content: View>: View {
    var items: [Item]
    var height: CGFloat
    @ViewBuilder var content: (Item) -> Content

    @State private var selection: Item.ID?

    /// Creates a carousel.
    ///
    /// - Parameters:
    ///   - items: The data to display.
    ///   - height: The fixed height of the scroll area. Defaults to `100`.
    ///   - content: A view builder that produces a cell for each item.
    public init(
        items: [Item],
        height: CGFloat = 100,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.height = height
        self.content = content
    }

    public var body: some View {
        VStack(spacing: FKSpacing.small) {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(items) { item in
                        content(item)
                            .id(item.id)
                            .scrollTransition(
                                .interactive.threshold(.visible(0.95)),
                                transition: { content, phase in
                                    content.scaleEffect(phase.isIdentity ? 1 : 0.9)
                                }
                            )
                            .containerRelativeFrame(.horizontal, alignment: .center)
                            .accessibilityElement(children: .combine)
                    }
                }
            }
            .frame(height: height)
            .scrollIndicators(.hidden)
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $selection)
            .onAppear(perform: updateSelectionIfNeeded)
            .onChange(of: items.count, updateSelectionIfNeeded)

            paginationControl
        }
    }

    // MARK: - Pagination control

    @ViewBuilder
    private var paginationControl: some View {
        HStack(spacing: FKSpacing.small) {
            ForEach(items) { item in
                Circle()
                    .fill(item.id == selection ? Color.accentColor : Color.secondary.opacity(0.5))
                    .frame(width: FKSpacing.small, height: FKSpacing.small)
                    .accessibilityHidden(true)
            }
        }
        .animation(.linear, value: selection.map { AnyHashable($0) })
        .accessibilityElement()
        .accessibilityLabel("Page")
        .accessibilityValue(pageAccessibilityValue)
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: advancePage(by: 1)
            case .decrement: advancePage(by: -1)
            @unknown default: break
            }
        }
    }

    private var pageAccessibilityValue: String {
        guard let selection,
              let index = items.firstIndex(where: { $0.id == selection }) else {
            return "1 of \(items.count)"
        }
        return "\(index + 1) of \(items.count)"
    }

    private func advancePage(by delta: Int) {
        guard let selection,
              let currentIndex = items.firstIndex(where: { $0.id == selection }) else { return }
        let nextIndex = currentIndex + delta
        guard items.indices.contains(nextIndex) else { return }
        self.selection = items[nextIndex].id
    }

    private func updateSelectionIfNeeded() {
        guard selection == nil || !items.contains(where: { $0.id == selection }) else { return }
        selection = items.first?.id
    }
}
