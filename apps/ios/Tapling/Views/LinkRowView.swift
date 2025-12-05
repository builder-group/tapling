//
//  LinkRowView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftUI

struct LinkRowView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String?
    let url: URL

    init(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String? = nil,
        url: URL
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.url = url
    }

    var body: some View {
        Link(destination: url) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(iconColor)
                    .frame(width: 32)

                if let subtitle = subtitle {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.body)
                            .foregroundStyle(.primary)

                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text(title)
                        .font(.body)
                        .foregroundStyle(.primary)
                }

                Spacer()

                Image(systemName: "arrow.up.forward")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 0) {
        LinkRowView(
            icon: "safari.fill",
            iconColor: .blue,
            title: "Website",
            url: URL(string: "https://tapling.app")!
        )
    }
    .background(
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color(.secondarySystemGroupedBackground))
    )
    .padding()
}
