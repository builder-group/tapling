//
//  CollectionItemDetailView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftUI

struct CollectionItemDetailView: View {
    let collectible: AnyCollectible
    let isUnlocked: Bool
    let count: Int
    let firstUnlockedDate: Date?

    @State private var leftHand: HandPosition = .up
    @State private var rightHand: HandPosition = .down

    private var previewTapling: Tapling {
        switch collectible {
        case .hat(let hat):
            return Tapling(
                fur: .default,
                hat: hat,
                face: .default,
                leftHand: leftHand,
                rightHand: rightHand
            )
        case .face(let face):
            return Tapling(
                fur: .default,
                hat: nil,
                face: face,
                leftHand: leftHand,
                rightHand: rightHand
            )
        case .fur(let fur):
            return Tapling(
                fur: fur,
                hat: nil,
                face: .default,
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
                TaplingView(tapling: previewTapling)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(40)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleHands()
                    }
            }
            .padding(.horizontal)
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

            if isUnlocked {
                Divider()

                VStack(spacing: 12) {
                    HStack {
                        Text("Owned:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(count)x")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                    }

                    if let firstUnlocked = firstUnlockedDate {
                        HStack {
                            Text("First Unlocked:")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(firstUnlocked, style: .date)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                        }
                    }
                }
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
}

#Preview {
    NavigationStack {
        CollectionItemDetailView(
            collectible: .hat(
                Hat(
                    id: "hat_propeller-hat",
                    name: "Propeller Hat",
                    rarity: .epic,
                    assetVariant: "propeller-hat"
                )
            ),
            isUnlocked: true,
            count: 3,
            firstUnlockedDate: Date()
        )
    }
}
