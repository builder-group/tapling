//
//  PreviewBannerView.swift
//  Keyboard
//
//  Created by Benno on 04.12.25.
//

import KeyboardKit
import SwiftData
import SwiftUI

struct PreviewBannerView: View {
    @QuerySingleton private var keyboardSettings: KeyboardSettings
    private let keyboardStatus = KeyboardStatusContext(
        bundleId: "com.buildergroup.Tapling.Keyboard"
    )

    var body: some View {
        if keyboardSettings.isPreviewMode {
            HStack(spacing: 8) {
                Image(systemName: "eye.fill")
                    .font(.caption)

                bannerText
                    .font(.caption)
                    .fontWeight(.semibold)

                Spacer()
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(bannerColor)
            .onAppear {
                keyboardStatus.refresh()
            }
        }
    }

    private var bannerText: Text {
        if keyboardStatus.isFullAccessEnabled {
            return Text("Live Preview")
        } else {
            let keyboardIcon = Text(Image(systemName: "keyboard.fill"))
                .foregroundStyle(.blue)
            return Text(
                "Preview • Reopen keyboard for changes (\(keyboardIcon))"
            )
        }
    }

    private var bannerColor: Color {
        keyboardStatus.isFullAccessEnabled
            ? .blue.opacity(0.8)
            : .orange.opacity(0.8)
    }
}
