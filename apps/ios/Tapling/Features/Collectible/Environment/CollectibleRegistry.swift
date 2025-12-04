//
//  CollectibleRegistry.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import Foundation

/// Central registry of all available collectibles in the game.
struct CollectibleRegistry {
    static let shared = CollectibleRegistry()

    /// All available collectibles grouped by type.
    let allCollectibles: [Collectible.CollectibleType: [Collectible]]

    /// All collectibles as a flat array.
    var collectibles: [Collectible] {
        allCollectibles.values.flatMap { $0 }
    }

    private init() {
        allCollectibles = [
            .hat: CollectibleRegistry.hatCollectibles,
            .face: CollectibleRegistry.faceCollectibles,
            .fur: CollectibleRegistry.furCollectibles,
        ]
    }

    // MARK: - Collectible Definitions

    private static let hatCollectibles: [Collectible] = [
        Collectible(
            id: "hat_banana",
            name: "Banana",
            type: .hat,
            rarity: .common,
            assetName: "hat_banana"
        ),
        Collectible(
            id: "hat_lil-duck",
            name: "Lil Duck",
            type: .hat,
            rarity: .common,
            assetName: "hat_lil-duck"
        ),
        Collectible(
            id: "hat_propeller-hat",
            name: "Propeller Hat",
            type: .hat,
            rarity: .rare,
            assetName: "hat_propeller-hat"
        ),
    ]

    private static let faceCollectibles: [Collectible] = [
        Collectible(
            id: "face_asia",
            name: "Asia",
            type: .face,
            rarity: .common,
            assetName: "face_asia"
        ),
        Collectible(
            id: "face_cute",
            name: "Cute",
            type: .face,
            rarity: .common,
            assetName: "face_cute"
        ),
        Collectible(
            id: "face_dead",
            name: "Dead",
            type: .face,
            rarity: .rare,
            assetName: "face_dead"
        ),
        Collectible(
            id: "face_harry-potter",
            name: "Harry Potter",
            type: .face,
            rarity: .epic,
            assetName: "face_harry-potter"
        ),
        Collectible(
            id: "face_pilot",
            name: "Pilot",
            type: .face,
            rarity: .rare,
            assetName: "face_pilot"
        ),
        Collectible(
            id: "face_pixel-cool",
            name: "Pixel Cool",
            type: .face,
            rarity: .epic,
            assetName: "face_pixel-cool"
        ),
    ]

    private static let furCollectibles: [Collectible] = [
        Collectible(
            id: "fur_white",
            name: "White",
            type: .fur,
            rarity: .common,
            assetName: "fur_white"
        )
    ]

    // MARK: - Helpers

    func collectible(id: String) -> Collectible? {
        collectibles.first { $0.id == id }
    }

    func collectibles(ofType type: Collectible.CollectibleType) -> [Collectible] {
        allCollectibles[type] ?? []
    }
}

