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
                CardboardBoxOpeningView(onCollect: handleCollectibleWon)
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
        return Text(
            "Your Tapling loves surprises. Open cardboxes (\(cardboxIcon)) to find new furs, hats, and faces. Every key you type helps you earn more keycaps to unlock these fun cosmetics and personalize your Tapling."
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
                Group {
                    if isCancelable {
                        Text("Next")
                    } else {
                        let cardboxIcon = Text(
                            Image(systemName: "shippingbox.fill")
                        )
                        .foregroundStyle(.white)
                        Text("Claim cardbox (\(cardboxIcon))")
                    }
                }
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
