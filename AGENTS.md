# FulhamKit — Agent Guidelines

## Project Overview

FulhamKit is an iOS-only Swift Package (SPM library) implementing a design system.
It is **not** an app — it is a reusable library distributed as a dependency.

- **Platform:** iOS 18.0 minimum. No macOS, watchOS, or tvOS support.
- **Swift tools version:** 6.0 (strict concurrency enabled by default).
- **Zero external dependencies.** The library is entirely self-contained.
- **No test target** exists in the package.

### Architecture Layers (bottom → top)

1. `Tokens/` — pure design constants (`enum` namespaces with `static let/func`)
2. `Components/` — `struct` views built entirely from tokens
3. `Modifiers/` — `ViewModifier` wrappers and `ButtonStyle` extensions
4. `Extensions/` — extensions on SwiftUI built-in types

Higher layers may reference lower layers; never the reverse.

---

## Build Commands

The package is iOS-only. Running `swift build` without a destination will fail
because `UIColor` is unavailable on macOS.

```bash
# Build for iOS Simulator
swift build -destination 'platform=iOS Simulator,name=iPhone 16'

# Build DocC documentation
xcodebuild docbuild -scheme FulhamKit -destination 'generic/platform=iOS'
```

Open in Xcode by double-clicking `Package.swift` (there is no `.xcodeproj`).

---

## Lint / Format Commands

No automated linting or formatting tooling is configured (no SwiftLint, no
SwiftFormat, no `.editorconfig`). Enforce the code style rules below manually
when writing or reviewing code.

The `.github/scripts/check_design_system.sh` script is a **design-token
enforcement** tool for *consumer* apps, not a code-style linter for this repo.

---

## Tests

There are **no tests**. The package declares no test target. When one is added:

```bash
# Run all tests (once a test target exists)
swift test -destination 'platform=iOS Simulator,name=iPhone 16'

# Run a single test method
swift test -destination 'platform=iOS Simulator,name=iPhone 16' \
  --filter FulhamKitTests/TestClassName/testMethodName
```

---

## Code Style Guidelines

### Imports

- One import per file: always `import SwiftUI`. Nothing else.
- Place the import as the **first line** of the file with no preceding blank line.
- Do not add `import Foundation` — SwiftUI already includes it.

### Formatting

- **4-space indentation.** No tabs.
- Opening braces on the **same line** as the declaration (K&R / 1TBS style).
- One blank line between top-level declarations.
- Multi-line `init` and function parameters: each argument on its own line,
  closing parenthesis on its own line.

  ```swift
  public init(
      radius: CGFloat = FKRadius.medium,
      shadow: FKShadow? = .low,
      @ViewBuilder content: @escaping () -> Content
  ) { ... }
  ```

- Multi-line method chains: each modifier on its own line, indented 4 spaces.

  ```swift
  content()
      .background(FKColor.Background.primary)
      .clipShape(.rect(cornerRadius: radius))
      .overlay { ... }
  ```

- Align values in `switch` cases and token declarations into a column for
  readability when they form a logical group.

### Types and Type Annotations

- Write **explicit type annotations on all `public static let` properties**,
  even when the type could be inferred. This is required for API clarity.

  ```swift
  public static let medium: CGFloat = 12
  public static let cardTitle: Font = .headline
  ```

- Omit annotations on `private` stored properties when the type is obvious from
  the initializer literal. Annotate when it aids clarity.
- Always write return types on computed properties and functions explicitly
  (`-> some View`, `-> Color`, `-> CGFloat?`).
- Use `let` everywhere; only use `var` when mutation is genuinely required.

### Naming Conventions

| Category | Convention | Example |
|---|---|---|
| Public types | `UpperCamelCase` with `FK` prefix | `FKCardView`, `FKSpacing` |
| Internal/private types | `UpperCamelCase`, no `FK` prefix | `ToastView`, `FeatureRow` |
| Internal implementation details | Leading underscore | `_UncheckedSendableBox` |
| Token values / properties | `lowerCamelCase` | `extraSmall`, `cardTitle` |
| View modifier extension methods | `lowerCamelCase`, verb-first | `callToActionButton()`, `fkShadow(_:)` |
| `ButtonStyle` static shorthands | `lowerCamelCase` with `fk` prefix | `.fkPressable`, `.fkFade` |
| Files | `TypeName.swift` / `Type+Extension.swift` | `FKCardView.swift`, `Color+Hex.swift` |

**`FK` prefix rule:** Every public type exported by the library carries the
`FK` prefix without exception. Internal helpers do not.

### Architectural Patterns

**Caseless `enum` as namespace.** Use a caseless `enum` for all token
namespaces. This prevents instantiation while allowing `static` members.

```swift
public enum FKSpacing {
    public static let small: CGFloat = 8
    public static let medium: CGFloat = 16
}
```

**`ViewModifier` + `View` extension pair.** Every modifier follows a two-part
pattern: (1) a `struct` conforming to `ViewModifier`, and (2) a
`public extension View` providing the ergonomic call-site method.

```swift
public struct CTAButtonModifier: ViewModifier { ... }

public extension View {
    func callToActionButton(...) -> some View {
        modifier(CTAButtonModifier(...))
    }
}
```

**`ButtonStyle` dot-syntax shorthand.** Accompany each `ButtonStyle` with a
`public extension ButtonStyle where Self == Foo` providing a static shorthand.

**`@ViewBuilder` computed properties for decomposition.** Break complex view
`body` into named `private var` computed properties annotated `@ViewBuilder`.
Keep `body` shallow.

### Access Control

- All public-facing declarations must be **explicitly marked `public`**: types,
  `init`, `var body`, `func`, `static let/func`, extensions.
- All implementation details must be **explicitly marked `private`**: stored
  properties on components, helper computed properties, sub-view structs.
- **Never write `internal` explicitly** — leave it as the implicit default.
- **Never use `open`** — the library does not support subclassing.

### Error Handling

- No `throws`/`try`/`catch` in public API. Design APIs so errors cannot occur.
- Use failable `init?` for optional parsing (e.g. `Color(hex:)`). Callers
  handle `nil` with `??` to supply a fallback.
- Use `assertionFailure(...)` for developer-facing API misuse guards (debug
  only). Never use `fatalError` in library code.
- Swallow `Task.sleep` cancellation errors with `try?`; guard cancellation via
  `Task.isCancelled` instead.

### Swift Concurrency (Swift 6 Strict Mode)

- The package uses Swift 6 tools — **strict concurrency is on by default**.
  All code must satisfy the compiler without `@preconcurrency` suppressions.
- Annotate async functions that mutate `@State` with `@MainActor`.
- Drive animations and entrance sequences via `.task { }` (provides automatic
  cancellation on view disappearance) rather than `.onAppear`.
- Store auto-dismiss `Task` handles as `@State private var task: Task<Void, Never>?`
  and cancel the previous task before starting a new one.
- Conform value types to `Sendable` when they contain `Color` or other
  reference-semantic values that cross concurrency boundaries.
- Use `@unchecked Sendable` only as a last resort, always with a comment
  explaining why it is safe. Name the wrapper type with a leading underscore.
- No actors. No `nonisolated`. No `@preconcurrency`.

### Documentation and Comments

- Write **DocC `///` doc comments on every public declaration** (types, inits,
  properties, functions). Minimum: one summary sentence.
- For functions with parameters, include `/// - Parameter name:` or
  `/// - Parameters:` sections and a `/// - Returns:` section.
- Embed a `/// ```swift ... ``` ` usage example in every public symbol's doc.
- Use ` ``TypeName`` ` syntax for DocC cross-references to other symbols.
- Use `// MARK: -` (with dash) for major section headers and `// MARK:` (no
  dash) for sub-sections. Common marks: `Init`, `Configuration`,
  `Internal state`, `Body`, `Helpers`, `Preview`.
- Use inline `// comments` sparingly — only for non-obvious logic.
- Add `#Preview` blocks to all component files. Use `@Previewable @State` in
  previews that require mutable state.

### Tokens Reference

Always use FK tokens instead of magic values:

| Category | Namespace |
|---|---|
| Colors | `FKColor.Background`, `FKColor.Label`, `FKColor.Status`, etc. |
| Spacing | `FKSpacing` |
| Corner radii | `FKRadius` |
| Typography | `FKTypography` |
| Shadows | `FKShadow` (`.low`, `.medium`, `.high`, `.lifted`) |
| Borders | `FKBorder` |
| Animation | `FKAnimation` |

Never use raw `CGFloat` literals, `Color(...)` literals, or `Font(...)` literals
in `Components/` or `Modifiers/`. All such values must come from a token.
