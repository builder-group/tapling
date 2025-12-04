//
//  SettingsKeyboardView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftData
import SwiftUI

struct SettingsKeyboardView: View {
    @QuerySingleton private var keyboardSettings: KeyboardSettings
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isTextFieldFocused: Bool
    @State private var showKeyboard = true

    private enum FocusDelay {
        static let toggle: Double = 0.1
        static let initial: Double = 0.5
    }

    var body: some View {
        ZStack {
            settingsForm
            if showKeyboard {
                keyboardTriggerTextField
            }
        }
    }

    // MARK: - Components

    private var settingsForm: some View {
        Form {
            Section {
                Toggle("Debug Mode", isOn: debugModeBinding)
            } footer: {
                Text("Changes will be reflected in the keyboard immediately.")
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
            toggleKeyboard()
        } label: {
            Image(systemName: showKeyboard ? "keyboard.fill" : "keyboard")
                .foregroundStyle(showKeyboard ? .blue : .secondary)
        }
    }

    private var keyboardTriggerTextField: some View {
        TextField("", text: .constant(""))
            .frame(width: 0, height: 0)
            .opacity(0)
            .focused($isTextFieldFocused)
            .onAppear {
                focusTextField(delay: FocusDelay.initial)
            }
    }

    // MARK: - Bindings

    private var debugModeBinding: Binding<Bool> {
        Binding(
            get: { keyboardSettings.debug },
            set: { newValue in
                keyboardSettings.debug = newValue
                try? modelContext.save()
            }
        )
    }

    // MARK: - Actions

    private func toggleKeyboard() {
        showKeyboard.toggle()
        if showKeyboard {
            focusTextField(delay: FocusDelay.toggle)
        } else {
            isTextFieldFocused = false
        }
    }

    private func focusTextField(delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            isTextFieldFocused = true
        }
    }
}

#Preview {
    NavigationStack {
        SettingsKeyboardView()
            .modelContainer(DataContainer.shared.modelContainer)
    }
}
