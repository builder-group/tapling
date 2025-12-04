//
//  SettingsView.swift
//  Tapling
//
//  Created by Benno on 03.12.25.
//

import KeyboardKit
import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var isKeyboardEnabled = false
    @State private var isFullAccessEnabled = false

    private let keyboardStatus = KeyboardStatusContext(
        bundleId: "com.buildergroup.Tapling.Keyboard"
    )

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
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    checkKeyboardStatus()
                }
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
        keyboardStatus.refresh()
        isKeyboardEnabled = keyboardStatus.isKeyboardEnabled
        isFullAccessEnabled =
            isKeyboardEnabled && keyboardStatus.isFullAccessEnabled
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
