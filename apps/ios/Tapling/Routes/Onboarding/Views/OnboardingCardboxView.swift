//
//  OnboardingCardboxView.swift
//  Tapling
//
//  Created by Benno on 11.12.25.
//

import SwiftData
import SwiftUI

struct OnboardingCardboxView: View {
    @Environment(\.modelContext) private var modelContext
    @QuerySingleton private var player: Player

    let isCancelable: Bool
    let onNext: () -> Void

    @State private var isOpeningCardbox = false
    @State private var leftHand: HandPosition = .up
    @State private var rightHand: HandPosition = .down

    init(isCancelable: Bool = false, onNext: @escaping () -> Void) {
        self.isCancelable = isCancelable
        self.onNext = onNext
    }

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
        Group {
            if isOpeningCardbox {
                CardboardBoxOpeningView(onCollect: handleCollectibleWon)
            } else {
                introView
            }
        }
    }

    private var introView: some View {
        VStack {
            VStack(spacing: 16) {
                titleSection
                subtitleSection
            }

            Spacer()

            claimButton
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            toggleHands()
        }
    }

    private var titleSection: some View {
        Text("Discover cardboxes")
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }

    private var subtitleSection: some View {
        Text(
            "Your Tapling loves surprises. Open cardboxes to find new furs, hats, and faces. Every key you type helps you earn more keycaps to unlock these fun cosmetics and personalize your Tapling."
        )
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }

    private var claimButton: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                BottomAlignedTaplingView(
                    tapling: currentTapling,
                    scale: 0.5
                )
            }
            .zIndex(1)
            Button(action: isCancelable ? onNext : startCardboxOpening) {
                Text(isCancelable ? "Next" : "Claim cardbox")
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

    private func startCardboxOpening() {
        isOpeningCardbox = true
    }

    private func handleCollectibleWon(_ collectible: AnyCollectible?) {
        if let collectible = collectible {
            let ownedCollectible = OwnedCollectible(
                collectibleId: collectible.id,
                unlockedAt: Date(),
                player: player
            )
            modelContext.insert(ownedCollectible)
            try? modelContext.save()
        }

        onNext()
    }
}

#Preview {
    OnboardingCardboxView(isCancelable: false, onNext: {})
        .previewDataContainer()
}
