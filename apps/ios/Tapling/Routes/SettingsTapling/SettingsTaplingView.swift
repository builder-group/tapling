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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase

    @QuerySingleton private var taplingSettings: KeyboardTaplingSettings
    @QuerySingleton private var keyboardSettings: KeyboardSettings

    @FocusState private var isTextFieldFocused: Bool
    @State private var hasFullAccess = true

    private enum SliderRange {
        static let scale = 0.5...3.0
        static let scaleStep = 0.1
        static let offset = -20.0...20.0
        static let offsetStep = 0.5
    }

    private var previewBannerMessage: Text {
        let keyboardIcon = Text(Image(systemName: "keyboard.fill"))
            .foregroundStyle(.blue)
        return Text(
            "Full Keyboard Access required for live preview. Settings work without it—just reopen (\(keyboardIcon)) to see changes."
        )
    }

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

    private var trackSessionsBinding: Binding<Bool> {
        Binding(
            get: { hasFullAccess && taplingSettings.trackSessions },
            set: { newValue in
                guard hasFullAccess else { return }
                taplingSettings.trackSessions = newValue
                try? modelContext.save()
            }
        )
    }

    // MARK: - UI

    var body: some View {
        ZStack {
            settingsForm
            keyboardTriggerTextField
        }
        .onDisappear {
            disablePreviewMode()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active && isTextFieldFocused {
                enablePreviewMode()
            } else {
                disablePreviewMode()
            }
        }
        .onChange(of: isTextFieldFocused) { oldValue, newValue in
            if newValue {
                checkFullAccess()
                enablePreviewMode()
            } else {
                disablePreviewMode()
            }
        }
        .onAppear {
            checkFullAccess()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                checkFullAccess()
            }
        }
    }

    private var settingsForm: some View {
        VStack(spacing: 0) {
            if !hasFullAccess && isTextFieldFocused {
                BannerView(
                    icon: "exclamationmark.triangle.fill",
                    message: previewBannerMessage,
                    style: .warning
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .background(Color(.systemGroupedBackground))
            }

            Form {
                Section("POSITION") {
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

                Section("EARNINGS") {
                    Toggle("Enable Earnings", isOn: trackSessionsBinding)
                        .disabled(!hasFullAccess)

                    if !hasFullAccess {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                                .font(.caption)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Full Access required to earn keycaps")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.primary)

                                Text(
                                    "We only count keystrokes—never read what you type."
                                )
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    } else {
                        Text(
                            "Earn keycaps by typing. We only count keystrokes—never read what you type."
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
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

    // MARK: - Actions

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
        hasFullAccess = KeyboardStatusContext.hasFullAccess()
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
            .previewDataContainer()
    }
}
