//
//  SettingsTaplingView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftData
import SwiftUI

struct SettingsTaplingView: View {
    @QuerySingleton private var taplingSettings: TaplingSettings
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isTextFieldFocused: Bool
    @State private var showKeyboard = true

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
    }

    // MARK: - Components

    private var settingsForm: some View {
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
            } footer: {
                Text("Changes will be reflected in the keyboard immediately.")
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
            .modelContainer(DataContainer.shared.modelContainer)
    }
}
