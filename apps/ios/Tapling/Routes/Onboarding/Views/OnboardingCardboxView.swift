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

    init(isCancelable: Bool = false, onNext: @escaping () -> Void) {
        self.isCancelable = isCancelable
        self.onNext = onNext
    }

    // MARK: - UI

    var body: some View {
        Group {
            if isOpeningCardbox {
                CardboardBoxOpeningView(
                    initialRarity: .common,
                    upgradeChances: CardboardBoxOpeningView.UpgradeChances(
                        toRare: 0.45,
                        toEpic: 0.45,
                        toLegendary: 0.25
                    ),
                    onCollect: handleCollectibleWon
                )
            } else {
                introView
            }
        }
    }

    private var introView: some View {
        VStack {
            subtitleSection
            Spacer()
            claimButton
        }
        .padding()
        .navigationTitle("Discover cardboxes")
        .navigationBarTitleDisplayMode(.large)
    }

    private var subtitleSection: some View {
        let cardboxIcon = Text(Image(systemName: "shippingbox.fill"))
            .foregroundStyle(Color.brown)
        let keycapIcon = Text(Image("keycap_inline"))
        return Text(
            "Your Tapling loves surprises. Open cardboxes (\(cardboxIcon)) to find new furs, hats, and faces. Use the keycaps (\(keycapIcon)) you earn from typing to open more cardboxes and unlock cosmetics."
        )
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.leading)
    }

    private var claimButton: some View {
        AnimatedTaplingOverlay(
            tapling: Tapling(
                fur: .default,
                hat: nil,
                face: Face.get("face_pixel-cool")!,
                leftHand: .up,
                rightHand: .down
            ),
            scale: 0.5
        ) {
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
    NavigationStack {
        OnboardingCardboxView(isCancelable: false, onNext: {})
            .previewDataContainer()
    }
}
