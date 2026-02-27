import SwiftUI

/// A horizontally paging carousel with dot-based pagination indicators.
///
/// Items snap one-at-a-time and apply a scale transition (0.9×) to
/// off-screen neighbours for depth. A row of dots below the scroll view
/// reflects the current page.
///
/// ```swift
/// CarouselView(items: routines, height: 120) { routine in
///     RoutineCardView(routine: routine)
/// }
/// ```
///
/// - Note: `Item` must conform to `Hashable`. Each item's hash value is
///   used as a stable scroll identity.
public struct CarouselView<Item: Hashable & Sendable, Content: View>: View {
    var items: [Item]
    var height: CGFloat
    @ViewBuilder var content: (Item) -> Content

    @State private var selection: Item?

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
                    ForEach(items, id: \.hashValue) { item in
                        content(item)
                            .id(item)
                            .scrollTransition(
                                .interactive.threshold(.visible(0.95)),
                                transition: { content, phase in
                                    content.scaleEffect(phase.isIdentity ? 1 : 0.9)
                                }
                            )
                            .containerRelativeFrame(.horizontal, alignment: .center)
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

            HStack(spacing: FKSpacing.small) {
                ForEach(items, id: \.hashValue) { item in
                    Circle()
                        .fill(item == selection ? Color.accentColor : Color.secondary.opacity(0.5))
                        .frame(width: FKSpacing.small, height: FKSpacing.small)
                }
            }
            .animation(.linear, value: selection)
        }
    }

    private func updateSelectionIfNeeded() {
        if selection == nil || !items.contains(where: { $0 == selection }) {
            selection = items.first
        }
    }
}
