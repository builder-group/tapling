# Native Swift/SwiftUI for iOS App

## Decision

Build the entire iOS app with native Swift/SwiftUI instead of React Native + Expo.

## Rationale

### Keyboard Extension = Core Feature

The keyboard extension is the primary feature of the app. Native Swift provides:

- Direct access to iOS keyboard APIs
- Better performance (no JS bridge overhead)
- Straightforward integration with KeyboardKit (standard Swift framework for custom keyboards)

### React Native Blockers

Initial exploration attempted to use React Native with Expo's `@bacons/apple-targets` plugin to create the keyboard extension.

**What worked:**

- `@bacons/apple-targets` can generate keyboard extension targets using Continuous Native Generation (CNG)
- Plugin successfully creates target structure outside `ios/` directory
- Basic keyboard extension template generates correctly

**Blockers encountered:**

- `@bacons/apple-targets` is highly experimental and not officially supported
- Unable to add Swift Package Manager dependencies (KeyboardKit) to keyboard extension target
- SPM dependencies must be added to main app target, but configuration is lost when `ios/` folder is regenerated (gitignored in CNG mode)
- Could use Standard mode (commit `ios/` folder), but CNG is now default and Standard requires manual maintenance

**Alternative considered: Custom Config Plugin**

Technically possible to create a custom [Expo config plugin](https://docs.expo.dev/config-plugins/introduction/) that programmatically:

- Adds keyboard extension target to Xcode project
- Adds Swift Package Manager dependencies (KeyboardKit) to main app target
- Links Swift files from committed `targets/` directory

However, this requires:

- Deep understanding of Xcode project file format (`.pbxproj`)
- Complex manipulation of `XCRemoteSwiftPackageReference` and `XCSwiftPackageProductDependency` objects
- Significant development and maintenance overhead
- Risk of breaking with Xcode/Expo updates

**Conclusion:** The complexity of building and maintaining a custom config plugin exceeds the effort required to learn SwiftUI basics. Learning SwiftUI is a one-time investment, while a custom plugin would require ongoing maintenance and debugging.

## Trade-offs

### Xcode Lock-in

SwiftUI code must be written in Xcode, limiting use of preferred editor (Cursor). IDE errors appear in Cursor when working with Swift files, reducing the "vibe coding" experience with AI assistance.

### Learning Curve

Team has no prior Swift/SwiftUI experience, requiring time investment to learn a new language and framework.

### No Android Support

Native Swift is iOS-only. This is acceptable for MVP, but limits future platform expansion.

## Resources & References

- [Expo Apple Targets](https://github.com/EvanBacon/expo-apple-targets)
- [Apple Home Screen Widgets with Expo CNG](https://evanbacon.dev/blog/apple-home-screen-widgets)
- [Expo Continuous Native Generation Docs](https://docs.expo.dev/workflow/continuous-native-generation/)
- [Expo Config Plugins](https://docs.expo.dev/config-plugins/introduction/)
- [KeyboardKit](https://github.com/KeyboardKit/KeyboardKit)
- [Swift Package Manager in React Native Discussion](https://github.com/react-native-community/discussions-and-proposals/issues/587)
