# Keyboard Extension Permissions

What works with/without Full Access.

## Without Full Access ✅

**App Groups (read/write):**
- UserDefaults (shared suite)
- SwiftData (shared container)
- CoreData (shared container)

**Limitation:** No real-time updates while keyboard is active (picks up changes on next launch)

## With Full Access 🔓

**Reactive updates:**
- SwiftData `@Query` updates views in real-time
- Changes in main app instantly reflect in keyboard

**Darwin notifications:**
- CFNotificationCenter cross-process events
- Bi-directional app ↔ keyboard communication

**Network:**
- Required for any network requests

## Tested

✅ SwiftData shared container without Full Access → works, but not reactive  
✅ SwiftData `@Query` with Full Access → real-time updates work  
✅ Darwin notifications with Full Access → work on physical device

