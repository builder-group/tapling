//
//  SettingsCreditsView.swift
//  Tapling
//
//  Created by Benno on 05.12.25.
//

import SwiftUI

struct SettingsCreditsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                creditsSection
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Credits")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            CreditsAnimatedLogoView()

            VStack(spacing: 4) {
                Text("Tapling is inspired by amazing creators")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)

                Text("We're grateful for their work")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
        }
        .padding(.top, 8)
    }

    private var creditsSection: some View {
        SectionContainerView {
            if let strayRogueURL = URL(string: "https://twitter.com/StrayRogue")
            {
                LinkRowView(
                    icon: "paintbrush.fill",
                    iconColor: .purple,
                    title: "@StrayRogue",
                    subtitle: "Original artwork and meme",
                    url: strayRogueURL
                )

                SectionDivider()
            }

            if let bongoCatURL = URL(
                string: "https://store.steampowered.com/app/3419430/Bongo_Cat/"
            ) {
                LinkRowView(
                    icon: "gamecontroller.fill",
                    iconColor: .blue,
                    title: "Bongo Cat",
                    subtitle: "Game that inspired Tapling",
                    url: bongoCatURL
                )
            }
        }
    }
}

private struct SectionContainerView<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .padding(.horizontal)
    }
}

private struct SectionDivider: View {
    var body: some View {
        Divider()
            .padding(.leading, 56)
    }
}

#Preview {
    NavigationStack {
        SettingsCreditsView()
            .previewDataContainer()
    }
}
