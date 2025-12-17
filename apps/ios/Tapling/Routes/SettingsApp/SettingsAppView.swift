//
//  SettingsAppView.swift
//  Tapling
//
//  Created by Benno on 07.12.25.
//

import SwiftData
import SwiftUI

struct SettingsAppView: View {
    @Environment(\.modelContext) private var modelContext

    @QuerySingleton private var appSettings: AppSettings
    @QuerySingleton private var keyboardSettings: KeyboardSettings

    private var debugModeBinding: Binding<Bool> {
        Binding(
            get: { appSettings.debug },
            set: { newValue in
                appSettings.debug = newValue
                if !newValue {
                    keyboardSettings.debug = false
                }
                try? modelContext.save()
            }
        )
    }

    // MARK: - UI

    var body: some View {
        Form {
            Section("GENERAL") {
                Toggle("Debug Mode", isOn: debugModeBinding)
            }
        }
        .navigationTitle("App")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsAppView()
            .previewDataContainer()
    }
}
