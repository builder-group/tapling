# SwiftUI View Structure Convention

Clear, consistent structure for organizing SwiftUI views.

**Core Principle:** Separate UI (what it looks like) from Actions (how it behaves).

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
    // Variables (State, Environment, Computed, Bindings - no MARK)
    @State private var isEnabled = false
    @QuerySingleton private var settings: Settings
    private let registry = CollectibleRegistry.shared
    
    private var computedValue: Int { 42 }
    private var isEnabledBinding: Binding<Bool> {
        Binding(
            get: { settings.isEnabled },
            set: { settings.isEnabled = $0 }
        )
    }

    // MARK: - UI

    var body: some View {
        Form {
            headerSection
        }
    }

    private var headerSection: some View { }
    private var buttonToolbar: some View { }

    // MARK: - Actions

    private func toggleFeature() { }
    private func formatDate(_ date: Date) -> String { }
    private func isUnlocked(id: String) -> Bool { }
}

private struct HelperView: View {
    var body: some View { }
}
```

**3-Layer Structure:**
1. **Variables** (top, no MARK) - State, Environment, Computed, Bindings
2. **UI** (middle, MARK) - body + all View components
3. **Actions** (bottom, MARK) - All functions (mutating and pure helpers)

**When to use MARK:**
- Use for medium+ views to separate UI from Actions
- Skip for small views (<5 components and <3 actions)
- **Never add more than these 2 MARKs** - if you need feature-based sections (e.g., "Search UI", "Filter UI"), split the view into separate components or extract a ViewModel instead

## 📋 Naming

**Components:** Descriptive, what it represents

```swift
✅ headerSection, feedbackButton, settingsForm
❌ view1, thing, header
```

**Variables:** State, Environment, Computed properties, Bindings (all at top, no MARK)

```swift
@State private var isEnabled = false
@Query private var items: [Item]
private var computedValue: Int { 42 }
private var isEnabledBinding: Binding<Bool> { }
```

**Actions:** All functions (mutating and pure helpers)

```swift
✅ toggleKeyboard(), saveSettings(), openMail()  // Mutate state
✅ formatDate(_:), isUnlocked(id:), sortedItems(for:)  // Pure helpers
❌ keyboard(), settings(), mail()
```

## 🎯 Example

```swift
struct SettingsView: View {
    // Variables
    @State private var isEnabled = false
    @QuerySingleton private var settings: Settings

    private var isEnabledBinding: Binding<Bool> {
        Binding(
            get: { settings.isEnabled },
            set: { settings.isEnabled = $0 }
        )
    }

    // MARK: - UI

    var body: some View {
        Form {
            headerSection
        }
    }

    private var headerSection: some View {
        Section {
            Toggle("Enabled", isOn: isEnabledBinding)
        }
    }

    // MARK: - Actions

    private func saveSettings() {
        try? modelContext.save()
    }

    private func isFeatureEnabled() -> Bool {
        settings.isEnabled
    }
}
```

## 🚨 When to Refactor

If your view needs more organization than 2 MARKs:

```swift
// ❌ Too complex - needs refactoring
struct ComplexView: View {
    // MARK: - UI
    // MARK: - Search Components  ← Extra MARK = code smell
    // MARK: - Filter Components   ← Extra MARK = code smell
    // MARK: - Actions
}

// ✅ Split into focused views
struct ComplexView: View {
    var body: some View {
        VStack {
            SearchBarView()
            FilterSectionView()
            ContentListView()
        }
    }
}

// ✅ Or extract ViewModel for heavy logic
struct ComplexView: View {
    @StateObject private var viewModel = ComplexViewModel()
    
    // MARK: - UI
    var body: some View { }
    
    // MARK: - Actions
    private func handleAction() { viewModel.handle() }
}
```

---

See: [iOS Folder Structure](./ios-folder-structure.md)