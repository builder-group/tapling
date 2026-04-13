//
//  OnboardingFullAccessView.swift
//  Tapling
//
//  Created by Benno on 11.12.25.
//

import KeyboardKit
import SwiftUI

struct OnboardingFullAccessView: View {
    let onNext: () -> Void

    @State private var isFullAccessEnabled = false

    // MARK: - UI

    var body: some View {
        VStack {
            VStack(spacing: 32) {
                subtitleSection
                KeyboardStatusView(
                    showKeyboardEnabled: false,
                    showFullAccess: true,
                    style: .standalone,
                    onStatusChange: { _, isFullAccessEnabled in
                        self.isFullAccessEnabled = isFullAccessEnabled
                    }
                )
            }
            Spacer()
            nextButton
        }
        .padding()
        .navigationTitle("Earn keycaps everywhere")
        .navigationBarTitleDisplayMode(.large)
    }

    private var subtitleSection: some View {
        let keycapIcon = Text(Image("keycap_inline"))
        return VStack(alignment: .leading, spacing: 8) {
            Text(
                "Enable Full Access so Tapling can count keystrokes in any app and earn keycaps (\(keycapIcon)) wherever you type. You can also tap your Tapling on Home for a few extra keycaps."
            )
            .font(.body)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.leading)

            Text(privacyText)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
        }
    }

    private var privacyText: AttributedString {
        var text = AttributedString(
            "Tapling never reads what you type and all data stays on your device. Verify on GitHub."
        )
        if let range = text.range(of: "Verify on GitHub"),
            let url = AppConfig.githubURL
        {
            text[range].link = url
        }
        return text
    }

    private var nextButton: some View {
        AnimatedTaplingOverlay(
            tapling: isFullAccessEnabled
                ? Tapling(
                    fur: .default,
                    hat: nil,
                    face: Face.get("face_pilot")!,
                    leftHand: .up,
                    rightHand: .down
                )
                : Tapling(
                    fur: .default,
                    hat: nil,
                    face: Face.get("face_dead")!,
                    leftHand: .up,
                    rightHand: .down
                ),
            scale: 0.5
        ) {
            Button(action: onNext) {
                Text(
                    isFullAccessEnabled
                        ? "Next" : "Continue without Full Access"
                )
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.blue)
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingFullAccessView(onNext: {})
    }
}
