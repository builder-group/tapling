//
//  SettingsDebugView.swift
//  Tapling
//
//  Created by Benno on 07.12.25.
//

import SwiftData
import SwiftUI

struct SettingsDebugView: View {

    var body: some View {
        Form {
            Section("DEBUG") {
                NavigationLink {
                    SettingsDebugSessionsView()
                } label: {
                    Label("Sessions", systemImage: "keyboard")
                }
            }
        }
        .navigationTitle("Debug")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsDebugView()
            .previewDataContainer()
    }
}
