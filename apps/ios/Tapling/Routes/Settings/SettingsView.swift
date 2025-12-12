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
    @QuerySingleton private var appSettings: AppSettings

    // MARK: - UI

    var body: some View {
        NavigationStack {
            Form {
                keyboardStatusSection
                settingsSection
                appSection
            }
            .navigationTitle("Settings")
        }
    }

    private var keyboardStatusSection: some View {
        Section("KEYBOARD") {
            KeyboardStatusView(style: .form)
        }
    }

    private var settingsSection: some View {
        Section("SETTINGS") {
            NavigationLink {
                SettingsAppView()
            } label: {
                Label("App", systemImage: "app.badge")
            }

            NavigationLink {
                SettingsKeyboardView()
            } label: {
                Label("Keyboard", systemImage: "keyboard")
            }

            NavigationLink {
                SettingsTaplingView()
            } label: {
                Label("Tapling", systemImage: "pawprint")
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

            NavigationLink {
                SettingsCreditsView()
            } label: {
                Label("Credits", systemImage: "heart")
            }

            if appSettings.debug {
                NavigationLink {
                    SettingsDebugView()
                } label: {
                    Label("Debug", systemImage: "ladybug")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .previewDataContainer()
}
