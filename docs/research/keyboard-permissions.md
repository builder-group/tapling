# Keyboard Extension Permissions

What works with/without Full Access.

## Without Full Access ❌

**App Groups (read):**

- FileManager (shared container) - **Read-only**
- SwiftData (shared container) - **Read-only**
- CoreData (shared container) - **Read-only**
- UserDefaults (shared suite) - **Read-only**

**Limitation:** Cannot write to shared containers. All writes require Full Access. No real-time updates while keyboard is active (picks up changes on next launch).

**Read access works:** Keyboard extension can read data written by main app (SwiftData, FileManager, UserDefaults all readable).

## With Full Access 🔓

**Reactive updates:**

- SwiftData `@Query` updates views in real-time
- Changes in main app instantly reflect in keyboard

**Darwin notifications:**

- CFNotificationCenter cross-process events
- Bi-directional app ↔ keyboard communication

**Network:**

- Required for any network requests

**File writes:**
- FileManager writes to App Group containers ✅
- SwiftData writes ✅

## Tested

❌ FileManager writes without Full Access → Operation not permitted  
❌ SwiftData writes without Full Access → Read-only  
❌ UserDefaults writes without Full Access → CFPrefs restriction  
✅ Read access without Full Access → Works (SwiftData, FileManager, UserDefaults)  
✅ FileManager writes with Full Access → Works  
✅ SwiftData writes with Full Access → Works  
✅ SwiftData `@Query` with Full Access → real-time updates work  
✅ Darwin notifications with Full Access → work on physical device
