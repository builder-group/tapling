# Why Native Swift for Keyboard Extension App

## Decision

We chose **Native Swift/SwiftUI** for building a keyboard companion app where the keyboard extension is the core mechanic, instead of React Native with Expo.

## Rationale

### Why Native Swift

The keyboard extension is the primary feature of the app. Native Swift provides direct access to iOS keyboard APIs, better performance (no JS bridge overhead), and straightforward integration with KeyboardKit - the standard Swift framework for custom keyboards.

### Why Not React Native with Expo

Initial exploration attempted to use React Native with Expo's `@bacons/apple-targets` plugin to create the keyboard extension.

**What worked:**
- `@bacons/apple-targets` can generate keyboard extension targets using Continuous Native Generation (CNG)
- The plugin successfully creates the target structure outside the generated `ios/` directory
- Basic keyboard extension template is generated correctly

**Blockers encountered:**
- `@bacons/apple-targets` is highly experimental and not officially supported
- Unable to add Swift Package Manager dependencies (KeyboardKit) to the keyboard extension target
- SPM dependencies must be added to the main app target, but configuration is lost when `ios/` folder is regenerated (gitignored in CNG mode)
- Could use Standard mode (commit `ios/` folder), but CNG is now the default and Standard requires manual maintenance

**Alternative considered: Custom Config Plugin**

Technically, it's possible to create a custom [Expo config plugin](https://docs.expo.dev/config-plugins/introduction/) that programmatically:
- Adds the keyboard extension target to the Xcode project
- Adds Swift Package Manager dependencies (KeyboardKit) to the main app target
- Links Swift files from a committed `targets/` directory

However, this approach requires:
- Deep understanding of Xcode project file format (`.pbxproj`)
- Complex manipulation of `XCRemoteSwiftPackageReference` and `XCSwiftPackageProductDependency` objects
- Significant development and maintenance overhead
- Risk of breaking with Xcode/Expo updates

**Conclusion:** The complexity of building and maintaining a custom config plugin exceeds the effort required to learn SwiftUI basics. Learning SwiftUI is a one-time investment, while a custom plugin would require ongoing maintenance and debugging.

### Things We Don't Like

#### Xcode Lock-in

SwiftUI code must be written in Xcode, limiting use of preferred editor (Cursor). IDE errors appear in Cursor when working with Swift files, reducing the "vibe coding" experience with AI assistance.

#### Learning Curve

Team has no prior Swift/SwiftUI experience, requiring time investment to learn a new language and framework.

#### No Android Support

Native Swift is iOS-only. This is acceptable for MVP, but limits future platform expansion.

## Resources & References

- [Expo Apple Targets Plugin](https://github.com/EvanBacon/expo-apple-targets)
- [Apple Home Screen Widgets with Expo CNG](https://evanbacon.dev/blog/apple-home-screen-widgets)
- [Expo Continuous Native Generation (CNG) Docs](https://docs.expo.dev/workflow/continuous-native-generation/)
- [Expo Config Plugins Introduction](https://docs.expo.dev/config-plugins/introduction/)
- [KeyboardKit Documentation](https://github.com/KeyboardKit/KeyboardKit)
- [Add support for Swift Package Manager (SPM) as the dependency manager for iOS](https://github.com/react-native-community/discussions-and-proposals/issues/587)
