//
//  OnboardingFullAccessView.swift
//  Tapling
//
//  Created by Benno on 11.12.25.
//

import KeyboardKit
import SwiftUI

struct OnboardingFullAccessView: View {
    @Environment(\.scenePhase) private var scenePhase

    let onNext: () -> Void

    @State private var isFullAccessEnabled = false
    @State private var leftHand: HandPosition = .up
    @State private var rightHand: HandPosition = .down

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

            fullAccessStatusSection

            Spacer()

            nextButton
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            toggleHands()
        }
        .onAppear {
            checkFullAccessStatus()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                checkFullAccessStatus()
            }
        }
    }

    private var titleSection: some View {
        Text("Full access for keycap counting")
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }

    private var subtitleSection: some View {
        Text(
            "To count every keystroke and earn keycaps, Tapling needs full access to the keyboard. Tapling never reads what you type and all data stays on your device. Full access just lets your Tapling keep growing as you type."
        )
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }

    private var fullAccessStatusSection: some View {
        Button(action: openSystemSettings) {
            HStack(spacing: 12) {
                Image(
                    systemName: isFullAccessEnabled
                        ? "checkmark.circle.fill"
                        : "exclamationmark.circle.fill"
                )
                .foregroundStyle(isFullAccessEnabled ? .green : .yellow)
                .font(.title3)

                Text("Full Access Enabled")
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

    // MARK: - Actions

    private func toggleHands() {
        leftHand = leftHand == .down ? .up : .down
        rightHand = rightHand == .down ? .up : .down
    }

    private func checkFullAccessStatus() {
        keyboardStatus.refresh()
        isFullAccessEnabled = keyboardStatus.isFullAccessEnabled
    }

    private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url)
    }
}

#Preview {
    OnboardingFullAccessView(onNext: {})
}
