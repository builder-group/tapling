//
//  EquippedCollectibleCardView.swift
//  Tapling
//
//  Created by Benno on 09.12.25.
//

import SwiftUI

struct EquippedCollectibleCardView: View {
    let collectible: AnyCollectible?

    // MARK: - UI

    var body: some View {
        if let collectible = collectible {
            CollectibleCardView(collectible: collectible)
        } else {
            emptyCard
        }
    }

    private var emptyCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.gray.opacity(0.1))
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(
                            Color.gray.opacity(0.3),
                            style: StrokeStyle(lineWidth: 2, dash: [6])
                        )
                )

            Image(systemName: "minus")
                .font(.title)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    HStack {
        EquippedCollectibleCardView(
            collectible: .fur(
                Fur(
                    id: "fur_white",
                    name: "White",
                    rarity: .common,
                    assetVariant: "white"
                )
            )
        )

        EquippedCollectibleCardView(
            collectible: .face(
                Face(
                    id: "face_pilot",
                    name: "Pilot",
                    rarity: .legendary,
                    assetVariant: "pilot"
                )
            )
        )

        EquippedCollectibleCardView(collectible: nil)
    }
    .padding()
}
