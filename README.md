# FulhamKit

A Swift design system for iOS, built with SwiftUI. Provides a layered set of design tokens, pre-built components, and view modifiers that keep a codebase consistent without repeating styling decisions.

**Platform:** iOS 18+ · **Swift:** 6.0 (strict concurrency) · **Dependencies:** none

---

## Contents

- [Architecture](#architecture)
- [Installation](#installation)
- [Tokens](#tokens)
- [Components](#components)
- [Modifiers & Extensions](#modifiers--extensions)
- [CI: Design System Lint](#ci-design-system-lint)
- [Documentation](#documentation)

---

## Architecture

FulhamKit is structured in three layers, each building on the one below:

```
┌─────────────────────────────────────┐
│   Modifiers & Extensions            │  Apply FK styling to standard SwiftUI views
├─────────────────────────────────────┤
│   Components                        │  Pre-built views assembled from tokens
├─────────────────────────────────────┤
│   Tokens                            │  Shared constants: color, type, space, etc.
└─────────────────────────────────────┘
```

All public types are prefixed with `FK` to avoid collisions with SwiftUI and app code.

---

## Installation

Add the package via Swift Package Manager:

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/your-org/FulhamKit", from: "1.0.0")
]
```

Or in Xcode: **File → Add Package Dependencies**, paste the repo URL.

Then import wherever needed:

```swift
import FulhamKit
```

---

## Tokens

Tokens are the foundation of the system — use them everywhere instead of hardcoded values. They are defined as caseless `enum` namespaces with static properties.

### `FKColor`

Semantic colors organised into five sub-namespaces. All values use `UIColor` trait-based closures so they automatically adapt to light/dark mode.

```swift
// Backgrounds
FKColor.Background.primary   // main surface (adapts to color scheme)
FKColor.Background.canvas    // recessed background behind cards

// Labels
FKColor.Label.primary
FKColor.Label.secondary
FKColor.Label.tertiary
FKColor.Label.placeholder

// Separators
FKColor.Separator.default
FKColor.Separator.opaque

// Interactive states
FKColor.Interactive.tinted      // confirmation / positive action
FKColor.Interactive.destructive // delete / irreversible action
FKColor.Interactive.disabled

// Status
FKColor.Status.success
FKColor.Status.warning
FKColor.Status.error
FKColor.Status.info
```

For non-View contexts (e.g. `UIKit` interop), use the `ColorScheme` convenience accessors:

```swift
colorScheme.backgroundPrimary
colorScheme.backgroundCanvas
```

### `FKTypography`

Named Dynamic Type styles — fully accessible, no custom fonts required.

```swift
FKTypography.cardTitle          // .title2.weight(.semibold)  — card headings
FKTypography.sectionHeader      // .title3.weight(.semibold)  — section headings
FKTypography.statValue          // .title.bold()              — large numeric values
FKTypography.ctaLabel           // .headline                  — button labels
FKTypography.body               // .body                      — standard list text
FKTypography.bodyBold           // .body.bold()               — prominent row text
FKTypography.secondaryLabel     // .subheadline               — secondary labels
FKTypography.caption            // .caption                   — timestamps, metadata
FKTypography.footnoteEmphasis   // .footnote.weight(.semibold)— badges, small labels
```

### `FKSpacing`

Spacing scale in points:

| Token | Value | Typical use |
|---|---|---|
| `extraSmall` | 4 pt | Icon-to-label gap |
| `small` | 6 pt | Tight related items |
| `default` | 8 pt | Component internal padding |
| `medium` | 12 pt | Compact card padding |
| `large` | 16 pt | Standard card/section padding |
| `extraLarge` | 20 pt | Gap between sibling components |

### `FKRadius`

Corner radius scale:

| Token | Value | Intended use |
|---|---|---|
| `small` | 8 pt | Chips, tags, compact containers |
| `medium` | 16 pt | Standard cards, CTA buttons |
| `large` | 24 pt | Large cards, modals |
| `extraLarge` | 32 pt | Hero cards, bottom sheets |

### `FKShadow`

Elevation tokens as a `Sendable` struct with `color`, `radius`, `x`, `y` properties. Apply via the `.fkShadow()` modifier.

| Token | Radius | Intended use |
|---|---|---|
| `.low` | 4 pt | Resting cards, list rows |
| `.medium` | 8 pt | Interactive cards |
| `.high` | 16 pt | Modals, sheets, popovers |
| `.lifted` | 24 pt | FABs, drag-preview elements |

```swift
MyCard()
    .fkShadow(.medium)
```

### `FKBorder`

Stroke weights and semantic border colors:

```swift
FKBorder.hairline       // 0.5 pt — separator lines
FKBorder.thin           // 1 pt  — standard card/input borders
FKBorder.medium         // 2 pt  — selected/focused state
FKBorder.thick          // 3 pt  — high-visibility indicators
FKBorder.color          // adaptive separator color
FKBorder.colorEmphasis  // more visible adaptive color
```

Apply via the `.fkBorder()` modifier:

```swift
MyCard()
    .fkBorder(cornerRadius: FKRadius.medium)
```

### `FKAnimation`

Motion tokens covering the most common SwiftUI animation curves:

```swift
FKAnimation.interactive  // spring — button presses, toggles
FKAnimation.spring       // spring — cards/modals appearing
FKAnimation.smooth       // spring — list insertions
FKAnimation.dismiss      // easeOut 0.2 s — elements exiting
FKAnimation.fade         // easeInOut 0.25 s — crossfades
FKAnimation.transition   // easeInOut 0.35 s — screen-level shifts
```

---

## Components

### `FKCardView`

A generic, styled card container. Applies background, border, and shadow tokens; accepts any SwiftUI content via `@ViewBuilder`.

```swift
FKCardView {
    VStack(alignment: .leading) {
        Text("Title").font(FKTypography.cardTitle)
        Text("Subtitle").font(FKTypography.secondaryLabel)
            .foregroundStyle(FKColor.Label.secondary)
    }
    .padding(FKSpacing.large)
}

// Customised
FKCardView(radius: FKRadius.large, shadow: .high, showBorder: false) {
    content
}
```

### `FKTextField`

A fully-styled text field with label, icon, secure entry, and inline validation feedback.

```swift
@State private var email = ""
@State private var fieldState: FKTextFieldState = .default

FKTextField(
    "Email",
    placeholder: "you@example.com",
    text: $email,
    state: $fieldState,
    icon: "envelope"
)
```

**`FKTextFieldState`** drives the border color and trailing accessory:

```swift
.default                           // blue focus ring
.success                           // green border + checkmark
.warning(message: "Check this")   // orange border + warning label
.error(message: "Required")       // red border + error label
```

### `FKEmptyStateView`

A full-screen empty state built on `ContentUnavailableView`.

```swift
FKEmptyStateView(
    icon: "tray",
    title: "Nothing here yet",
    message: "Items you add will appear here.",
    action: ("Add item", { viewModel.addItem() })
)
```

### `FKLoadingIndicator`

A centered spinner with optional label.

```swift
FKLoadingIndicator(label: "Loading matches...")
```

For skeleton loading, use the `skeleton(isLoading:)` modifier on any view:

```swift
MyRowView()
    .skeleton(isLoading: viewModel.isLoading)
```

### `FKBadgeView`

A pill badge — label or numeric variant.

```swift
FKBadgeView(label: "New")
FKBadgeView(count: 5)
FKBadgeView(count: 120, max: 99, color: FKColor.Status.error)
// displays "99+"
```

To overlay a badge on any view:

```swift
Image(systemName: "bell")
    .badged(count: unreadCount)
```

### Toast (`FKToast` + `.toast()` modifier)

Non-blocking notification that slides in from the top and auto-dismisses.

```swift
@State private var toast: FKToast?

Button("Save") {
    save()
    toast = FKToast(message: "Saved successfully", style: .success)
}
.toast($toast)
```

**`FKToast.Style`:** `.info` · `.success` · `.warning` · `.error`

### `CarouselView`

A paging horizontal carousel with built-in pagination dots.

```swift
CarouselView(items: fixtures, height: 200) { fixture in
    FixtureCard(fixture: fixture)
}
```

### `TagCellView`

An icon-badge + label tag cell (e.g. for position tags, category chips).

```swift
TagCellView(name: "Forward", icon: "figure.soccer", hexColor: "#EF7B98")
```

### `SectionHeaderView`

A section header with an optional tappable action.

```swift
SectionHeaderView(title: "Recent matches")

SectionHeaderView(title: "All fixtures") {
    navigate(to: .fixtures)
}
// Shows a chevron and becomes a button when action is provided
```

---

## Modifiers & Extensions

### Button styles

Three `ButtonStyle` implementations using `FKAnimation.interactive`:

```swift
Button("Submit") { ... }
    .buttonStyle(.fkPressable)  // scales to 0.95× on press

Button("Cancel") { ... }
    .buttonStyle(.fkHighlight)  // accent overlay on press

Button("More") { ... }
    .buttonStyle(.fkFade)       // opacity 0.5 on press
```

### `.callToActionButton()`

Full-width CTA button styling — font, height, background, radius — applied in one modifier:

```swift
Button("Continue") { next() }
    .callToActionButton()
```

### `.removeListRowFormatting()`

Strips default `List` row insets and background, giving full layout control to custom card-style rows:

```swift
List(items) { item in
    MyCardRow(item: item)
        .removeListRowFormatting()
}
```

### `Color(hex:)`

Creates a `Color` from a hex string:

```swift
Color(hex: "#EF7B98")
Color(hex: "3A86FF")
Color(hex: "3A86FFCC") // with alpha
```

---

## CI: Design System Lint

FulhamKit ships a reusable GitHub Actions workflow that scans pull requests in consumer app repos and fails CI if any Swift file introduces hardcoded values that should use FulhamKit tokens instead.

**Patterns checked:**

| Violation | Should be replaced with |
|---|---|
| `.padding(16)` | `FKSpacing.*` |
| `.cornerRadius(8)` | `FKRadius.*` |
| `.font(.system(size: 14))` | `FKTypography.*` |
| `.shadow(…radius: 4…)` | `FKShadow.*` |
| `.frame(width: 200…)` | `FKSpacing.*` |
| `Color(hex:)`, `UIColor(red:…)` | `FKColor.*` |
| `.animation(…duration: 0.3…)` | `FKAnimation.*` |
| `.foregroundStyle(.white)` | `FKColor.*` |

**Setup in a consumer app repo** — add one file, `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  design-system-lint:
    uses: your-org/FulhamKit/.github/workflows/design-system-lint.yml@main
    with:
      base-ref: ${{ github.base_ref }}
```

To suppress a legitimate exception, add `// fk:ignore` to the line:

```swift
.padding(0) // fk:ignore — intentional zero, not a spacing token
```

---

## Documentation

Full DocC documentation is included. Build it in Xcode via **Product → Build Documentation**, or from the terminal:

```bash
xcodebuild docbuild -scheme FulhamKit -destination 'generic/platform=iOS'
```

The documentation covers every public token, component, modifier, and extension with usage examples.
