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

    private var previewTapling: Tapling? {
        let defaultFur = TaplingConfig.Fur.white
        let defaultFace = TaplingConfig.Face.cute

        switch collectible.type {
        case .hat:
            guard let hat = extractHat(from: collectible.assetName) else {
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
            guard let face = extractFace(from: collectible.assetName) else {
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
            guard let fur = extractFur(from: collectible.assetName) else {
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

    private var rarityColor: Color {
        collectible.rarity.color
    }

    // MARK: - UI

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                previewCard
                detailsSection
            }
            .padding(.vertical)
        }
        .navigationTitle(collectible.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var previewCard: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(rarityColor.opacity(0.15))
            .frame(height: 300)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(rarityColor, lineWidth: 3)
            )
            .overlay(alignment: .topTrailing) {
                if !isUnlocked {
                    lockBadge
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

    private var lockBadge: some View {
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

    private var detailsSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text(collectible.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(isUnlocked ? .primary : .secondary)

                rarityBadge
            }
        }
        .padding()
    }

    private var rarityBadge: some View {
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

    // MARK: - Actions

    private func toggleHands() {
        leftHand = leftHand == .down ? .up : .down
        rightHand = rightHand == .down ? .up : .down
    }

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
