//
//  SettingsGettingStartedView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftUI

struct SettingsGettingStartedView: View {
    private enum Step {
        static let enableKeyboard = (
            title: "Enable Keyboard",
            description:
                "Go to Settings > Keyboard > Keyboards > Add New Keyboard and select Tapling"
        )
        static let enableFullAccess = (
            title: "Enable Full Access",
            description:
                "Go to Settings > Keyboard > Keyboards > Tapling and enable Full Access"
        )
        static let customize = (
            title: "Customize Your Tapling",
            description:
                "Adjust the scale and position of your Tapling in the settings"
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                stepsSection
            }
            .padding()
        }
        .navigationTitle("Getting Started")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Components

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome to Tapling!")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Follow these steps to get started:")
                .font(.headline)
        }
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            StepView(
                number: 1,
                title: Step.enableKeyboard.title,
                description: Step.enableKeyboard.description
            )

            StepView(
                number: 2,
                title: Step.enableFullAccess.title,
                description: Step.enableFullAccess.description
            )

            StepView(
                number: 3,
                title: Step.customize.title,
                description: Step.customize.description
            )
        }
        .padding(.top, 8)
    }
}

#Preview {
    NavigationStack {
        SettingsGettingStartedView()
    }
}
