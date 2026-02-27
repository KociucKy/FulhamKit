import SwiftUI

/// Animation tokens for FulhamKit.
///
/// Centralised motion values ensure consistent feel across all interactive
/// components. Choose a token based on the type of interaction, not the
/// component — this keeps motion coherent as the design system grows.
///
/// ```swift
/// withAnimation(FKAnimation.spring) { isExpanded.toggle() }
///
/// .animation(FKAnimation.interactive, value: isPressed)
/// ```
public enum FKAnimation {

    // MARK: - Spring

    /// A snappy spring for direct-manipulation gestures (button presses,
    /// drag releases, selection toggles). Feels immediately responsive.
    ///
    /// `response: 0.3, dampingFraction: 0.7`
    public static let interactive: Animation = .spring(response: 0.3, dampingFraction: 0.7)

    /// A slightly bouncier spring for content expanding or appearing
    /// on screen (modals, popovers, cards sliding in).
    ///
    /// `response: 0.4, dampingFraction: 0.65`
    public static let spring: Animation = .spring(response: 0.4, dampingFraction: 0.65)

    /// A gentle spring for layout changes and reordering — minimal bounce,
    /// smooth settling. Good for list insertions or section toggling.
    ///
    /// `response: 0.45, dampingFraction: 0.85`
    public static let smooth: Animation = .spring(response: 0.45, dampingFraction: 0.85)

    // MARK: - Eased

    /// A fast ease-out for elements dismissing or hiding — quick exit,
    /// no bounce.
    ///
    /// Duration: `0.2s`, curve: `.easeOut`
    public static let dismiss: Animation = .easeOut(duration: 0.2)

    /// A medium ease-in-out for crossfades, opacity transitions,
    /// and colour changes.
    ///
    /// Duration: `0.25s`, curve: `.easeInOut`
    public static let fade: Animation = .easeInOut(duration: 0.25)

    /// A slow ease-in-out for large layout shifts or screen-level
    /// transitions where a slower pace feels intentional.
    ///
    /// Duration: `0.35s`, curve: `.easeInOut`
    public static let transition: Animation = .easeInOut(duration: 0.35)
}
