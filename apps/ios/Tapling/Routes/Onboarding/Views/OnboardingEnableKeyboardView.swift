//
//  OnboardingEnableKeyboardView.swift
//  Tapling
//
//  Created by Benno on 11.12.25.
//

import KeyboardKit
import SwiftUI

struct OnboardingEnableKeyboardView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var isKeyboardEnabled = false
    @State private var leftHand: HandPosition = .up
    @State private var rightHand: HandPosition = .down

    let onNext: () -> Void

    private let keyboardStatus = KeyboardStatusContext(
        bundleId: "com.buildergroup.Tapling.Keyboard"
    )

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

            keyboardStatusSection

            Spacer()

            nextButton
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            toggleHands()
        }
        .onAppear {
            checkKeyboardStatus()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                checkKeyboardStatus()
            }
        }
    }

    private var titleSection: some View {
        Text("Let’s get started")
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }

    private var subtitleSection: some View {
        Text(
            "Tapling needs a keyboard to join you. Enable the Tapling keyboard so your little friend can tap along wherever you type."
        )
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }

    private var keyboardStatusSection: some View {
        Button(action: openSystemSettings) {
            HStack(spacing: 12) {
                Image(
                    systemName: isKeyboardEnabled
                        ? "checkmark.circle.fill"
                        : "exclamationmark.circle.fill"
                )
                .foregroundStyle(isKeyboardEnabled ? .green : .yellow)
                .font(.title3)

                Text("Keyboard Enabled")
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.gray.opacity(0.1))
            )
        }
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

    // MARK: - Actions

    private func toggleHands() {
        leftHand = leftHand == .down ? .up : .down
        rightHand = rightHand == .down ? .up : .down
    }

    private func checkKeyboardStatus() {
        keyboardStatus.refresh()
        isKeyboardEnabled = keyboardStatus.isKeyboardEnabled
    }

    private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url)
    }
}

#Preview {
    OnboardingEnableKeyboardView(onNext: {})
}
