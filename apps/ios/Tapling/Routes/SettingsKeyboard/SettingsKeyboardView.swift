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

    var body: some View {
        ZStack {
            settingsForm
            if showKeyboard {
                keyboardTriggerTextField
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase != .active {
                setKeyboard(false)
            } else {
                checkFullAccess()
                setKeyboard(true)
            }
        }
        .onAppear {
            checkFullAccess()
        }
        .onDisappear {
            setKeyboard(false)
        }
    }

    // MARK: - Components

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

    private var bannerMessage: Text {
        Text(
            "Full Access required for live preview. Settings work without it—just reopen ("
        )
            + Text(Image(systemName: "keyboard.fill")).foregroundStyle(.blue)
            + Text(") to see changes.")
    }

    // MARK: - Actions

    private func setKeyboard(_ enabled: Bool) {
        guard showKeyboard != enabled else { return }
        
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
        keyboardSettings.isPreviewMode = true
        try? modelContext.save()
    }

    private func disablePreviewMode() {
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
            .modelContainer(previewContainer)
    }
}

@MainActor
private var previewContainer: ModelContainer {
    let schema = Schema([TaplingSettings.self, KeyboardSettings.self])
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: schema,
        configurations: [configuration]
    )

    // Initialize singletons
    let context = container.mainContext
    _ = TaplingSettings.instance(with: context)
    _ = KeyboardSettings.instance(with: context)

    return container
}
