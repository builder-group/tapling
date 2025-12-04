//
//  CollectibleCardView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftUI

struct CollectibleCardView: View {
    let collectible: Collectible
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: 8) {
            // Collectible preview with rarity-colored border and background
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(rarityColor.opacity(0.15))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(rarityColor, lineWidth: 2)
                    )

                collectiblePreview

                if !isUnlocked {
                    // Subtle overlay for locked collectibles (lighter so preview is visible)
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.black.opacity(0.3))
                }

                // Lock badge in top-right corner
                if !isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(
                            Circle()
                                .fill(.black.opacity(0.7))
                        )
                        .padding(8)
                }
            }

            // Collectible name
            Text(collectible.name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(isUnlocked ? .primary : .secondary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }

    private var collectiblePreview: some View {
        Group {
            if let tapling = previewTapling {
                TaplingView(tapling: tapling)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(8)
            } else {
                Text("Preview")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var previewTapling: Tapling? {
        let defaultFur = TaplingConfig.Fur.white
        let defaultFace = TaplingConfig.Face.cute
        let defaultHand = TaplingConfig.Hand.down

        switch collectible.type {
        case .hat:
            let rawValue = collectible.assetName.replacingOccurrences(
                of: "hat_",
                with: ""
            )
            guard let hat = TaplingConfig.Hat(rawValue: rawValue) else {
                return nil
            }
            return Tapling(
                fur: defaultFur,
                hat: hat,
                face: defaultFace,
                leftHand: defaultHand,
                rightHand: defaultHand
            )
        case .face:
            let rawValue = collectible.assetName.replacingOccurrences(
                of: "face_",
                with: ""
            )
            guard let face = TaplingConfig.Face(rawValue: rawValue) else {
                return nil
            }
            return Tapling(
                fur: defaultFur,
                hat: nil,
                face: face,
                leftHand: defaultHand,
                rightHand: defaultHand
            )
        case .fur:
            let rawValue = collectible.assetName.replacingOccurrences(
                of: "fur_",
                with: ""
            )
            guard let fur = TaplingConfig.Fur(rawValue: rawValue) else {
                return nil
            }
            return Tapling(
                fur: fur,
                hat: nil,
                face: defaultFace,
                leftHand: defaultHand,
                rightHand: defaultHand
            )
        }
    }

    private var rarityColor: Color {
        collectible.rarity.color
    }
}

#Preview {
    HStack {
        CollectibleCardView(
            collectible: Collectible(
                id: "test",
                name: "Test Collectible",
                type: .hat,
                rarity: .epic,
                assetName: "test"
            ),
            isUnlocked: true
        )

        CollectibleCardView(
            collectible: Collectible(
                id: "test2",
                name: "Locked Collectible",
                type: .face,
                rarity: .legendary,
                assetName: "test2"
            ),
            isUnlocked: false
        )
    }
    .padding()
}

