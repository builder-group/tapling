//
//  CollectionView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftData
import SwiftUI

struct CollectionView: View {
    @Query private var ownedCollectibles: [OwnedCollectible]
    @State private var selectedType: AnyCollectible.SlotType = .hat

    private let registry = CollectibleRegistry.shared

    // MARK: - UI

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                typePicker
                collectiblesGrid
            }
            .navigationTitle("Collection")
        }
    }

    private var typePicker: some View {
        Picker("Collectible Type", selection: $selectedType) {
            ForEach(AnyCollectible.SlotType.allCases, id: \.self) { type in
                Text(type.rawValue.capitalized)
                    .tag(type)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }

    private var collectiblesGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                ],
                spacing: 12
            ) {
                ForEach(collectibleItems(for: selectedType)) { item in
                    NavigationLink {
                        CollectionItemDetailView(
                            collectible: item.collectible,
                            isUnlocked: item.isUnlocked,
                            count: item.count,
                            firstUnlockedDate: item.firstUnlockedDate
                        )
                    } label: {
                        CollectibleCardView(
                            collectible: item.collectible,
                            count: item.count
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }

    // MARK: - Actions

    private struct CollectibleItem: Identifiable {
        let id: String
        let collectible: AnyCollectible
        let isUnlocked: Bool
        let count: Int
        let firstUnlockedDate: Date?
    }

    private func collectibleItems(for type: AnyCollectible.SlotType)
        -> [CollectibleItem]
    {
        let collectibles = registry.collectibles(ofType: type)
        return collectibles.map { collectible in
            let matching = ownedCollectibles.filter {
                $0.collectibleId == collectible.id && $0.isUnlocked
            }
            let isUnlocked = !matching.isEmpty
            let count = matching.count
            let firstUnlockedDate = matching.compactMap { $0.unlockedAt }.min()

            return CollectibleItem(
                id: collectible.id,
                collectible: collectible,
                isUnlocked: isUnlocked,
                count: count,
                firstUnlockedDate: firstUnlockedDate
            )
        }
        .sorted { item1, item2 in
            if item1.isUnlocked != item2.isUnlocked {
                return item1.isUnlocked
            }
            return item1.collectible.rarity.sortOrder
                > item2.collectible.rarity.sortOrder
        }
    }
}

#Preview {
    CollectionView()
        .previewDataContainer()
}
