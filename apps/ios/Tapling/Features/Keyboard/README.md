# Keyboard Feature

Keyboard-related code shared between the main app and Keyboard extension.

## Why in the main app target?

iOS app extensions [cannot be unit tested directly](https://stackoverflow.com/questions/24627600/how-to-unit-test-an-app-extension-on-xcode-6). Apple recommends factoring testable code into a framework.

Instead of a separate framework, we place testable code in the main app target (`Tapling`), which:

- Can be unit tested
- Is accessible to the extension (already configured in `project.pbxproj`)
- Simpler than a framework
