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
    @Binding var selectedCardId: String?
    let onShowDetail: (AnyCollectible) -> Void

    @Namespace private var namespace
    private let registry = CollectibleRegistry.shared

    // Track visible items to prevent overlay items from expanding during rubber-band scrolling.
    // When placeholders scroll out of view, matchedGeometryEffect loses its source, causing
    // overlay items to expand and fill the grid area.
    @State private var visibleIds: Set<String> = []

    // MARK: - UI

    private var collectibles: [AnyCollectible] {
        let grouped = Dictionary(grouping: ownedCollectibles) {
            $0.collectibleId
        }

        let equippedIds: Set<String> = Set(
            [
                keyboardTapling.equippedFurId,
                keyboardTapling.equippedFaceId,
                keyboardTapling.equippedHatId,
            ].compactMap { $0 }
        )

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
            if collectibles.isEmpty {
                emptyStateView
            } else {
                collectionGridView
            }
        }
    }

    private var collectionGridView: some View {
        // NOTE: We use matchedGeometryEffect workaround for LazyVGrid zIndex support.
        // LazyVGrid doesn't properly update zIndex when selection changes, but zIndex works
        // correctly in a ZStack overlay. This approach:
        // 1. Uses invisible placeholders in LazyVGrid to define grid positions
        // 2. Renders actual cards in an overlay ZStack where zIndex works properly
        // 3. Uses matchedGeometryEffect to keep cards aligned with their grid positions
        // See: https://stackoverflow.com/questions/79428920/cant-change-zindex-of-lazyvgrid-element-to-bring-it-to-the-front-with-animation
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
            ],
            alignment: .leading,
            spacing: 12
        ) {
            // Placeholders for positioning
            ForEach(collectibles) { collectible in
                Color.clear
                    .aspectRatio(1, contentMode: .fit)
                    .matchedGeometryEffect(
                        id: collectible.id,
                        in: namespace
                    )
                    .onAppear {
                        visibleIds.insert(collectible.id)
                    }
                    .onDisappear {
                        visibleIds.remove(collectible.id)
                    }
            }
        }
        .overlay {
            // Actual visible cards in ZStack (zIndex works here)
            // Only render items whose placeholders are mounted
            ZStack {
                ForEach(collectibles.filter { visibleIds.contains($0.id) }) { collectible in
                    let isSelected = selectedCardId == collectible.id

                    SelectableCollectibleCardView(
                        collectible: collectible,
                        count: nil,
                        isSelected: isSelected,
                        onTap: { toggleSelection(collectible.id) }
                    ) { cardSize in
                        CollectibleInfoUseActionButtons(
                            cardSize: cardSize,
                            onInfo: {
                                onShowDetail(collectible)
                            },
                            onUse: {
                                equipCollectible(collectible)
                            }
                        )
                    }
                    .zIndex(isSelected ? 5 : 0)
                    .matchedGeometryEffect(
                        id: collectible.id,
                        in: namespace,
                        isSource: false
                    )
                }
            }
        }
        .padding(.bottom, 100)
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No collectibles yet")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            Text("Open cardboxes to start collecting taplings")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    private var headerSection: some View {
        Text("Collection")
            .font(.title)
            .fontWeight(.semibold)
            .foregroundStyle(.primary)
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
    struct PreviewWrapper: View {
        @State private var selectedCardId: String?

        var body: some View {
            ScrollView {
                CardCollectionView(
                    selectedCardId: $selectedCardId,
                    onShowDetail: { collectible in
                        print("Info: \(collectible.name)")
                    }
                )
                .padding()
            }
        }
    }

    return PreviewWrapper()
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

#Preview("Empty State") {
    struct PreviewWrapper: View {
        @State private var selectedCardId: String?

        var body: some View {
            ScrollView {
                CardCollectionView(
                    selectedCardId: $selectedCardId,
                    onShowDetail: { collectible in
                        print("Info: \(collectible.name)")
                    }
                )
            }
        }
    }

    return PreviewWrapper()
        .previewDataContainer()
        .padding()
}
