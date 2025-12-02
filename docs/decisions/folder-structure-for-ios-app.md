# Folder Structure for iOS App

## Project Structure

```
Sources/
├─ Environment/           # Static shared instances, singleton-like objects, and environment configs
│  ├─ App+Extension.swift # Example: extension adding shared instance or configuration
│  ├─ Configs/             # Static environment configuration values (API keys, feature flags, URLs, etc.)
│  │  ├─ AppConfig.swift
│  │  └─ OtherConfigs/
│  └─ OtherShared/       # Any other singletons or global static objects

├─ Lib/                  # General reusable logic and utilities

├─ Views/                # Reusable UI components
│  ├─ Buttons/           # Buttons used across the app
│  ├─ Cards/             # Card components
│  └─ OtherComponents/   # Other shared UI elements

├─ Features/             # Domain-specific flows (multiple screens related to one domain)
│  ├─ Auth/              # Example feature: user login, signup, profile
│  │  ├─ Views/          # Screens related to authentication
│  │  ├─ Lib/            # Feature-specific helpers, view models, logic
│  │  └─ Environment/    # Feature-specific configuration if needed
│  └─ ShoppingCart/      # Example feature: cart flow
│     ├─ Views/
│     ├─ Lib/
│     └─ Environment/

├─ Routes/                  # Single screens (self-contained units)
│  ├─ ProductDetail/        # Example: product detail screen
│  │  ├─ Views/             # Screen-specific views
│  │  ├─ Lib/               # Screen-specific logic, view models
│  │  └─ Environment/       # Optional screen-specific config
│  └─ Settings/             # Example: settings screen
│     ├─ Views/
│     ├─ Lib/
│     └─ Environment/
```

## Key Principles

1. **Environment:** Holds static/shared instances, singleton-like objects, and environment-specific configuration values. These exist only once globally.
2. **Configs:** Part of Environment; stores application- or feature-wide static configuration values (API keys, feature flags, URLs).
3. **Lib:** Generic, reusable helpers and business logic.
4. **Views:** Shared UI components used across multiple features or screens.
5. **Features:** Multi-screen, domain-specific flows; contains its own Views, Lib, and Configs.
6. **Routes:** Single screens; screen-specific Views, Lib, and Configs live here.
7. **Target membership:** Configure at the file level in Xcode.

## Naming Conventions

* **Extension Files:** Use `+Category` suffix for extension files (e.g., `KeyboardApp+Extension.swift`, `UIView+Helpers.swift`). The `+` indicates it's an extension file, helping organize multiple extensions of the same type.
* **Static instance:** `App.shared`
* **SwiftUI Views:** Always use `View` suffix (e.g., `TaplingView`, `AutocompleteToolbarView`).
* **Shared Files:** No suffix/prefix needed. Manage sharing via Xcode target membership. Name files by what they do, not where they're used.
* **Feature-specific logic:** Keep inside feature folder unless needed globally.
* **Screen-specific logic:** Keep inside screen/route folder.
