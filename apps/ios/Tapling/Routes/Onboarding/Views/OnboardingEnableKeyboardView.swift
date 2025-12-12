//
//  OnboardingEnableKeyboardView.swift
//  Tapling
//
//  Created by Benno on 11.12.25.
//

import KeyboardKit
import SwiftUI

struct OnboardingEnableKeyboardView: View {
    let onNext: () -> Void

    @State private var isKeyboardEnabled = false

    // MARK: - UI

    var body: some View {
        VStack {
            VStack(spacing: 32) {
                subtitleSection
                KeyboardStatusView(
                    showKeyboardEnabled: true,
                    showFullAccess: false,
                    style: .standalone,
                    onStatusChange: { isKeyboardEnabled, _ in
                        self.isKeyboardEnabled = isKeyboardEnabled
                    }
                )
            }
            Spacer()
            nextButton
        }
        .padding()
        .navigationTitle("Let's get started")
        .navigationBarTitleDisplayMode(.large)
    }

    private var subtitleSection: some View {
        Text(
            "Tapling needs a keyboard to join you. Enable the Tapling keyboard so your little friend can tap along wherever you type."
        )
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.leading)
    }

    private var nextButton: some View {
        AnimatedTaplingOverlay(scale: 0.5) {
            Button(action: onNext) {
                Text("Next")
                    .font(.headline)
                    .foregroundStyle(isKeyboardEnabled ? .white : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                isKeyboardEnabled
                                    ? Color.blue
                                    : Color.gray.opacity(0.1)
                            )
                    )
            }
            .disabled(!isKeyboardEnabled)
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingEnableKeyboardView(onNext: {})
    }
}
