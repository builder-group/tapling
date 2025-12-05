//
//  SettingsAboutView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftData
import SwiftUI

struct SettingsAboutView: View {
    private enum FeedbackSubject {
        static let general = "Tapling Feedback"
        static let feature = "Feature Request"
        static let bug = "Bug Report"
    }

    // MARK: - UI

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                feedbackSection
                linksSection
                privacySection
                versionSection
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            AnimatedTaplingLogoView()

            VStack(spacing: 4) {
                Text("Your delightful keyboard companion")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)

                Text("We'd love to hear your feedback!")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
        }
        .padding(.top, 8)
    }

    private var feedbackSection: some View {
        SectionContainerView {
            ActionRowView(
                icon: "envelope.fill",
                iconColor: .blue,
                title: "Feedback",
                action: { openMail(subject: FeedbackSubject.general) }
            )

            SectionDivider()

            ActionRowView(
                icon: "gift.fill",
                iconColor: .pink,
                title: "Request a Feature",
                action: { openMail(subject: FeedbackSubject.feature) }
            )

            SectionDivider()

            ActionRowView(
                icon: "ladybug.fill",
                iconColor: .red,
                title: "Report a Bug",
                action: { openMail(subject: FeedbackSubject.bug) }
            )
        }
    }

    private var linksSection: some View {
        SectionContainerView {
            if let url = AppConfig.appStoreURL {
                LinkRowView(
                    icon: "apple.logo",
                    iconColor: .primary,
                    title: "App Store",
                    url: url
                )

                SectionDivider()
            }

            if let url = AppConfig.websiteURL {
                LinkRowView(
                    icon: "safari.fill",
                    iconColor: .blue,
                    title: "Website",
                    url: url
                )
            }
        }
    }

    @ViewBuilder
    private var privacySection: some View {
        if let privacyURL = AppConfig.privacyPolicyURL {
            SectionContainerView {
                LinkRowView(
                    icon: "hand.raised.fill",
                    iconColor: .blue,
                    title: "Privacy Policy",
                    url: privacyURL
                )
            }
        }
    }

    private var versionSection: some View {
        VStack(spacing: 4) {
            Text("Version \(AppConfig.version) (\(AppConfig.build))")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("© 2025 builder.group")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.top, 8)
        .padding(.bottom, 24)
    }

    // MARK: - Actions

    private func openMail(subject: String) {
        guard let url = AppConfig.mailtoURL(subject: subject) else { return }
        UIApplication.shared.open(url)
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
        SettingsAboutView()
            .previewDataContainer()
    }
}
