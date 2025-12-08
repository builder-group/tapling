//
//  CollectibleCardView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftUI

struct CollectibleCardView: View {
    let collectible: AnyCollectible
    let count: Int

    private var previewTapling: Tapling {
        switch collectible {
        case .hat(let hat):
            return Tapling(
                fur: .default,
                hat: hat,
                face: .default,
                leftHand: .down,
                rightHand: .down
            )
        case .face(let face):
            return Tapling(
                fur: .default,
                hat: nil,
                face: face,
                leftHand: .down,
                rightHand: .down
            )
        case .fur(let fur):
            return Tapling(
                fur: fur,
                hat: nil,
                face: .default,
                leftHand: .down,
                rightHand: .down
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

            TaplingView(tapling: previewTapling)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(8)

            if count > 0 {
                countBadge
            } else {
                lockedOverlay
                lockBadge
            }
        }
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

    private var lockedOverlay: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(.black.opacity(0.3))
    }

    private var countBadge: some View {
        Text("\(count)")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(.black.opacity(0.7))
            )
            .padding(8)
    }

    private var nameLabel: some View {
        Text(collectible.name)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(count > 0 ? .primary : .secondary)
            .lineLimit(2)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    HStack {
        CollectibleCardView(
            collectible: .hat(
                Hat(
                    id: "hat_propeller-hat",
                    name: "Propeller Hat",
                    rarity: .epic,
                    assetVariant: "propeller-hat"
                )
            ),
            count: 3
        )

        CollectibleCardView(
            collectible: .face(
                Face(
                    id: "face_cute",
                    name: "Cute",
                    rarity: .legendary,
                    assetVariant: "cute"
                )
            ),
            count: 0
        )
    }
    .fixedSize(horizontal: false, vertical: true)
    .frame(maxWidth: .infinity)
    .padding()
}
