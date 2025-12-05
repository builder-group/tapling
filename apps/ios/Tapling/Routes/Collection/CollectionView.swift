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
    @State private var selectedType: Collectible.CollectibleType = .hat

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
            ForEach(Collectible.CollectibleType.allCases, id: \.self) { type in
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
                ForEach(sortedCollectibles(for: selectedType)) { collectible in
                    NavigationLink {
                        CollectionItemDetailView(
                            collectible: collectible,
                            isUnlocked: isUnlocked(
                                collectibleId: collectible.id
                            )
                        )
                    } label: {
                        CollectibleCardView(
                            collectible: collectible,
                            isUnlocked: isUnlocked(
                                collectibleId: collectible.id
                            )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }

    // MARK: - Actions

    private func isUnlocked(collectibleId: String) -> Bool {
        ownedCollectibles.first { $0.collectibleId == collectibleId }?
            .isUnlocked ?? false
    }

    private func sortedCollectibles(for type: Collectible.CollectibleType)
        -> [Collectible]
    {
        let collectibles = registry.collectibles(ofType: type)
        return collectibles.sorted { collectible1, collectible2 in
            let unlocked1 = isUnlocked(collectibleId: collectible1.id)
            let unlocked2 = isUnlocked(collectibleId: collectible2.id)

            if unlocked1 != unlocked2 {
                return unlocked1
            }

            return collectible1.rarity.sortOrder > collectible2.rarity.sortOrder
        }
    }
}

#Preview {
    CollectionView()
        .previewDataContainer()
}
