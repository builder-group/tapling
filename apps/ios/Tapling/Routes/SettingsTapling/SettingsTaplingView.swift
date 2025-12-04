//
//  SettingsTaplingView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import KeyboardKit
import SwiftData
import SwiftUI

struct SettingsTaplingView: View {
    @QuerySingleton private var taplingSettings: TaplingSettings
    @QuerySingleton private var keyboardSettings: KeyboardSettings
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @FocusState private var isTextFieldFocused: Bool
    @State private var showKeyboard = true
    @State private var hasFullAccess = false

    private enum SliderRange {
        static let scale = 0.5...3.0
        static let scaleStep = 0.1
        static let offset = -20.0...20.0
        static let offsetStep = 0.5
    }

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
                    LabeledSliderView(
                        label: "Scale",
                        value: taplingSettings.userScale,
                        format: "%.2f",
                        binding: scaleBinding,
                        range: SliderRange.scale,
                        step: SliderRange.scaleStep
                    )

                    LabeledSliderView(
                        label: "Bottom Offset",
                        value: taplingSettings.userBottomOffset,
                        format: "%.1f",
                        binding: offsetBinding,
                        range: SliderRange.offset,
                        step: SliderRange.offsetStep
                    )
                }
            }
        }
        .navigationTitle("Tapling")
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

    private var scaleBinding: Binding<Double> {
        Binding(
            get: { taplingSettings.userScale },
            set: { newValue in
                taplingSettings.userScale = newValue
                try? modelContext.save()
            }
        )
    }

    private var offsetBinding: Binding<Double> {
        Binding(
            get: { taplingSettings.userBottomOffset },
            set: { newValue in
                taplingSettings.userBottomOffset = newValue
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

private struct LabeledSliderView: View {
    let label: String
    let value: Double
    let format: String
    let binding: Binding<Double>
    let range: ClosedRange<Double>
    let step: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(label): \(value, specifier: format)")
                .font(.caption)
                .foregroundStyle(.secondary)

            Slider(
                value: binding,
                in: range,
                step: step
            )
        }
    }
}

#Preview {
    NavigationStack {
        SettingsTaplingView()
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
