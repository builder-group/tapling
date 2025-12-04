# SwiftUI View Structure Convention

Clear, consistent structure for organizing SwiftUI views.

## 📁 When to Inline vs. Separate

```swift
// ✅ Inline computed property (use for most UI)
private var headerSection: some View { }

// ✅ Private struct at bottom (helper for this view only)
private struct StatusRow: View { }

// ✅ Separate file (reusable across multiple views)
struct ActionRowView: View { }  // → /Views/ActionRowView.swift
```

## 🏗️ View Structure

Sections in order (omit if empty):

```swift
struct MyView: View {
    // State & Environment
    @State private var isEnabled = false
    @QuerySingleton private var settings: Settings

    private enum Layout {
        static let spacing: CGFloat = 16
    }

    var body: some View {
        Form {
            headerSection
        }
    }

    // MARK: - Components

    private var headerSection: some View { }
    private var buttonToolbar: some View { }

    // MARK: - Bindings

    private var isEnabledBinding: Binding<Bool> { }

    // MARK: - Actions

    private func toggleFeature() { }
}

private struct HelperView: View {
    var body: some View { }
}
```

**Only use MARK for:** Components, Bindings, Actions

## 📋 Naming

**Components:** Descriptive, what it represents

```swift
✅ headerSection, feedbackButton, settingsForm
❌ view1, thing, header
```

**Bindings:** Always end with "Binding"

```swift
✅ debugModeBinding, scaleBinding
❌ debugMode, scale
```

**Actions:** Verb-based

```swift
✅ toggleKeyboard(), saveSettings(), openMail()
❌ keyboard(), settings(), mail()
```

## 🎯 Example

```swift
struct SettingsView: View {
    @State private var isEnabled = false
    @QuerySingleton private var settings: Settings

    var body: some View {
        Form {
            headerSection
        }
    }

    // MARK: - Components

    private var headerSection: some View {
        Section {
            Toggle("Enabled", isOn: isEnabledBinding)
        }
    }

    // MARK: - Bindings

    private var isEnabledBinding: Binding<Bool> {
        Binding(
            get: { settings.isEnabled },
            set: { settings.isEnabled = $0 }
        )
    }

    // MARK: - Actions

    private func saveSettings() {
        try? modelContext.save()
    }
}
```

---

See: [iOS Folder Structure](./ios-folder-structure.md)
