//
//  CollectionView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftData
import SwiftUI

struct CollectionView: View {
    @Query private var ownedItems: [OwnedItem]
    @Environment(\.modelContext) private var modelContext
    @State private var selectedType: Item.ItemType = .hat

    private let registry = ItemRegistry.shared

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Type tabs
                Picker("Item Type", selection: $selectedType) {
                    ForEach(Item.ItemType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                // Items grid
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12),
                        ],
                        spacing: 12
                    ) {
                        ForEach(sortedItems(for: selectedType)) { item in
                            NavigationLink {
                                CollectionItemDetailView(
                                    item: item,
                                    isUnlocked: isUnlocked(itemId: item.id)
                                )
                            } label: {
                                ItemCardView(
                                    item: item,
                                    isUnlocked: isUnlocked(itemId: item.id)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Collection")
        }
    }

    // MARK: - Helpers

    private func isUnlocked(itemId: String) -> Bool {
        ownedItems.first { $0.itemId == itemId }?.isUnlocked ?? false
    }

    private func sortedItems(for type: Item.ItemType) -> [Item] {
        let items = registry.items(ofType: type)
        return items.sorted { item1, item2 in
            let unlocked1 = isUnlocked(itemId: item1.id)
            let unlocked2 = isUnlocked(itemId: item2.id)

            // Unlocked items first
            if unlocked1 != unlocked2 {
                return unlocked1
            }

            // Then sort by rarity (higher rarity first)
            return item1.rarity.sortOrder > item2.rarity.sortOrder
        }
    }
}

#Preview {
    CollectionView()
        .previewDataContainer()
}
