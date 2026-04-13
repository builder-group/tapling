//
//  OnboardingSelectKeyboardView.swift
//  Tapling
//
//  Created by Benno on 11.12.25.
//

import SwiftUI

struct OnboardingSelectKeyboardView: View {
    @FocusState private var isTextFieldFocused: Bool

    let onNext: () -> Void

    @State private var inputText = ""
    @State private var totalKeystrokes = 0

    private var canProceed: Bool {
        totalKeystrokes >= 10
    }

    private var remainingKeystrokes: Int {
        max(0, 10 - totalKeystrokes)
    }

    // MARK: - UI

    var body: some View {
        VStack {
            VStack(spacing: 32) {
                subtitleSection
                textInputSection
            }
            Spacer()
            nextButton
        }
        .padding()
        .navigationTitle("Switch & try it out")
        .navigationBarTitleDisplayMode(.large)
        .contentShape(Rectangle())
        .onTapGesture {
            isTextFieldFocused = false
        }
    }

    private var subtitleSection: some View {
        let globeIcon = Text(Image(systemName: "globe"))
            .foregroundStyle(.blue)
        return Text(
            "Switch to the Tapling keyboard using the (\(globeIcon)) icon at the bottom of your keyboard. Type anything and watch your Tapling tap along with you as you write, chat, or work."
        )
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.leading)
    }

    private var textInputSection: some View {
        TextField(
            "Type something to say hi...",
            text: $inputText
        )
        .focused($isTextFieldFocused)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.gray.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(
                    isTextFieldFocused ? Color.blue : Color.clear,
                    lineWidth: 2
                )
        )
        .font(.body)
        .submitLabel(.done)
        .onSubmit {
            isTextFieldFocused = false
        }
        .onChange(of: inputText) { oldValue, newValue in
            let newLength = newValue.count
            let oldLength = oldValue.count

            if newLength > oldLength {
                totalKeystrokes += newLength - oldLength
            }
        }
    }

    private var nextButton: some View {
        Group {
            if isTextFieldFocused {
                plainButton
            } else {
                AnimatedTaplingOverlay(
                    tapling: Tapling(
                        fur: .default,
                        hat: Hat.get("hat_heart"),
                        face: Face.get("face_cute")!,
                        leftHand: .up,
                        rightHand: .down
                    ),
                    scale: 0.5
                ) {
                    plainButton
                }
            }
        }
    }

    private var plainButton: some View {
        Button(action: onNext) {
            Group {
                if canProceed {
                    Text("Next")
                } else {
                    Text("Type \(remainingKeystrokes) more to continue")
                }
            }
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

#Preview {
    NavigationStack {
        OnboardingSelectKeyboardView(onNext: {})
    }
}
