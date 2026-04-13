//
//  SettingsGettingStartedView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftUI

struct SettingsGettingStartedView: View {
    @State private var showOnboarding = false

    // MARK: - UI

    var body: some View {
        Form {
            Section {
                Button {
                    showOnboarding = true
                } label: {
                    HStack {
                        Label("Replay Introduction", systemImage: "arrow.clockwise")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Getting Started")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showOnboarding) {
            NavigationStack {
                OnboardingView(
                    isCancelable: true,
                    onComplete: {
                        showOnboarding = false
                    }
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsGettingStartedView()
    }
}
