//
//  ItemCardView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftUI

struct ItemCardView: View {
    let item: Item
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: 8) {
            // Item preview with rarity-colored border and background
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(rarityColor.opacity(0.15))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(rarityColor, lineWidth: 2)
                    )

                itemPreview

                if !isUnlocked {
                    // Subtle overlay for locked items (lighter so preview is visible)
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

            // Item name
            Text(item.name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(isUnlocked ? .primary : .secondary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }

    private var itemPreview: some View {
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

        switch item.type {
        case .hat:
            let rawValue = item.assetName.replacingOccurrences(
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
            let rawValue = item.assetName.replacingOccurrences(
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
            let rawValue = item.assetName.replacingOccurrences(
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
        switch item.rarity {
        case .common: return .gray
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .orange
        }
    }
}

#Preview {
    HStack {
        ItemCardView(
            item: Item(
                id: "test",
                name: "Test Item",
                type: .hat,
                rarity: .epic,
                assetName: "test"
            ),
            isUnlocked: true
        )

        ItemCardView(
            item: Item(
                id: "test2",
                name: "Locked Item",
                type: .face,
                rarity: .legendary,
                assetName: "test2"
            ),
            isUnlocked: false
        )
    }
    .padding()
}
