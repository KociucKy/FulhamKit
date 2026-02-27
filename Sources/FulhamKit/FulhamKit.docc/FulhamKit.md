# ``FulhamKit``

A Swift design system for iOS — tokens, components, and modifiers that keep your UI consistent.

## Overview

FulhamKit provides a layered set of building blocks:

- **Tokens** — the lowest layer. Shared constants for color, typography, spacing, radius, animation, shadow, and border. Reference these everywhere instead of hardcoding values.
- **Components** — pre-built SwiftUI views assembled from tokens. Drop them into any screen without re-specifying the token values.
- **Modifiers & Extensions** — thin view modifiers and convenience extensions that apply FulhamKit styling to standard SwiftUI views.

### Getting started

Add the package to your project, then import once at the top of each file:

```swift
import FulhamKit
```

All public types are prefixed with `FK` to avoid naming collisions with your own code and with SwiftUI itself.

## Topics

### Tokens

- <doc:TokensGuide>

### Components

- <doc:ComponentsGuide>

### Modifiers & Extensions

- <doc:ModifiersAndExtensions>
