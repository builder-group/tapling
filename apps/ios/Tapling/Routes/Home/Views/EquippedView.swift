//
//  EquippedView.swift
//  Tapling
//
//  Created by Benno on 09.12.25.
//

import SwiftData
import SwiftUI

struct EquippedView: View {
    @Environment(\.modelContext) private var modelContext
    @QuerySingleton private var keyboardTapling: KeyboardTapling
    @Binding var selectedCardId: String?
    let onShowDetail: (AnyCollectible) -> Void

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerSection
            traitsRow
        }
        .padding(.horizontal, 16)
    }

    private var headerSection: some View {
        Text("Equipped")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(.primary)
    }

    private var traitsRow: some View {
        HStack(spacing: 12) {
            if let furCollectible = equippedFurCollectible {
                equippedCard(
                    collectible: furCollectible,
                    title: "Fur",
                    canRemove: false
                )
            }

            if let faceCollectible = equippedFaceCollectible {
                equippedCard(
                    collectible: faceCollectible,
                    title: "Face",
                    canRemove: false
                )
            }

            if let hatCollectible = equippedHatCollectible {
                equippedCard(
                    collectible: hatCollectible,
                    title: "Hat",
                    canRemove: true
                )
            } else {
                emptySlot(title: "Hat")
            }
        }
    }

    private func equippedCard(
        collectible: AnyCollectible,
        title: String,
        canRemove: Bool
    ) -> some View {
        VStack(spacing: 8) {
            SelectableCollectibleCardView(
                collectible: collectible,
                count: nil,
                isSelected: selectedCardId == collectible.id,
                onTap: { toggleSelection(collectible.id) }
            ) { cardSize in
                CollectibleInfoRemoveActionButtons(
                    cardSize: cardSize,
                    onInfo: {
                        onShowDetail(collectible)
                    },
                    onRemove: {
                        removeCollectible(collectible)
                    },
                    canRemove: canRemove
                )
            }
            .frame(maxWidth: .infinity)
            .zIndex(selectedCardId == collectible.id ? 5 : 0)

            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
    }

    private func emptySlot(title: String) -> some View {
        VStack(spacing: 8) {
            EquippedCollectibleCardView(collectible: nil)
                .frame(maxWidth: .infinity)

            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
        }
    }

    private var equippedFurCollectible: AnyCollectible? {
        .fur(keyboardTapling.equippedFur)
    }

    private var equippedFaceCollectible: AnyCollectible? {
        .face(keyboardTapling.equippedFace)
    }

    private var equippedHatCollectible: AnyCollectible? {
        keyboardTapling.equippedHat.map { .hat($0) }
    }

    // MARK: - Actions

    private func toggleSelection(_ id: String) {
        selectedCardId = (selectedCardId == id) ? nil : id
    }

    private func removeCollectible(_ collectible: AnyCollectible) {
        switch collectible.slotType {
        case .hat:
            keyboardTapling.equippedHatId = nil
        case .fur, .face:
            break
        }
        try? modelContext.save()
        selectedCardId = nil
    }
}

#Preview {
    EquippedView(selectedCardId: .constant(nil), onShowDetail: { _ in })
        .previewDataContainer()
}
