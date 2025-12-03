# SwiftData over UserDefaults for Settings

## Decision

We use **SwiftData** for storing and syncing settings between the main app and keyboard extension, instead of UserDefaults.

## Rationale

### Reactive Updates with Full Access

SwiftData's `@Query` property wrapper provides automatic, real-time updates across the main app and keyboard extension when Full Access is enabled. When settings change in the main app, the keyboard extension's views automatically re-render with new values.

UserDefaults requires manual observation (`NotificationCenter.default.addObserver` for `didChangeNotification`) and manual state updates, resulting in more boilerplate code.

### Type Safety

SwiftData models are strongly typed with Swift's type system. UserDefaults stores untyped values that require casting and optional handling at every read.

```swift
// SwiftData - type safe
@Query var settings: [KeyboardSettings]
let debug = settings.first?.debug  // Bool

// UserDefaults - requires casting
let debug = UserDefaults.shared.bool(forKey: "debug")  // Could be anything
```

### Single Source of Truth

SwiftData provides a single model definition shared between both targets. UserDefaults requires maintaining parallel key strings and default values across the codebase.

### Query-based Access

SwiftData's `@Query` integrates natively with SwiftUI, automatically managing data fetching and view updates. UserDefaults requires manual `@State` or `@Published` properties and imperative updates.

## Trade-offs

### Query-based Access Pattern

SwiftData is relational/query-based, so accessing singleton settings requires:
```swift
@Query private var queriedSettings: [KeyboardSettings]
private var settings: KeyboardSettings {
    queriedSettings.first!
}
```

This is slightly more verbose than UserDefaults' direct static property access. Can be abstracted with a `@QuerySingleton` property wrapper for cleaner syntax:
```swift
@QuerySingleton private var settings: KeyboardSettings
```

However, even with the manual pattern, the overall codebase is still significantly smaller and cleaner than with UserDefaults.

### Requires Full Access for Real-time Updates

SwiftData's reactive `@Query` only works cross-process with Full Access enabled. Without it, updates sync only on keyboard reload.

UserDefaults has the same limitation - real-time observation across processes also requires Full Access for notifications to work.
