//
//  ActionRowView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftUI

struct ActionRowView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let action: () -> Void
    let isSystemIcon: Bool

    init(
        icon: String,
        iconColor: Color,
        title: String,
        action: @escaping () -> Void,
        isSystemIcon: Bool = true
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.action = action
        self.isSystemIcon = isSystemIcon
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Group {
                    if isSystemIcon {
                        Image(systemName: icon)
                            .font(.title3)
                            .foregroundStyle(iconColor)
                    } else {
                        Image(icon)
                            .font(.title3)
                            .foregroundStyle(iconColor)
                    }
                }
                .frame(width: 32, height: 32)

                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
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
        ActionRowView(
            icon: "envelope.fill",
            iconColor: .blue,
            title: "Feedback"
        ) {
            print("Feedback tapped")
        }
    }
    .background(
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color(.secondarySystemGroupedBackground))
    )
    .padding()
}
