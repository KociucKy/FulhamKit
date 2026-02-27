import SwiftUI

/// Typography tokens for FulhamKit.
///
/// Named font styles derived from the Routines app's usage patterns.
/// All styles use standard SwiftUI Dynamic Type — no custom fonts.
///
/// ```swift
/// Text("Trending Now")
///     .font(FKTypography.sectionHeader)
///
/// Text("Morning Run")
///     .font(FKTypography.cardTitle)
/// ```
public enum FKTypography {
    /// `.title2` semibold — primary card titles
    public static let cardTitle: Font = .title2.weight(.semibold)

    /// `.title3` semibold — section headers
    public static let sectionHeader: Font = .title3.weight(.semibold)

    /// `.title` bold — large numeric values (e.g. achievement counts)
    public static let statValue: Font = .title.bold()

    /// `.headline` — CTA button labels, primary row titles
    public static let ctaLabel: Font = .headline

    /// `.headline` semibold — emphasis within section headers
    public static let sectionHeaderEmphasis: Font = .headline.weight(.semibold)

    /// `.subheadline` — secondary card labels, tag names
    public static let secondaryLabel: Font = .subheadline

    /// `.body` — standard list row text
    public static let body: Font = .body

    /// `.body` bold — prominent list row text
    public static let bodyBold: Font = .body.bold()

    /// `.caption` — tertiary info, timestamps, metadata
    public static let caption: Font = .caption

    /// `.footnote` semibold — small emphasis labels (e.g. achievement titles)
    public static let footnoteEmphasis: Font = .footnote.weight(.semibold)
}
