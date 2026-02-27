import SwiftUI

public extension View {
    /// Removes default `List` row insets and clears the row background.
    ///
    /// Use this when you want full control over a list row's layout —
    /// for example, to make a custom card fill the row edge-to-edge.
    ///
    /// ```swift
    /// List(items) { item in
    ///     CardView(item: item)
    ///         .removeListRowFormatting()
    /// }
    /// ```
    func removeListRowFormatting() -> some View {
        self
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
    }
}
