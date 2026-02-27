# Components

Pre-built SwiftUI views assembled from FulhamKit tokens.

## Overview

Every component is a public struct with an `FK` prefix. They are composable — you can nest them freely and override individual token parameters when you need to deviate from the default appearance.

---

## FKCardView

A generic content container that handles background, corner radius, shadow, and optional border in one shot. Use it as a wrapper anywhere you'd otherwise stack `.background` + `.clipShape` + `.overlay` + `.shadow` by hand.

```swift
// Defaults: medium radius, low shadow, hairline border
FKCardView {
    RoutineRow(routine: routine)
}

// Override any parameter
FKCardView(radius: FKRadius.large, shadow: .medium, showBorder: false) {
    HeroImage(url: imageURL)
}
```

### Topics

- ``FKCardView``

---

## FKTextField

A fully styled text field with label, validation state, optional leading icon, and secure-entry reveal toggle.

```swift
@State private var email = ""
@State private var state: FKTextFieldState = .default

FKTextField(
    "Email",
    placeholder: "you@example.com",
    text: $email,
    state: $state,
    icon: "envelope"
)
.keyboardType(.emailAddress)
```

Validation states drive border color and an inline feedback message automatically:

```swift
// Mark a field invalid
state = .error(message: "Email already in use")

// Mark it valid
state = .success
```

### Topics

- ``FKTextField``
- ``FKTextFieldState``

---

## FKEmptyStateView

Wraps the system `ContentUnavailableView` to provide a consistent empty-state with an SF Symbol icon, title, optional message, and optional CTA button.

```swift
FKEmptyStateView(
    icon: "figure.run",
    title: "No Workouts",
    message: "Log your first workout to get started.",
    action: ("Add Workout", { showSheet = true })
)
```

### Topics

- ``FKEmptyStateView``

---

## FKLoadingIndicator

A minimal labeled spinner backed by `ProgressView`. Use it as a full-screen placeholder when data is loading.

```swift
if isLoading {
    FKLoadingIndicator(label: "Syncing workouts…")
}
```

For inline placeholder content, use the `skeleton(isLoading:)` modifier instead.

### Topics

- ``FKLoadingIndicator``
- ``SkeletonModifier``

---

## FKBadgeView

A pill-shaped badge for counts, labels, and status callouts. Numeric badges cap at a configurable maximum. Attach to any view with the `badged(count:max:color:)` modifier.

```swift
// Standalone
FKBadgeView(count: unread)
FKBadgeView(label: "NEW", color: FKColor.Status.success)

// Overlay attachment
Image(systemName: "bell")
    .badged(count: notificationCount)
```

### Topics

- ``FKBadgeView``

---

## FKToast

A non-blocking notification that appears at the top of the screen and auto-dismisses. Drive it with a `FKToast?` binding via the `toast(_:)` view modifier.

```swift
@State private var toast: FKToast?

ContentView()
    .toast($toast)
    .onAppear {
        toast = FKToast(message: "Saved!", style: .success)
    }
```

Four styles are available — `.info`, `.success`, `.warning`, `.error` — each with a matching icon and color drawn from ``FKColor/Status``.

### Topics

- ``FKToast``
- ``FKToast/Style``

---

## CarouselView

A horizontally paging carousel with dot pagination and a scale transition on neighbouring items.

```swift
CarouselView(items: featured, height: 180) { routine in
    FKCardView { RoutineCard(routine: routine) }
}
```

### Topics

- ``CarouselView``

---

## SectionHeaderView

A section header with an optional tappable chevron for navigation.

```swift
SectionHeaderView(title: "Recent Routines") {
    navigateToAll()
}
```

### Topics

- ``SectionHeaderView``

---

## FKWhatsNewView

A "What's New" sheet for presenting new features after an app update. The header icon springs in, the title fades up, and each feature row slides in sequentially — all driven by a structured async sequence that cancels automatically if the sheet is dismissed early.

```swift
.sheet(isPresented: $showWhatsNew) {
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
            )
        ],
        onContinue: { showWhatsNew = false }
    )
}
```

The `headline` and `headerIcon` parameters are optional and default to `"What's New"` and `"sparkles"`. Each ``FKWhatsNewItem`` takes a caller-specified `Color` for its icon tile, so the palette can match your app's branding per feature.

### Topics

- ``FKWhatsNewView``
- ``FKWhatsNewItem``
