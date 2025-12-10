//
//  SelectableCollectibleCardView.swift
//  Tapling
//
//  Created by Benno on 09.12.25.
//

import SwiftUI

struct SelectableCollectibleCardView<ActionButtons: View>: View {
    let collectible: AnyCollectible
    let count: Int?
    let isSelected: Bool
    let onTap: () -> Void
    let actionButtons: (CGFloat) -> ActionButtons

    init(
        collectible: AnyCollectible,
        count: Int? = nil,
        isSelected: Bool,
        onTap: @escaping () -> Void,
        @ViewBuilder actionButtons: @escaping (CGFloat) -> ActionButtons
    ) {
        self.collectible = collectible
        self.count = count
        self.isSelected = isSelected
        self.onTap = onTap
        self.actionButtons = actionButtons
    }

    // MARK: - UI

    var body: some View {
        GeometryReader { geo in
            let cardSize = geo.size.width

            VStack(spacing: 0) {
                CollectibleCardView(
                    collectible: collectible,
                    count: count
                )
                .frame(width: cardSize, height: cardSize)
                .scaleEffect(isSelected ? 0.88 : 1.0)
                .zIndex(1)

                if isSelected {
                    actionButtons(cardSize)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .top)
                                    .combined(with: .opacity),
                                removal: .opacity.animation(nil)
                            )
                        )
                        .zIndex(0)
                }
            }
            .background(selectedCardBackground)
            .overlay(selectedCardBorder)
            .scaleEffect(isSelected ? 1.08 : 1.0)
            .animation(
                isSelected
                    ? .spring(
                        response: 0.35,
                        dampingFraction: 0.75
                    )
                    : nil,
                value: isSelected
            )
        }
        .aspectRatio(1, contentMode: .fit)
        .onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            onTap()
        }
    }

    @ViewBuilder
    private var selectedCardBackground: some View {
        if isSelected {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.regularMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(collectible.rarity.color.opacity(0.1))
                }
                .shadow(
                    color: .primary.opacity(0.2),
                    radius: 12,
                    y: 6
                )
        }
    }

    @ViewBuilder
    private var selectedCardBorder: some View {
        if isSelected {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.quaternary, lineWidth: 1)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedCardId: String?

        private let collectibles: [AnyCollectible] = [
            .hat(
                Hat(
                    id: "hat_propeller-hat",
                    name: "Propeller Hat",
                    rarity: .epic,
                    assetVariant: "propeller-hat"
                )
            ),
            .face(
                Face(
                    id: "face_pilot",
                    name: "Pilot",
                    rarity: .legendary,
                    assetVariant: "pilot"
                )
            ),
            .fur(
                Fur(
                    id: "fur_white",
                    name: "White",
                    rarity: .common,
                    assetVariant: "white"
                )
            ),
        ]

        var body: some View {
            ScrollView {
                Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                    GridRow {
                        ForEach(collectibles) { collectible in
                            SelectableCollectibleCardView(
                                collectible: collectible,
                                count: nil,
                                isSelected: selectedCardId == collectible.id,
                                onTap: {
                                    selectedCardId =
                                        (selectedCardId == collectible.id)
                                        ? nil : collectible.id
                                }
                            ) { cardSize in
                                CollectibleInfoUseActionButtons(
                                    cardSize: cardSize,
                                    onInfo: {
                                        print("Info: \(collectible.name)")
                                    },
                                    onUse: {
                                        print("Use: \(collectible.name)")
                                    }
                                )
                            }
                            .zIndex(selectedCardId == collectible.id ? 10 : 0)
                        }
                    }
                }
                .padding()
            }
        }
    }

    return PreviewWrapper()
}
