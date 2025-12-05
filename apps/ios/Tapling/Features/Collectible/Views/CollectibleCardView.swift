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

    private var previewTapling: Tapling? {
        let defaultFur = TaplingConfig.Fur.white
        let defaultFace = TaplingConfig.Face.cute
        let defaultHand = TaplingConfig.Hand.down

        switch collectible.type {
        case .hat:
            guard let hat = extractHat(from: collectible.assetName) else {
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
            guard let face = extractFace(from: collectible.assetName) else {
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
            guard let fur = extractFur(from: collectible.assetName) else {
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

    // MARK: - UI

    var body: some View {
        VStack(spacing: 8) {
            previewCard
            nameLabel
        }
    }

    private var previewCard: some View {
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
                lockedOverlay
                lockBadge
            }
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

    private var lockedOverlay: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(.black.opacity(0.3))
    }

    private var lockBadge: some View {
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

    private var nameLabel: some View {
        Text(collectible.name)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(isUnlocked ? .primary : .secondary)
            .lineLimit(2)
            .multilineTextAlignment(.center)
    }

    // MARK: - Actions

    private func extractHat(from assetName: String) -> TaplingConfig.Hat? {
        let rawValue = assetName.replacingOccurrences(of: "hat_", with: "")
        return TaplingConfig.Hat(rawValue: rawValue)
    }

    private func extractFace(from assetName: String) -> TaplingConfig.Face? {
        let rawValue = assetName.replacingOccurrences(of: "face_", with: "")
        return TaplingConfig.Face(rawValue: rawValue)
    }

    private func extractFur(from assetName: String) -> TaplingConfig.Fur? {
        let rawValue = assetName.replacingOccurrences(of: "fur_", with: "")
        return TaplingConfig.Fur(rawValue: rawValue)
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
                assetName: "hat_propeller-hat"
            ),
            isUnlocked: true
        )

        CollectibleCardView(
            collectible: Collectible(
                id: "test2",
                name: "Locked Collectible",
                type: .face,
                rarity: .legendary,
                assetName: "face_cute"
            ),
            isUnlocked: false
        )
    }
    .fixedSize(horizontal: false, vertical: true)
    .frame(maxWidth: .infinity)
    .padding()
}
