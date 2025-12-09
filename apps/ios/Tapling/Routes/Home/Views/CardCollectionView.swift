//
//  CardCollectionView.swift
//  Tapling
//
//  Created by Benno on 09.12.25.
//

import SwiftData
import SwiftUI

struct CardCollectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate<OwnedCollectible> { $0.unlockedAt != nil },
        sort: \OwnedCollectible.collectibleId
    ) private var ownedCollectibles: [OwnedCollectible]
    @QuerySingleton private var keyboardTapling: KeyboardTapling
    @State private var selectedCardId: String?

    private let registry = CollectibleRegistry.shared

    // MARK: - UI

    private var collectibles: [AnyCollectible] {
        let grouped = Dictionary(grouping: ownedCollectibles) {
            $0.collectibleId
        }

        let equippedIds: Set<String> = Set([
            keyboardTapling.equippedFurId,
            keyboardTapling.equippedFaceId,
            keyboardTapling.equippedHatId,
        ].compactMap { $0 })

        return registry.allCollectibles
            .filter { grouped[$0.id] != nil }
            .filter { !equippedIds.contains($0.id) }
            .sorted { collectible1, collectible2 in
                if collectible1.rarity.sortOrder
                    != collectible2.rarity.sortOrder
                {
                    return collectible1.rarity.sortOrder
                        > collectible2.rarity.sortOrder
                }
                return collectible1.name < collectible2.name
            }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerSection
            Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                ForEach(gridRows, id: \.self) { row in
                    GridRow {
                        ForEach(row) { collectible in
                            SelectableCollectibleCardView(
                                collectible: collectible,
                                count: nil,
                                isSelected: selectedCardId == collectible.id,
                                onTap: { toggleSelection(collectible.id) }
                            ) { cardSize in
                                CollectibleInfoUseActionButtons(
                                    cardSize: cardSize,
                                    onInfo: {
                                        print("ℹ️ Info: \(collectible.name)")
                                    },
                                    onUse: {
                                        equipCollectible(collectible)
                                    }
                                )
                            }
                            .zIndex(selectedCardId == collectible.id ? 5 : 0)
                        }
                    }
                }
            }
            .padding(.bottom, 100)
        }
        .padding(.horizontal, 16)
    }

    private var headerSection: some View {
        Text("Collection")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(.primary)
    }

    private var gridRows: [[AnyCollectible]] {
        stride(from: 0, to: collectibles.count, by: 3).map {
            Array(collectibles[$0..<min($0 + 3, collectibles.count)])
        }
    }

    // MARK: - Actions

    private func toggleSelection(_ id: String) {
        selectedCardId = (selectedCardId == id) ? nil : id
    }

    private func equipCollectible(_ collectible: AnyCollectible) {
        switch collectible.slotType {
        case .fur:
            keyboardTapling.equippedFurId = collectible.id
        case .face:
            keyboardTapling.equippedFaceId = collectible.id
        case .hat:
            keyboardTapling.equippedHatId = collectible.id
        }
        try? modelContext.save()
        selectedCardId = nil
    }
}

#Preview {
    CardCollectionView()
        .previewDataContainer { context in
            let player = Player.instance(with: context)

            let registry = CollectibleRegistry.shared
            for collectible in registry.allCollectibles {
                let ownedCollectible = OwnedCollectible(
                    collectibleId: collectible.id,
                    unlockedAt: Date(),
                    player: player
                )
                context.insert(ownedCollectible)
            }
        }
}
