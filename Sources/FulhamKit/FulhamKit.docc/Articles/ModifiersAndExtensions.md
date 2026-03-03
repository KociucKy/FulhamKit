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

---

## onFirstAppear(perform:) / onFirstTask(perform:)

Fires a closure (or async task) exactly once — on the first appearance only. Subsequent appearances after navigating away and back are ignored.

```swift
// Synchronous — runs on first onAppear
MyView()
    .onFirstAppear {
        viewModel.loadInitialData()
    }

// Async — runs as a SwiftUI task on first appearance; cancelled on disappear
MyView()
    .onFirstTask {
        await viewModel.fetchRemoteData()
    }
```

### Topics

- ``FirstAppearModifier``
- ``FirstTaskModifier``

---

## applyIf(_:transform:)

Conditionally applies a view transform without `if`/`AnyView` wrapping at the call site. When the condition is `false`, the view is returned unchanged.

```swift
Text("Pro")
    .font(FKTypography.caption)
    .applyIf(user.isPro) { label in
        label.bold().foregroundStyle(FKColor.Interactive.tinted)
    }

MyCard()
    .applyIf(isSelected) { card in
        card.fkBorder(cornerRadius: FKRadius.medium, lineWidth: FKBorder.medium)
    }
```

---

## tappableBackground()

Makes the entire frame of a view hittable, including empty space between subviews. Required when `.onTapGesture` on a `VStack` or `HStack` fails to fire in the gaps.

```swift
VStack(spacing: FKSpacing.medium) {
    Image(systemName: "figure.soccer")
    Text("Kick-off")
}
.tappableBackground()
.onTapGesture { selectItem() }
```

---

## imageScrimBackground(scrimOpacity:)

Overlays a vertical gradient (transparent → black at the given opacity) to improve text legibility over image backgrounds. The opacity defaults to `0.4` and can be customised per call site.

```swift
Image("match-hero")
    .overlay(alignment: .bottom) {
        VStack {
            Text("Fulham vs Arsenal").font(FKTypography.cardTitle)
            Text("Saturday, 15:00").font(FKTypography.caption)
        }
        .padding(FKSpacing.large)
        .imageScrimBackground()          // default 0.4 opacity
        // .imageScrimBackground(scrimOpacity: 0.6)  // darker scrim
    }
```

---

## badgeStyle(backgroundColor:)

Wraps content in a compact, pill-shaped badge capsule. Uses `FKSpacing.default` horizontal padding and `FKSpacing.extraSmall` vertical padding, then clips to a `Capsule`.

```swift
Text("Live")
    .font(FKTypography.footnoteEmphasis)
    .foregroundStyle(.white)
    .badgeStyle(backgroundColor: FKColor.Status.error)

Text("New")
    .font(FKTypography.caption)
    .badgeStyle(backgroundColor: FKColor.Interactive.tinted.opacity(0.15))
```

---

## onNotificationReceived(_:action:)

Subscribes to a `NotificationCenter` notification for the lifetime of the view. The subscription is established on appear and cancelled when the view is removed.

```swift
MyView()
    .onNotificationReceived(.NSManagedObjectContextDidSave) { _ in
        viewModel.refresh()
    }
```

### Topics

- ``NotificationListenerModifier``

---

## Binding(ifNotNil:)

Creates a `Binding<Bool>` driven by a `Binding<T?>`. Reads `true` when the optional is non-nil; writing `false` sets the optional back to `nil`. Useful for sheet and alert presentation driven by optional state.

```swift
@State private var selectedPlayer: Player?

.sheet(isPresented: Binding(ifNotNil: $selectedPlayer)) {
    if let player = selectedPlayer {
        PlayerDetailView(player: player)
    }
}
