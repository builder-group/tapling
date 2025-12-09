//
//  SelectableCollectibleCardView.swift
//  Tapling
//
//  Created by Benno on 09.12.25.
//

import SwiftUI

struct SelectableCollectibleCardView: View {
    let collectible: AnyCollectible
    let count: Int
    let isSelected: Bool
    let onTap: () -> Void
    let onInfo: () -> Void
    let onUse: () -> Void

    // MARK: - UI

    var body: some View {
        ZStack(alignment: .top) {
            Color.clear
                .aspectRatio(1, contentMode: .fit)

            GeometryReader { geo in
                let cardSize = geo.size.width

                VStack(spacing: 0) {
                    CollectibleCardView(
                        collectible: collectible,
                        count: count
                    )
                    .frame(width: cardSize, height: cardSize)
                    .zIndex(1)

                    if isSelected {
                        actionButtons(cardSize: cardSize)
                            .transition(
                                .move(edge: .top).combined(with: .opacity)
                            )
                            .zIndex(0)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.white)
                        .shadow(
                            color: isSelected ? .black.opacity(0.2) : .clear,
                            radius: isSelected ? 8 : 0,
                            y: isSelected ? 4 : 0
                        )
                )
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .animation(
                    isSelected
                        ? .spring(response: 0.3, dampingFraction: 0.7)
                        : nil,
                    value: isSelected
                )

            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onTapGesture(perform: onTap)
    }

    private func actionButtons(cardSize: CGFloat) -> some View {
        VStack(spacing: 4) {
            Button(action: onUse) {
                Text("Use")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(
                        LinearGradient(
                            colors: [Color.orange, Color.orange.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(8)
            }

            Button(action: onInfo) {
                Text("Info")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .frame(width: cardSize)
    }
}

#Preview {
    struct PreviewWithState: View {
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
                                count: 3,
                                isSelected: selectedCardId == collectible.id,
                                onTap: {
                                    selectedCardId =
                                        (selectedCardId == collectible.id)
                                        ? nil : collectible.id
                                },
                                onInfo: {
                                    print("Info: \(collectible.name)")
                                },
                                onUse: {
                                    print("Use: \(collectible.name)")
                                }
                            )
                            .zIndex(selectedCardId == collectible.id ? 10 : 0)
                        }
                    }
                }
                .padding()
            }
        }
    }

    return PreviewWithState()
}
