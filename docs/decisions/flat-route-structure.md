# Flat Route Structure

## Decision

Use flat route folders with hierarchical names (Remix-style) instead of nested folder structure.

## Rationale

### Structure Comparison

**Flat (chosen):**

```
Routes/
├── Settings/SettingsView.swift
├── SettingsKeyboard/SettingsKeyboardView.swift
└── SettingsAbout/SettingsAboutView.swift
```

**Nested (alternative):**

```
Routes/
└── Settings/
    ├── SettingsView.swift
    ├── Keyboard/
    │   └── SettingsKeyboardView.swift
    └── About/
        └── SettingsAboutView.swift
```

### File Name = Full Path

With flat structure, the file name immediately tells you the full navigation path:

- `SettingsKeyboardView` = Settings → Keyboard
- `SettingsAboutLicenseView` = Settings → About → License

No need to navigate through multiple folders to understand the hierarchy.

### All Routes at Same Level

In Xcode sidebar, all routes appear at the same level and are alphabetically sorted. Makes it easy to:

- Scan all available routes
- Find a specific route quickly
- See the app's navigation structure at a glance

### Less Clicking in Xcode

No need to expand/collapse nested folders to find a route. All routes are immediately visible.

### iOS Navigation is Flat

Unlike web URLs, iOS `NavigationStack` doesn't enforce a folder hierarchy. The navigation structure is defined in code, not folders. Flat folders match this reality.

## Trade-offs

### Folder Name Prefixes

Route folders have name prefixes to show hierarchy (`SettingsKeyboard` vs just `Keyboard`). This is verbose but provides clarity.

Alternative considered: Use nested folders with shorter names. Rejected because it adds navigation friction in Xcode for minimal benefit.

---

See: [iOS Folder Structure Convention](../conventions/ios-folder-structure.md)
