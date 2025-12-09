# 📖 Good to Know

## SwiftData Preview Crashes

When changing SwiftData model schemas (adding/removing properties, models, or relationships), Xcode Previews may crash with:

```
Could not create ModelContainer: SwiftDataError(_error: SwiftData.SwiftDataError._Error.loadIssueModelContainer, _explanation: nil)
```

**Solution:** Restart Xcode - This clears the cached schema.

**Why:** Xcode's preview system caches the schema between updates. Even with `isStoredInMemoryOnly: true`, schema changes require a fresh container but cached schema conflicts.
