//
//  SettingsKeyboardView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import KeyboardKit
import SwiftData
import SwiftUI

struct SettingsKeyboardView: View {
    @Environment(\.modelContext) private var modelContext

    @QuerySingleton private var keyboardSettings: KeyboardSettings

    @FocusState private var isTextFieldFocused: Bool

    private var debugModeBinding: Binding<Bool> {
        Binding(
            get: { keyboardSettings.debug },
            set: { newValue in
                keyboardSettings.debug = newValue
                try? modelContext.save()
            }
        )
    }

    private var autocompleteEnabledBinding: Binding<Bool> {
        Binding(
            get: { keyboardSettings.autocompleteEnabled },
            set: { newValue in
                keyboardSettings.autocompleteEnabled = newValue
                keyboardSettings.autocorrectEnabled = newValue
                try? modelContext.save()
            }
        )
    }

    private var autocorrectEnabledBinding: Binding<Bool> {
        Binding(
            get: { keyboardSettings.autocorrectEnabled },
            set: { newValue in
                keyboardSettings.autocorrectEnabled = newValue
                try? modelContext.save()
            }
        )
    }

    private var currentLanguageName: String {
        keyboardSettings.language.displayName
    }

    // MARK: - UI

    var body: some View {
        ZStack {
            settingsForm
            keyboardTriggerTextField
        }
    }

    private var settingsForm: some View {
        Form {
            Section("GENERAL") {
                NavigationLink {
                    SettingsKeyboardLanguageView()
                } label: {
                    HStack {
                        Text("Language")
                        Spacer()
                        Text(currentLanguageName)
                            .foregroundStyle(.secondary)
                    }
                }
                Toggle("Autocomplete", isOn: autocompleteEnabledBinding)
                if keyboardSettings.autocompleteEnabled {
                    Toggle("Autocorrect", isOn: autocorrectEnabledBinding)
                }
            }

            Section("DEVELOPER") {
                Toggle("Debug Mode", isOn: debugModeBinding)
            }
        }
        .navigationTitle("Keyboard")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                keyboardToggleButton
            }
        }
    }

    private var keyboardToggleButton: some View {
        Button {
            isTextFieldFocused.toggle()
        } label: {
            Image(systemName: isTextFieldFocused ? "keyboard.fill" : "keyboard")
                .foregroundStyle(isTextFieldFocused ? .blue : .secondary)
        }
    }

    private var keyboardTriggerTextField: some View {
        TextField("", text: .constant(""))
            .frame(width: 0, height: 0)
            .opacity(0)
            .focused($isTextFieldFocused)
    }
}

#Preview {
    NavigationStack {
        SettingsKeyboardView()
            .previewDataContainer()
    }
}
