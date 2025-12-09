# iOS Folder Structure Convention

Scalable folder structure for iOS/SwiftUI applications.

## 📁 Project Structure

```
Sources/
├── Environment/              # Static shared instances & global configuration
│   ├── DataContainer.swift   # SwiftData model container
│   ├── App+Extension.swift   # App/Framework extensions with shared instances
│   ├── Configs/              # Static configuration values
│   │   ├── AppConfig.swift   # App-wide config (URLs, emails, version)
│   │   └── TaplingConfig.swift
│   └── Models/               # Data models (SwiftData, etc.)
│       ├── TaplingSettings.swift
│       └── KeyboardSettings.swift
│
├── Lib/                      # General reusable utilities
│   ├── StringHelpers.swift   # String utilities
│   └── DateHelpers.swift     # Date utilities
│
├── Views/                    # Reusable UI components
│   ├── TaplingView.swift     # Used across multiple screens
│   ├── ActionRowView.swift   # Generic action row
│   ├── LinkRowView.swift     # Generic link row
│   └── StepView.swift        # Reusable step component
│
├── Features/                 # Domain-specific components & logic
│   └── Auth/                 # Example: authentication domain
│       ├── Views/            # Domain UI (LoginFormView, SignupFormView)
│       ├── Lib/              # Domain logic (AuthService, validators)
│       └── Environment/      # Domain config/models
│
└── Routes/                   # App entry points (actual screens)
    ├── Login/
    │   └── LoginView.swift   # Uses Auth feature components
    ├── Signup/
    │   └── SignupView.swift  # Uses Auth feature components
    ├── Settings/
    │   └── SettingsView.swift
    └── SettingsKeyboard/
        └── SettingsKeyboardView.swift
```

## 🎯 Folder Purposes

### **Environment/**

Global singletons and configuration (exist once per app).

**Use for:** SwiftData containers, app-wide config (URLs, API keys), global models, framework extensions

**Avoid:** Feature-specific logic, screen config, UI components

### **Lib/**

Pure utility functions independent of UI/features.

**Use for:** String formatters, date helpers, math utilities, algorithms

**Avoid:** UI components, feature-specific logic

### **Views/**

Reusable UI components used across multiple screens.

**Use for:** Generic buttons/rows/cards, components used 2+ times

**Avoid:** Screen-specific or one-off components

### **Features/**

Domain-specific components and logic used by routes.

**Contains:** Domain UI components (not full screens), domain logic, domain models

**Think:** Feature = reusable domain library. Routes compose features together.

**Example:** `Auth` feature has `LoginFormView`, `SignupFormView` → Used by `Login` and `Signup` routes

### **Routes/**

App entry points - the actual screens users navigate to.

**Purpose:** Routes compose Features and Views together into full screens

**Structure:** Flat folders with hierarchical names, one main View per folder

```
Routes/
├── Login/LoginView.swift              # Uses Auth feature
├── Signup/SignupView.swift            # Uses Auth feature
├── Settings/SettingsView.swift
└── SettingsKeyboard/SettingsKeyboardView.swift
```

## 📝 Naming

**Files:**

```swift
✅ MyScreenView.swift, ActionRowView.swift
✅ App+Extension.swift, String+Helpers.swift
✅ AppConfig.swift, AuthConfig.swift
```

**Folders:**

```swift
✅ Login/, SettingsKeyboard/           (Routes)
✅ Auth/, Payment/                      (Features)
✅ Environment/, Views/, Lib/           (Organization)
```

## 💡 Mental Model

**Flow:** Route → Features → Views

```
LoginView (Route)
  └─ Uses LoginFormView (Auth Feature)
      └─ Uses ActionRowView (Generic View)

SettingsKeyboardView (Route)
  └─ Uses directly generic Views
```

**When to use what:**

- **Route:** "I want to change the Login screen" → `Routes/Login/`
- **Feature:** "I need auth logic/UI" → `Features/Auth/`
- **View:** "I need a generic button" → `Views/`

## 🔀 Route Naming

**Flat + Hierarchical** (file name = path):

```
✅ SettingsKeyboardView = Settings → Keyboard
✅ All routes at same level, alphabetically sorted
❌ Don't nest: Routes/Settings/Keyboard/
```

## ✅ Good vs Bad

```
✅ Routes/Login/LoginView.swift
✅ Features/Auth/Views/LoginFormView.swift
✅ Views/ActionRowView.swift

❌ Features/Auth/LoginView.swift (routes, not features)
❌ Routes/Login/Views/ (don't nest Views folder)
❌ Views/Auth/AuthButton.swift (don't prefix by domain)
```

## 🎯 Quick Reference

| What              | Where                  | Example               |
| ----------------- | ---------------------- | --------------------- |
| App screen        | `Routes/`              | `LoginView.swift`     |
| Domain components | `Features/Auth/Views/` | `LoginFormView.swift` |
| Generic UI        | `Views/`               | `ActionRowView.swift` |
| Global config     | `Environment/Configs/` | `AppConfig.swift`     |
| Utilities         | `Lib/`                 | `StringHelpers.swift` |

---

**Related:**

- [SwiftUI View Structure](./swiftui-view-structure.md) - Code structure within views
- [Flat Route Structure Decision](../decisions/flat-route-structure.md) - Why flat vs nested
