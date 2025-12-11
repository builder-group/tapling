//
//  OnboardingWelcomeView.swift
//  Tapling
//
//  Created by Benno on 11.12.25.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    let onNext: () -> Void

    @State private var leftHand: HandPosition = .up
    @State private var rightHand: HandPosition = .down

    private var currentTapling: Tapling {
        Tapling(
            fur: .default,
            hat: Hat.get("hat_lil-duck"),
            face: Face.get("face_cute")!,
            leftHand: leftHand,
            rightHand: rightHand
        )
    }

    // MARK: - UI

    var body: some View {
        VStack {
            VStack(spacing: 16) {
                titleSection
                subtitleSection
            }
            Spacer()
            meetTaplingButton
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            toggleHands()
        }
    }

    private var titleSection: some View {
        Text("Welcome to Tapling")
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }

    private var subtitleSection: some View {
        Text(
            "Meet your tiny keyboard companion. Tapling taps along as you type, turning every keystroke into keycaps you can use to unlock cute cosmetics."
        )
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }

    private var meetTaplingButton: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                BottomAlignedTaplingView(
                    tapling: currentTapling,
                    scale: 0.5
                )
            }
            .zIndex(1)
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

    // MARK: - Actions

    private func toggleHands() {
        leftHand = leftHand == .down ? .up : .down
        rightHand = rightHand == .down ? .up : .down
    }
}

#Preview {
    OnboardingWelcomeView(onNext: {})
}
