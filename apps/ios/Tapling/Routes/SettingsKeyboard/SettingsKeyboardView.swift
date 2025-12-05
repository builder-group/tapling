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
    @QuerySingleton private var keyboardSettings: KeyboardSettings
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @FocusState private var isTextFieldFocused: Bool
    @State private var showKeyboard = true
    @State private var hasFullAccess = false

    private enum FocusDelay {
        static let toggle: Double = 0.1
        static let initial: Double = 0.5
    }

    private var bannerMessage: Text {
        let keyboardIcon = Text(Image(systemName: "keyboard.fill"))
            .foregroundStyle(.blue)
        return Text(
            "Full Keyboard Access required for live preview. Settings work without it—just reopen (\(keyboardIcon)) to see changes."
        )
    }

    private var debugModeBinding: Binding<Bool> {
        Binding(
            get: { keyboardSettings.debug },
            set: { newValue in
                keyboardSettings.debug = newValue
                try? modelContext.save()
            }
        )
    }

    // MARK: - UI

    var body: some View {
        ZStack {
            settingsForm
            if showKeyboard {
                keyboardTriggerTextField
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                checkFullAccess()
                setKeyboard(true)
            } else {
                setKeyboard(false)
            }
        }
        .onAppear {
            checkFullAccess()
            if showKeyboard {
                setKeyboard(true)
            }
        }
        .onDisappear {
            setKeyboard(false)
        }
        .onChange(of: isTextFieldFocused) { oldValue, newValue in
            // Sync state when keyboard is dismissed by user (return/done button)
            if !newValue && showKeyboard {
                setKeyboard(false)
            }
        }
    }

    private var settingsForm: some View {
        VStack(spacing: 0) {
            if !hasFullAccess {
                BannerView(
                    icon: "exclamationmark.triangle.fill",
                    message: bannerMessage,
                    style: .warning
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .background(Color(.systemGroupedBackground))
            }

            Form {
                Section {
                    Toggle("Debug Mode", isOn: debugModeBinding)
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

    // MARK: - Actions

    private func setKeyboard(_ enabled: Bool) {
        showKeyboard = enabled

        if enabled {
            enablePreviewMode()
            focusTextField(delay: FocusDelay.toggle)
        } else {
            disablePreviewMode()
            isTextFieldFocused = false
        }
    }

    private func toggleKeyboard() {
        setKeyboard(!showKeyboard)
    }

    private func focusTextField(delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            isTextFieldFocused = true
        }
    }

    private func enablePreviewMode() {
        guard !keyboardSettings.isPreviewMode else { return }
        keyboardSettings.isPreviewMode = true
        try? modelContext.save()
    }

    private func disablePreviewMode() {
        guard keyboardSettings.isPreviewMode else { return }
        keyboardSettings.isPreviewMode = false
        try? modelContext.save()
    }

    private func checkFullAccess() {
        let status = KeyboardStatusContext(
            bundleId: "com.buildergroup.Tapling.Keyboard"
        )
        status.refresh()
        hasFullAccess = status.isFullAccessEnabled
    }
}

#Preview {
    NavigationStack {
        SettingsKeyboardView()
            .previewDataContainer()
    }
}
