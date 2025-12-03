# Keyboard Extension Permissions

## Without Full Access (Allowed)

### App Groups - Shared Data

- **UserDefaults** (shared suite via App Group)
- **SwiftData** (shared container)
- **CoreData** (shared container, likely works same as SwiftData)

**What we tested:** Read/write to shared UserDefaults and SwiftData from keyboard extension.

**Result:** Works without any special permissions. Updates are not real-time (e.g. via `@Query`) while keyboard is active, but keyboard picks up changes on next launch.

## With Full Access (Required)

### SwiftData `@Query` - Reactive Cross-Process Updates

- SwiftData's `@Query` property wrapper becomes reactive across processes
- Changes in main app instantly update views in keyboard extension
- No manual observation or state management needed

**What we tested:** Changed settings in main app using SwiftData, observed `@Query` in keyboard extension auto-updating views in real-time.

**Result:** Works with Full Access enabled. Without Full Access, `@Query` only updates on keyboard reload.

### Darwin Notifications - Real-time Events

- **CFNotificationCenter** Darwin notifications across processes
- Bi-directional communication between main app ↔ keyboard extension

**What we tested:** Main app posts Darwin notification, keyboard extension observes and responds with its own notification.

**Result:** Only works with Full Access enabled on physical device.

### Network Access

Required for any network requests from keyboard extension.
