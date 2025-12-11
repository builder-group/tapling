//
//  OnboardingSelectKeyboardView.swift
//  Tapling
//
//  Created by Benno on 11.12.25.
//

import SwiftUI

struct OnboardingSelectKeyboardView: View {
    @FocusState private var isTextFieldFocused: Bool
    @State private var inputText = ""
    @State private var leftHand: HandPosition = .up
    @State private var rightHand: HandPosition = .down

    let onNext: () -> Void

    private var currentTapling: Tapling {
        Tapling(
            fur: .default,
            hat: Hat.get("hat_lil-duck"),
            face: Face.get("face_cute")!,
            leftHand: leftHand,
            rightHand: rightHand
        )
    }

    private var canProceed: Bool {
        isTextFieldFocused || !inputText.isEmpty
    }

    // MARK: - UI

    var body: some View {
        VStack {
            VStack(spacing: 16) {
                titleSection
                subtitleSection
            }

            textInputSection

            Spacer()

            nextButton
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            toggleHands()
        }
    }

    private var titleSection: some View {
        Text("Start typing with Tapling")
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }

    private var subtitleSection: some View {
        Text(
            "Switch to the Tapling keyboard using the globe icon. Type anything and watch Tapling tap along, collecting keycaps with you as you write, chat, or work."
        )
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }

    private var textInputSection: some View {
        TextField(
            "Type something to say hi...",
            text: $inputText,
            axis: .vertical
        )
        .focused($isTextFieldFocused)
        .textFieldStyle(.roundedBorder)
        .lineLimit(3...6)
        .font(.body)
    }

    private var nextButton: some View {
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
                Text("Next")
                    .font(.headline)
                    .foregroundStyle(canProceed ? .white : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                canProceed
                                    ? Color.blue
                                    : Color.gray.opacity(0.1)
                            )
                    )
            }
            .disabled(!canProceed)
        }
    }

    // MARK: - Actions

    private func toggleHands() {
        leftHand = leftHand == .down ? .up : .down
        rightHand = rightHand == .down ? .up : .down
    }
}

#Preview {
    OnboardingSelectKeyboardView(onNext: {})
}
