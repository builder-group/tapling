//
//  SettingsView.swift
//  Tapling
//
//  Created by Benno on 03.12.25.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @State private var isKeyboardEnabled = false
    @State private var isFullAccessEnabled = false

    var body: some View {
        NavigationStack {
            Form {
                keyboardStatusSection
                settingsSection
                appSection
            }
            .navigationTitle("Settings")
            .onAppear {
                checkKeyboardStatus()
            }
        }
    }

    // MARK: - Components

    private var keyboardStatusSection: some View {
        Section("KEYBOARD") {
            StatusRowView(
                title: "Keyboard Enabled",
                isEnabled: isKeyboardEnabled,
                action: openSystemSettings
            )

            StatusRowView(
                title: "Full Access Enabled",
                isEnabled: isFullAccessEnabled,
                action: openSystemSettings
            )
        }
    }

    private var settingsSection: some View {
        Section("SETTINGS") {
            NavigationLink {
                SettingsKeyboardView()
            } label: {
                Label("Keyboard", systemImage: "keyboard")
            }

            NavigationLink {
                SettingsTaplingView()
            } label: {
                Label("Tapling", systemImage: "face.smiling")
            }
        }
    }

    private var appSection: some View {
        Section("APP") {
            NavigationLink {
                SettingsGettingStartedView()
            } label: {
                Label("Getting Started", systemImage: "lightbulb")
            }

            NavigationLink {
                SettingsAboutView()
            } label: {
                Label("About", systemImage: "info.circle")
            }
        }
    }

    // MARK: - Actions

    private func checkKeyboardStatus() {
        isKeyboardEnabled = checkIsKeyboardEnabled()
        isFullAccessEnabled = checkIsFullAccessEnabled()
    }

    private func checkIsKeyboardEnabled() -> Bool {
        guard
            let keyboards = UserDefaults.standard.object(
                forKey: "AppleKeyboards"
            ) as? [String]
        else {
            return false
        }
        return keyboards.contains { $0.contains("Tapling") }
    }

    private func checkIsFullAccessEnabled() -> Bool {
        UIPasteboard.general.hasStrings || UIPasteboard.general.hasImages
    }

    private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url)
    }
}

private struct StatusRowView: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(
                    systemName: isEnabled
                        ? "checkmark.circle.fill"
                        : "exclamationmark.circle.fill"
                )
                .foregroundStyle(isEnabled ? .green : .yellow)
                .font(.title3)

                Text(title)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(DataContainer.shared.modelContainer)
}
