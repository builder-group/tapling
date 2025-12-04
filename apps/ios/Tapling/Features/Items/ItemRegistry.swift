//
//  ItemRegistry.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import Foundation

/// Central registry of all available items in the game.
struct ItemRegistry {
    static let shared = ItemRegistry()

    /// All available items grouped by type.
    let allItems: [Item.ItemType: [Item]]

    /// All items as a flat array.
    var items: [Item] {
        allItems.values.flatMap { $0 }
    }

    private init() {
        allItems = [
            .hat: ItemRegistry.hatItems,
            .face: ItemRegistry.faceItems,
            .fur: ItemRegistry.furItems,
        ]
    }

    // MARK: - Item Definitions

    private static let hatItems: [Item] = [
        Item(
            id: "hat_banana",
            name: "Banana",
            type: .hat,
            rarity: .common,
            assetName: "hat_banana"
        ),
        Item(
            id: "hat_lil-duck",
            name: "Lil Duck",
            type: .hat,
            rarity: .common,
            assetName: "hat_lil-duck"
        ),
        Item(
            id: "hat_propeller-hat",
            name: "Propeller Hat",
            type: .hat,
            rarity: .rare,
            assetName: "hat_propeller-hat"
        ),
    ]

    private static let faceItems: [Item] = [
        Item(
            id: "face_asia",
            name: "Asia",
            type: .face,
            rarity: .common,
            assetName: "face_asia"
        ),
        Item(
            id: "face_cute",
            name: "Cute",
            type: .face,
            rarity: .common,
            assetName: "face_cute"
        ),
        Item(
            id: "face_dead",
            name: "Dead",
            type: .face,
            rarity: .rare,
            assetName: "face_dead"
        ),
        Item(
            id: "face_harry-potter",
            name: "Harry Potter",
            type: .face,
            rarity: .epic,
            assetName: "face_harry-potter"
        ),
        Item(
            id: "face_pilot",
            name: "Pilot",
            type: .face,
            rarity: .rare,
            assetName: "face_pilot"
        ),
        Item(
            id: "face_pixel-cool",
            name: "Pixel Cool",
            type: .face,
            rarity: .epic,
            assetName: "face_pixel-cool"
        ),
    ]

    private static let furItems: [Item] = [
        Item(
            id: "fur_white",
            name: "White",
            type: .fur,
            rarity: .common,
            assetName: "fur_white"
        )
    ]

    // MARK: - Helpers

    func item(id: String) -> Item? {
        items.first { $0.id == id }
    }

    func items(ofType type: Item.ItemType) -> [Item] {
        allItems[type] ?? []
    }
}
