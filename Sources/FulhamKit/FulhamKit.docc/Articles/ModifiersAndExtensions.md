# Modifiers & Extensions

Thin view modifiers and convenience extensions that apply FulhamKit styling to any SwiftUI view.

## Overview

These APIs extend standard SwiftUI types rather than introducing new ones. They are the glue between your own views and the token layer.

---

## Button styles

Three `ButtonStyle` implementations cover the most common interactive press effects. Apply them with `.buttonStyle(.)` syntax.

```swift
// Scale down to 95% on press — good for card-level buttons
Button("Start") { startRoutine() }
    .buttonStyle(.fkPressable)

// Tint overlay on press — good for image buttons or cells with backgrounds
Button { } label: { Image(systemName: "play.fill") }
    .buttonStyle(.fkHighlight)

// Fade to 50% on press — subtle, good for text/link buttons
Button("See all") { }
    .buttonStyle(.fkFade)
```

### Topics

- ``FKPressableButtonStyle``
- ``FKHighlightButtonStyle``
- ``FKFadeButtonStyle``

---

## callToActionButton()

Styles any view as a full-width accent-color CTA bar — the standard primary action button throughout the app.

```swift
Button { submit() } label: {
    Text("Save Routine")
        .callToActionButton()
}
```

This applies `FKTypography.ctaLabel`, white foreground, `FKRadius.medium` corners, and a fixed 55 pt height. The caller is responsible for wrapping it in a `Button`.

### Topics

- ``CTAButtonModifier``

---

## fkShadow(_:)

Applies an ``FKShadow`` elevation token as a drop shadow. Prefer this over calling `.shadow()` directly so the elevation vocabulary stays consistent.

```swift
myCard.fkShadow(.medium)
```

### Topics

- ``FKShadow``

---

## fkBorder(cornerRadius:lineWidth:color:)

Strokes a rounded-rect border using FulhamKit line-width and color tokens.

```swift
// Default: thin separator-colored hairline
card.fkBorder(cornerRadius: FKRadius.medium)

// Focused / selected state
field.fkBorder(cornerRadius: FKRadius.small, lineWidth: FKBorder.medium, color: FKColor.Status.info)
```

### Topics

- ``FKBorder``

---

## skeleton(isLoading:)

Overlays an animated shimmer sweep on any view while content is loading. Works alongside `.redacted(reason: .placeholder)`.

```swift
Text("Loading title…")
    .font(FKTypography.cardTitle)
    .skeleton(isLoading: isLoading)

RoundedRectangle(cornerRadius: FKRadius.small)
    .frame(width: 120, height: 14)
    .skeleton(isLoading: isLoading)
```

### Topics

- ``SkeletonModifier``

---

## badged(count:max:color:)

Overlays an ``FKBadgeView`` count badge in the top-trailing corner. Hidden automatically when `count` is zero.

```swift
Image(systemName: "envelope")
    .font(.title2)
    .badged(count: unreadCount)
```

### Topics

- ``FKBadgeView``

---

## toast(_:)

Presents an ``FKToast`` notification driven by an optional binding. Dismisses automatically after `toast.duration` seconds.

```swift
RootView()
    .toast($activeToast)
```

### Topics

- ``FKToast``

---

## removeListRowFormatting()

Strips default `List` row insets and clears the row background, giving full layout control to the row content.

```swift
List(items) { item in
    FKCardView { ItemRow(item: item) }
        .removeListRowFormatting()
}
```

---

## Color(hex:)

Creates a `Color` from a 6- or 8-character hex string, with or without a leading `#`.

```swift
Color(hex: "#EF7B98")     // opaque pink
Color(hex: "EF7B98CC")    // pink at ~80% opacity
```

Returns `nil` for invalid strings.
