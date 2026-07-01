//
//  KeyboardSupportView.swift
//  Tapling
//
//  Created by Codex on 01.07.26.
//

import SwiftUI

struct KeyboardSupportView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                explanationSection
                costSection
                ctaSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Keyboard Support")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: "keyboard.fill")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(.blue)

            Text("Better keyboard support")
                .font(.title2)
                .fontWeight(.bold)

            Text(
                "The keyboard works today. The part that feels basic right now is the typing help you expect from iOS: autocomplete, autocorrect, and language support."
            )
            .font(.body)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(cardBackground)
    }

    private var explanationSection: some View {
        sectionCard(title: "What you may notice") {
            Text(
                "Typing works, but these parts are still limited."
            )
            .font(.body)
            .foregroundStyle(.primary)

            supportPoint(
                icon: "text.cursor",
                title: "Autocomplete",
                description:
                    "Suggestions can be missing or less useful than expected."
            )

            supportPoint(
                icon: "checkmark.circle",
                title: "Autocorrect",
                description:
                    "Typos can slip through."
            )

            supportPoint(
                icon: "globe",
                title: "Languages",
                description:
                    "Better support needs dictionaries and rules that improve over time."
            )
        }
    }

    private var costSection: some View {
        sectionCard(title: "Why it is not simple") {
            Text(
                "A custom keyboard does not automatically get Apple's autocomplete and autocorrect. To get closer, Tapling has to build and maintain this or use a paid keyboard library."
            )
            .font(.body)
            .foregroundStyle(.primary)

            Text(
                "That only makes sense for a small community project if enough people want it and would help fund it."
            )
            .font(.body)
            .foregroundStyle(.secondary)
        }
    }

    private var ctaSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Want typing to feel better?")
                .font(.headline)

            Text(
                "Tell us what feels missing and whether you would pay for better autocomplete, autocorrect, or language support."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)

            if let url = AppConfig.mailtoURL(
                subject: "Better Tapling keyboard support"
            ) {
                Link(destination: url) {
                    Label(
                        "Send feedback",
                        systemImage: "envelope.fill"
                    )
                    .font(.headline)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(cardBackground)
    }

    private func sectionCard<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(cardBackground)
    }

    private func supportPoint(
        icon: String,
        title: String,
        description: String
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color(.secondarySystemGroupedBackground))
    }
}

#Preview {
    NavigationStack {
        KeyboardSupportView()
    }
}
