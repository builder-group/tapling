# App Groups for Data Sync Between App and Extensions

## Decision

We use **App Groups** with a single master group (`group.com.buildergroup.Tapling`) to share data between the main app and keyboard extension.

## Rationale

### Why App Groups?

App Groups are Apple's recommended mechanism for sharing data between an app and its extensions. They provide:
- **Shared container**: Both app and extension can read/write to the same UserDefaults or file system location
- **Automatic sync**: Changes are immediately available to all members of the group
- **Security**: Data is sandboxed within the App Group, isolated from other apps

### Why One Master Group?

We use a **single App Group** (`group.com.buildergroup.Tapling`) for all extensions rather than separate groups:

**Advantages:**
- **Simpler configuration**: One group to manage in Apple Developer portal and Xcode
- **Easier maintenance**: Single source of truth for shared data
- **Future-proof**: If we add more extensions (e.g., widget, share extension), they can all use the same group
- **Less overhead**: Fewer entitlements to configure and maintain

## References

- [Apple: App Extension Programming Guide - Sharing Data](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionScenarios.html)
- [Apple: UserDefaults Documentation](https://developer.apple.com/documentation/foundation/userdefaults)

