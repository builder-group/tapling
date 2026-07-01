//
//  HomeCommunityView.swift
//  Tapling
//
//  Created by Codex on 01.07.26.
//

import SwiftUI

struct HomeCommunityView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Community")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Text(
                    "Tapling is a small community project. Reviews, feedback, and contributions help shape its future."
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            VStack(spacing: 0) {
                keyboardSupportLink()
                divider()

                if let url = AppConfig.appStoreReviewURL {
                    communityLink(
                        icon: "star.fill",
                        iconColor: .yellow,
                        title: "Leave a review",
                        subtitle: "Help more people discover Tapling",
                        url: url
                    )
                    divider()
                }

                if let url = AppConfig.figmaURL {
                    communityLink(
                        icon: "paintpalette.fill",
                        iconColor: .purple,
                        title: "Design cosmetics",
                        subtitle: "Create hats, furs, or faces in Figma",
                        url: url
                    )
                    divider()
                }

                if let url = AppConfig.githubURL {
                    communityLink(
                        icon: "github",
                        iconColor: .primary,
                        title: "Contribute on GitHub",
                        subtitle: "Report bugs or request features",
                        url: url,
                        isSystemIcon: false
                    )
                    divider()
                }

                if let url = AppConfig.discordURL {
                    communityLink(
                        icon: "bubble.left.and.bubble.right.fill",
                        iconColor: .blue,
                        title: "Join Discord",
                        subtitle: "Ask questions or share ideas",
                        url: url
                    )
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
        }
    }

    private func keyboardSupportLink() -> some View {
        NavigationLink {
            KeyboardSupportView()
        } label: {
            communityRow(
                icon: "keyboard.fill",
                iconColor: .blue,
                title: "Improve keyboard support",
                subtitle: "Why autocomplete and autocorrect are basic right now"
            )
        }
        .buttonStyle(.plain)
    }

    private func communityLink(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String,
        url: URL,
        isSystemIcon: Bool = true
    ) -> some View {
        Link(destination: url) {
            communityRow(
                icon: icon,
                iconColor: iconColor,
                title: title,
                subtitle: subtitle,
                trailingIcon: "arrow.up.forward",
                isSystemIcon: isSystemIcon
            )
        }
        .buttonStyle(.plain)
    }

    private func communityRow(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String,
        trailingIcon: String = "chevron.right",
        isSystemIcon: Bool = true
    ) -> some View {
        HStack(spacing: 12) {
            Group {
                if isSystemIcon {
                    Image(systemName: icon)
                } else {
                    Image(icon)
                }
            }
            .font(.title3)
            .foregroundStyle(iconColor)
            .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: trailingIcon)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }

    private func divider() -> some View {
        Divider()
            .padding(.leading, 60)
    }
}

#Preview {
    HomeCommunityView()
        .padding()
}
