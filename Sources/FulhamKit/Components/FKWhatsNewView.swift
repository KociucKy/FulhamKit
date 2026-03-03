import SwiftUI

// MARK: - Model

/// A single feature entry displayed in ``FKWhatsNewView``.
public struct FKWhatsNewItem: Sendable {
    /// The SF Symbol name used for the icon tile.
    public let icon: String
    /// Background color of the icon tile.
    public let color: Color
    /// Short feature name, displayed in a prominent style.
    public let title: String
    /// One- or two-sentence description of the feature.
    public let description: String

    public init(icon: String, color: Color, title: String, description: String) {
        self.icon = icon
        self.color = color
        self.title = title
        self.description = description
    }
}

// MARK: - View

/// A "What's New" screen that presents a list of features with staggered entrance
/// animations. Intended to be presented as a sheet from the call site.
///
/// ```swift
/// .sheet(isPresented: $showWhatsNew) {
///     FKWhatsNewView(
///         version: "Version 2.0",
///         items: [
///             FKWhatsNewItem(
///                 icon: "trophy.fill",
///                 color: .orange,
///                 title: "League Tables",
///                 description: "Live standings updated after every match."
///             ),
///             FKWhatsNewItem(
///                 icon: "bell.badge.fill",
///                 color: .indigo,
///                 title: "Match Alerts",
///                 description: "Get notified the moment the final whistle blows."
///             )
///         ],
///         onContinue: { showWhatsNew = false }
///     )
/// }
/// ```
public struct FKWhatsNewView: View {

    // MARK: Properties

    private let version: String
    private let headline: String
    private let headerIcon: String
    private let items: [FKWhatsNewItem]
    private let onContinue: () -> Void

    // MARK: Animation state

    @State private var headerIconVisible = false
    @State private var headerTextVisible = false
    /// Number of feature rows currently revealed.
    @State private var visibleRows = 0
    @State private var continueVisible = false
    /// Drives the one-shot "pulse" on the header icon after it appears.
    @State private var headerIconPulsed = false

    // MARK: Init

    /// Creates a What's New view.
    /// - Parameters:
    ///   - version: Version string shown beneath the headline, e.g. `"Version 2.0"`.
    ///   - headline: Primary heading. Defaults to `"What's New"`.
    ///   - headerIcon: SF Symbol name for the decorative header icon. Defaults to `"sparkles"`.
    ///   - items: Ordered list of ``FKWhatsNewItem`` entries to display.
    ///   - onContinue: Called when the user taps the Continue button.
    public init(
        version: String,
        headline: String = "What's New",
        headerIcon: String = "sparkles",
        items: [FKWhatsNewItem],
        onContinue: @escaping () -> Void
    ) {
        self.version = version
        self.headline = headline
        self.headerIcon = headerIcon
        self.items = items
        self.onContinue = onContinue
    }

    // MARK: Body

    public var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection
                        .padding(.bottom, FKSpacing.extraLarge + FKSpacing.large)

                    featureList
                        .padding(.bottom, FKSpacing.extraLarge)
                }
                .padding(.horizontal, FKSpacing.large)
            }

            continueButton
                .padding(.horizontal, FKSpacing.large)
                .padding(.top, FKSpacing.small)
                // safeAreaPadding ensures the button clears the home indicator
                // in both portrait and landscape on all iPhone models.
                .safeAreaPadding(.bottom)
                .opacity(continueVisible ? 1 : 0)
                .offset(y: continueVisible ? 0 : 24)
        }
        .background(FKColor.Background.canvas)
        .task { await runEntranceSequence() }
    }

    // MARK: Header

    @ViewBuilder
    private var headerSection: some View {
        VStack(spacing: FKSpacing.medium) {
            Image(systemName: headerIcon)
                .font(.system(size: 56, weight: .semibold))
                .foregroundStyle(.tint)
                .scaleEffect(headerIconVisible ? (headerIconPulsed ? 1.0 : 1.08) : 0.4)
                .opacity(headerIconVisible ? 1 : 0)
                .animation(
                    headerIconPulsed
                        ? FKAnimation.interactive
                        : FKAnimation.spring,
                    value: headerIconVisible
                )
                .animation(FKAnimation.interactive, value: headerIconPulsed)

            VStack(spacing: FKSpacing.extraSmall) {
                Text(headline)
                    .font(FKTypography.statValue)
                    .foregroundStyle(FKColor.Label.primary)
                    .accessibilityAddTraits(.isHeader)

                Text(version)
                    .font(FKTypography.secondaryLabel)
                    .foregroundStyle(FKColor.Label.secondary)
            }
            .opacity(headerTextVisible ? 1 : 0)
            .offset(y: headerTextVisible ? 0 : 12)
            .animation(FKAnimation.smooth, value: headerTextVisible)
        }
        .multilineTextAlignment(.center)
    }

    // MARK: Feature list

    @ViewBuilder
    private var featureList: some View {
        VStack(spacing: FKSpacing.large) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                FeatureRow(item: item)
                    .opacity(visibleRows > index ? 1 : 0)
                    .offset(y: visibleRows > index ? 0 : 20)
                    .animation(FKAnimation.smooth, value: visibleRows)
            }
        }
    }

    // MARK: Continue button

    @ViewBuilder
    private var continueButton: some View {
        Button("Continue", action: onContinue)
            .callToActionButton()
            .animation(FKAnimation.smooth, value: continueVisible)
    }

    // MARK: Entrance sequence

    @MainActor
    private func runEntranceSequence() async {
        let nanosPerSecond: UInt64 = 1_000_000_000

        // Header icon appears
        try? await Task.sleep(nanoseconds: UInt64(0.15 * Double(nanosPerSecond)))
        guard !Task.isCancelled else { return }
        headerIconVisible = true

        // Header text slides up
        try? await Task.sleep(nanoseconds: UInt64(0.2 * Double(nanosPerSecond)))
        guard !Task.isCancelled else { return }
        headerTextVisible = true

        // Header icon settles back to 1.0× (pulse)
        try? await Task.sleep(nanoseconds: UInt64(0.15 * Double(nanosPerSecond)))
        guard !Task.isCancelled else { return }
        headerIconPulsed = true

        // Feature rows — staggered 0.1 s apart
        try? await Task.sleep(nanoseconds: UInt64(0.1 * Double(nanosPerSecond)))
        for index in items.indices {
            guard !Task.isCancelled else { return }
            visibleRows = index + 1
            try? await Task.sleep(nanoseconds: UInt64(0.1 * Double(nanosPerSecond)))
        }

        // Continue button
        guard !Task.isCancelled else { return }
        continueVisible = true
    }
}

// MARK: - Preview

#Preview("What's New") {
    FKWhatsNewView(
        version: "Version 2.0",
        items: [
            FKWhatsNewItem(
                icon: "trophy.fill",
                color: .orange,
                title: "League Tables",
                description: "Live standings updated in real time after every match."
            ),
            FKWhatsNewItem(
                icon: "bell.badge.fill",
                color: .indigo,
                title: "Match Alerts",
                description: "Get notified the moment the final whistle blows."
            ),
            FKWhatsNewItem(
                icon: "chart.bar.fill",
                color: .teal,
                title: "Player Stats",
                description: "Deep dive into performance data for every player on the pitch."
            ),
            FKWhatsNewItem(
                icon: "heart.fill",
                color: .pink,
                title: "Favourite Teams",
                description: "Pin your teams to the top so you never miss a result."
            )
        ],
        onContinue: { }
    )
}

#Preview("Minimal — single item") {
    FKWhatsNewView(
        version: "Version 1.1",
        headline: "New in This Update",
        headerIcon: "star.fill",
        items: [
            FKWhatsNewItem(
                icon: "bolt.fill",
                color: .yellow,
                title: "Faster Loading",
                description: "Match data now loads up to 3× faster on all connections."
            )
        ],
        onContinue: { }
    )
}

// MARK: - Feature Row

private struct FeatureRow: View {

    let item: FKWhatsNewItem

    var body: some View {
        HStack(alignment: .center, spacing: FKSpacing.large) {
            iconTile
            textStack
            Spacer(minLength: 0)
        }
        // Present the entire row as a single VoiceOver element.
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(item.title). \(item.description)")
    }

    @ViewBuilder
    private var iconTile: some View {
        RoundedRectangle(cornerRadius: FKRadius.small)
            .fill(item.color)
            .frame(width: 52, height: 52)
            .overlay {
                Image(systemName: item.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .fkShadow(FKShadow(color: item.color.opacity(0.35), radius: 8, x: 0, y: 4))
    }

    @ViewBuilder
    private var textStack: some View {
        VStack(alignment: .leading, spacing: FKSpacing.extraSmall) {
            Text(item.title)
                .font(FKTypography.ctaLabel)
                .foregroundStyle(FKColor.Label.primary)
            Text(item.description)
                .font(FKTypography.secondaryLabel)
                .foregroundStyle(FKColor.Label.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
