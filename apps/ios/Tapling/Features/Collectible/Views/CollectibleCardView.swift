//
//  CollectibleCardView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftUI

struct CollectibleCardView<BottomContent: View>: View {
    let collectible: AnyCollectible
    let count: Int?
    let bottomContent: (() -> BottomContent)?

    init(
        collectible: AnyCollectible,
        count: Int? = nil,
        @ViewBuilder bottomContent: @escaping () -> BottomContent
    ) {
        self.collectible = collectible
        self.count = count
        self.bottomContent = bottomContent
    }

    init(collectible: AnyCollectible, count: Int? = nil)
    where BottomContent == EmptyView {
        self.collectible = collectible
        self.count = count
        self.bottomContent = nil
    }

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
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.white)
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(rarityColor.opacity(0.15))
                )

            VStack(spacing: 0) {
                TaplingView(tapling: previewTapling)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(8)

                if let bottomContent = bottomContent {
                    bottomContent()
                }
            }

            if let count = count {
                if count > 0 {
                    countBadge(count: count)
                } else {
                    lockedOverlay
                    lockBadge
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(rarityColor, lineWidth: 2)
        )
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
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

    private func countBadge(count: Int) -> some View {
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
                    id: "face_pilot",
                    name: "Pilot",
                    rarity: .legendary,
                    assetVariant: "pilot"
                )
            ),
            count: 0
        )
        CollectibleCardView(
            collectible: .face(
                Face(
                    id: "face_cute",
                    name: "Cute",
                    rarity: .common,
                    assetVariant: "cute"
                )
            ),
            count: nil
        )
    }.padding()
}
