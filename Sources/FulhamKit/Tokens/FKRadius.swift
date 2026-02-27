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
}
