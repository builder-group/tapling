//
//  OnboardingWelcomeView.swift
//  Tapling
//
//  Created by Benno on 11.12.25.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    let onNext: () -> Void

    // MARK: - UI

    var body: some View {
        VStack {
            subtitleSection
            Spacer()
            meetTaplingButton
        }
        .padding()
        .navigationTitle("Welcome to Tapling")
        .navigationBarTitleDisplayMode(.large)
    }

    private var subtitleSection: some View {
        Text(
            "Meet your tiny keyboard companion. Tapling taps along as you type, turning every keystroke into keycaps you can use to unlock cute cosmetics."
        )
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.leading)
    }

    private var meetTaplingButton: some View {
        AnimatedTaplingOverlay(
            tapling: Tapling(
                fur: .default,
                hat: Hat.get("hat_lil-duck"),
                face: Face.get("face_cute")!,
                leftHand: .up,
                rightHand: .down
            ),
            scale: 0.5
        ) {
            Button(action: onNext) {
                Text("Meet your Tapling")
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
        OnboardingWelcomeView(onNext: {})
    }
}
