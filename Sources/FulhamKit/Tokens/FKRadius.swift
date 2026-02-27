import SwiftUI

/// Corner radius tokens for FulhamKit.
///
/// ```swift
/// .clipShape(.rect(cornerRadius: FKRadius.medium))
/// ```
public enum FKRadius {
    /// 8pt — compact containers, chips, small cards
    public static let small: CGFloat = 8
    /// 16pt — standard cards, CTA buttons, tag badges
    public static let medium: CGFloat = 16
    /// 24pt — large cards, modals, sheet headers
    public static let large: CGFloat = 24
    /// 32pt — extra-large surfaces such as hero cards or bottom sheets
    public static let extraLarge: CGFloat = 32
}
