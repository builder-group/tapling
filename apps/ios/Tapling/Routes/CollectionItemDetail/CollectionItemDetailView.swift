//
//  CollectionItemDetailView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftUI

struct CollectionItemDetailView: View {
    let collectible: Collectible
    let isUnlocked: Bool

    @State private var leftHand: TaplingConfig.Hand = .up
    @State private var rightHand: TaplingConfig.Hand = .down

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Large preview
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(rarityColor.opacity(0.15))
                    .frame(height: 300)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(rarityColor, lineWidth: 3)
                    )
                    .overlay(alignment: .topTrailing) {
                        // Lock badge in top-right corner
                        if !isUnlocked {
                            Image(systemName: "lock.fill")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding(10)
                                .background(
                                    Circle()
                                        .fill(.black.opacity(0.7))
                                )
                                .padding(16)
                        }
                    }
                    .overlay {
                        collectiblePreview
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(40)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleHands()
                            }
                    }
                    .padding(.horizontal)

                // Collectible details
                VStack(spacing: 16) {
                    // Name and rarity
                    VStack(spacing: 8) {
                        Text(collectible.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(isUnlocked ? .primary : .secondary)

                        // Rarity badge
                        Text(collectible.rarity.rawValue.capitalized)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(rarityColor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(rarityColor.opacity(0.2))
                            )
                    }
                }
                .padding()
            }
            .padding(.vertical)
        }
        .navigationTitle(collectible.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var collectiblePreview: some View {
        Group {
            if let tapling = previewTapling {
                TaplingView(tapling: tapling)
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
                leftHand: leftHand,
                rightHand: rightHand
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
                leftHand: leftHand,
                rightHand: rightHand
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
                leftHand: leftHand,
                rightHand: rightHand
            )
        }
    }

    private func toggleHands() {
        leftHand = leftHand == .down ? .up : .down
        rightHand = rightHand == .down ? .up : .down
    }

    private var rarityColor: Color {
        collectible.rarity.color
    }
}

#Preview {
    NavigationStack {
        CollectionItemDetailView(
            collectible: Collectible(
                id: "test",
                name: "Epic Hat",
                type: .hat,
                rarity: .epic,
                assetName: "hat_propeller-hat"
            ),
            isUnlocked: false
        )
    }
    .previewDataContainer()
}
