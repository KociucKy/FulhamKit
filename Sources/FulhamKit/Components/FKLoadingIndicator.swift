import SwiftUI

// MARK: - FKLoadingIndicator

/// A labelled loading spinner.
///
/// Wraps `ProgressView` with consistent FulhamKit typography and spacing.
///
/// ```swift
/// if isLoading {
///     FKLoadingIndicator()
/// }
///
/// FKLoadingIndicator(label: "Syncing workouts…")
/// ```
public struct FKLoadingIndicator: View {
    private let label: String?

    /// Creates a loading indicator.
    ///
    /// - Parameter label: Optional descriptive text shown below the spinner.
    ///   Defaults to `nil` (spinner only).
    public init(label: String? = nil) {
        self.label = label
    }

    public var body: some View {
        VStack(spacing: FKSpacing.medium) {
            ProgressView()
            if let label {
                Text(label)
                    .font(FKTypography.secondaryLabel)
                    .foregroundStyle(FKColor.Label.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // Provide a single, descriptive VoiceOver label for the whole indicator.
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label ?? "Loading")
        .accessibilityAddTraits(.updatesFrequently)
    }
}

// MARK: - Skeleton modifier

/// Applies a shimmer skeleton loading effect to any view.
///
/// Use this modifier to mask content with an animated placeholder while
/// real data is loading.
///
/// ```swift
/// Text("Loading title...")
///     .font(FKTypography.cardTitle)
///     .skeleton(isLoading: isLoading)
///
/// RoundedRectangle(cornerRadius: FKRadius.small)
///     .frame(width: 120, height: 14)
///     .skeleton(isLoading: isLoading)
/// ```
public struct SkeletonModifier: ViewModifier {
    let isLoading: Bool

    @State private var phase: CGFloat = -1

    public func body(content: Content) -> some View {
        content
            .redacted(reason: isLoading ? .placeholder : [])
            .overlay {
                if isLoading {
                    GeometryReader { geo in
                        let width = geo.size.width
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0),
                                .init(color: .white.opacity(0.5), location: 0.4),
                                .init(color: .clear, location: 1),
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: width * 2)
                        .offset(x: phase * width * 2)
                    }
                    .clipped()
                    .allowsHitTesting(false)
                    // The shimmer is a decorative animation; hide it from VoiceOver.
                    .accessibilityHidden(true)
                }
            }
            // While loading, replace the redacted placeholder text with a
            // single meaningful label so VoiceOver users aren't read gibberish.
            .accessibilityLabel(isLoading ? "Loading" : "")
            .accessibilityAddTraits(isLoading ? .updatesFrequently : [])
            .onAppear {
                guard isLoading else { return }
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
            .onChange(of: isLoading) { _, loading in
                phase = loading ? -1 : phase
                if loading {
                    withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                        phase = 1
                    }
                }
            }
    }
}

public extension View {
    /// Applies an animated shimmer skeleton placeholder when `isLoading` is `true`.
    ///
    /// - Parameter isLoading: When `true`, the view is redacted and a shimmer
    ///   sweep animation is overlaid.
    func skeleton(isLoading: Bool) -> some View {
        modifier(SkeletonModifier(isLoading: isLoading))
    }
}

// MARK: - Previews

#Preview("LoadingIndicator") {
    VStack(spacing: FKSpacing.extraLarge) {
        FKLoadingIndicator()
            .frame(height: 80)

        FKLoadingIndicator(label: "Syncing workouts…")
            .frame(height: 80)
    }
    .padding()
    .background(FKColor.Background.canvas)
}

#Preview("Skeleton") {
    @Previewable @State var isLoading = true

    VStack(alignment: .leading, spacing: FKSpacing.large) {
        ForEach(0..<3) { _ in
            FKCardView {
                HStack(spacing: FKSpacing.medium) {
                    RoundedRectangle(cornerRadius: FKRadius.small)
                        .frame(width: 44, height: 44)
                        .skeleton(isLoading: isLoading)

                    VStack(alignment: .leading, spacing: FKSpacing.extraSmall) {
                        Text("Placeholder title text")
                            .font(FKTypography.bodyBold)
                            .skeleton(isLoading: isLoading)
                        Text("Subtitle detail text here")
                            .font(FKTypography.secondaryLabel)
                            .skeleton(isLoading: isLoading)
                    }
                    Spacer()
                }
                .padding(FKSpacing.medium)
            }
        }

        Button(isLoading ? "Stop loading" : "Start loading") {
            isLoading.toggle()
        }
        .callToActionButton()
    }
    .padding(FKSpacing.large)
    .background(FKColor.Background.canvas)
}
