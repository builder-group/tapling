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
        .navigationTitle("Full access for keycap counting")
        .navigationBarTitleDisplayMode(.large)
    }

    private var subtitleSection: some View {
        Text(
            "To count every keystroke and earn keycaps, Tapling needs full access to the keyboard. Tapling never reads what you type and all data stays on your device. Full access just lets your Tapling keep growing as you type."
        )
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.leading)
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
                        ? "Next" : "Continue without earning keycaps"
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
