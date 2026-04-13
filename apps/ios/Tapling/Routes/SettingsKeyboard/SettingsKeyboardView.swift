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

    private var emojiPickerEnabledBinding: Binding<Bool> {
        Binding(
            get: { keyboardSettings.emojiPickerEnabled },
            set: { newValue in
                keyboardSettings.emojiPickerEnabled = newValue
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
        VStack(spacing: 0) {
            BannerView(
                icon: "info.circle.fill",
                message: autocompleteInfoText,
                style: .info
            )
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .background(Color(.systemGroupedBackground))

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
                    Toggle("Emoji Picker", isOn: emojiPickerEnabledBinding)
                }
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

    private var autocompleteInfoText: Text {
        var string = AttributedString(
            "Autocomplete and autocorrect are basic. A proper upgrade requires a third-party SDK that costs $500/month, which is not viable for a free app. If you would pay for Tapling, let us know."
        )
        if let range = string.range(of: "let us know"),
            let url = AppConfig.mailtoURL(subject: "I'd pay for Tapling")
        {
            string[range].link = url
        }
        return Text(string)
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
