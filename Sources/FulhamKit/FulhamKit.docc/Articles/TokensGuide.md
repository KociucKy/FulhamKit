# Tokens

Shared design constants — the single source of truth for color, type, spacing, and motion.

## Overview

Tokens are plain Swift enums with static properties. Every component in FulhamKit is built on top of them, and you should use them directly in your own views too. Hardcoding a literal like `16` or `Color(.systemBlue)` where a token exists creates drift; using the token means a future update propagates everywhere automatically.

---

## FKColor

``FKColor`` organises semantic colors into five sub-namespaces. Use dot-completion to browse them.

```swift
// Backgrounds
view.background(FKColor.Background.canvas)      // page / outermost layer
card.background(FKColor.Background.primary)     // card surface above canvas

// Text
Text("Title").foregroundStyle(FKColor.Label.primary)
Text("Hint").foregroundStyle(FKColor.Label.placeholder)

// Dividers
Divider().foregroundStyle(FKColor.Separator.default)

// Interactive states
deleteButton.tint(FKColor.Interactive.destructive)

// Status
badge.foregroundStyle(FKColor.Status.success)
```

All static `Color` properties are backed by dynamic `UIColor` providers, so they adapt to light/dark mode automatically inside SwiftUI views. Use the `(for: ColorScheme)` overloads when you need to resolve a color outside a view hierarchy.

### Topics

- ``FKColor``
- ``FKColor/Background``
- ``FKColor/Label``
- ``FKColor/Separator``
- ``FKColor/Interactive``
- ``FKColor/Status``

---

## FKTypography

``FKTypography`` maps semantic roles to standard Dynamic Type styles. All styles scale with the user's accessibility text size setting automatically.

```swift
Text("Morning Run").font(FKTypography.cardTitle)
Text("3 exercises").font(FKTypography.secondaryLabel)
Text("2 min ago").font(FKTypography.caption)
```

### Topics

- ``FKTypography``

---

## FKSpacing

``FKSpacing`` is a linear scale from 4 pt to 20 pt. Pick by intent, not by measurement.

```swift
VStack(spacing: FKSpacing.small) { ... }
.padding(FKSpacing.large)
```

| Token | Value | Typical use |
|---|---|---|
| `extraSmall` | 4 pt | Icon + label gap |
| `small` | 6 pt | Tight related items |
| `default` | 8 pt | Component internal spacing |
| `medium` | 12 pt | Compact card padding |
| `large` | 16 pt | Standard card padding, section padding |
| `extraLarge` | 20 pt | Sibling component gaps |

### Topics

- ``FKSpacing``

---

## FKRadius

``FKRadius`` provides four corner-radius steps plus two special values.

```swift
.clipShape(.rect(cornerRadius: FKRadius.small))   // chips, tags
.clipShape(.rect(cornerRadius: FKRadius.medium))  // cards, buttons
.clipShape(.rect(cornerRadius: FKRadius.large))   // modals
```

### Topics

- ``FKRadius``

---

## FKAnimation

``FKAnimation`` separates animations into spring-based (for interactive elements) and eased (for state transitions). Never hardcode durations or curves.

```swift
// Direct manipulation — snappy, slightly bouncy
.animation(FKAnimation.interactive, value: isPressed)

// Content appearing on screen
withAnimation(FKAnimation.spring) { isExpanded = true }

// Dismissing something
withAnimation(FKAnimation.dismiss) { isVisible = false }
```

### Topics

- ``FKAnimation``

---

## FKShadow

``FKShadow`` bundles color, radius, and offset into elevation levels. Apply via the `fkShadow(_:)` view modifier rather than calling `.shadow()` directly.

```swift
card.fkShadow(.low)     // resting card
modal.fkShadow(.high)   // above everything
```

### Topics

- ``FKShadow``

---

## FKBorder

``FKBorder`` provides line-width and color constants for strokes. Use the `fkBorder(cornerRadius:lineWidth:color:)` modifier for the common card-outline case.

```swift
card.fkBorder(cornerRadius: FKRadius.medium)

// Error state on an input
field.fkBorder(
    cornerRadius: FKRadius.small,
    lineWidth: FKBorder.medium,
    color: FKColor.Status.error
)
```

### Topics

- ``FKBorder``
