//
//  SettingsView.swift
//  Tapling
//
//  Created by Benno on 03.12.25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @QuerySingleton private var taplingSettings: TaplingSettings
    @QuerySingleton private var keyboardSettings: KeyboardSettings
    @Environment(\.modelContext) private var modelContext

    @State private var testText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Test Keyboard") {
                    TextField("Type here to test keyboard...", text: $testText)
                        .textFieldStyle(.roundedBorder)
                }

                Section("Tapling") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Scale: \(taplingSettings.userScale, specifier: "%.2f")")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Slider(
                            value: Binding(
                                get: { taplingSettings.userScale },
                                set: { newValue in
                                    taplingSettings.userScale = newValue
                                    try? modelContext.save()
                                }
                            ),
                            in: 0.5...3.0,
                            step: 0.1
                        )
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bottom Offset: \(taplingSettings.userBottomOffset, specifier: "%.1f")")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Slider(
                            value: Binding(
                                get: { taplingSettings.userBottomOffset },
                                set: { newValue in
                                    taplingSettings.userBottomOffset = newValue
                                    try? modelContext.save()
                                }
                            ),
                            in: -20...20,
                            step: 0.5
                        )
                    }
                }

                Section("Keyboard") {
                    Toggle(
                        "Debug Mode",
                        isOn: Binding(
                            get: { keyboardSettings.debug },
                            set: { newValue in
                                keyboardSettings.debug = newValue
                                try? modelContext.save()
                            }
                        )
                    )
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(DataContainer.shared.modelContainer)
}

