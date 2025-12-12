//
//  CollectibleRegistry.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import Foundation

/// Single source of truth for all collectibles.
/// Access via static properties on types: `Hat.all`, `Face.default`, `Hat.get("id")`
struct CollectibleRegistry {
    static let shared = CollectibleRegistry()

    // MARK: - Hats

    let hats: [Hat] = [
        Hat(
            id: "hat_banana",
            name: "Banana",
            rarity: .common,
            assetVariant: "banana"
        ),
        Hat(
            id: "hat_lil-duck",
            name: "Lil Duck",
            rarity: .common,
            assetVariant: "lil-duck"
        ),
        Hat(
            id: "hat_propeller-hat",
            name: "Propeller Hat",
            rarity: .rare,
            assetVariant: "propeller-hat"
        ),
        Hat(
            id: "hat_heart",
            name: "Heart",
            rarity: .common,
            assetVariant: "heart"
        ),
    ]

    // MARK: - Faces

    let faces: [Face] = [
        Face(
            id: "face_asia",
            name: "Asia",
            rarity: .common,
            assetVariant: "asia"
        ),
        Face(
            id: "face_cute",
            name: "Cute",
            rarity: .common,
            assetVariant: "cute"
        ),
        Face(
            id: "face_dead",
            name: "Dead",
            rarity: .rare,
            assetVariant: "dead"
        ),
        Face(
            id: "face_harry-potter",
            name: "Harry Potter",
            rarity: .epic,
            assetVariant: "harry-potter"
        ),
        Face(
            id: "face_pilot",
            name: "Pilot",
            rarity: .rare,
            assetVariant: "pilot"
        ),
        Face(
            id: "face_pixel-cool",
            name: "Pixel Cool",
            rarity: .legendary,
            assetVariant: "pixel-cool"
        ),
        Face(
            id: "face_placeholder",
            name: "Placeholder",
            rarity: .legendary,
            assetVariant: "placeholder"
        ),
    ]

    // MARK: - Furs

    let furs: [Fur] = [
        Fur(
            id: "fur_white",
            name: "White",
            rarity: .common,
            assetVariant: "white"
        ),
        Fur(
            id: "fur_mask",
            name: "Mask",
            rarity: .legendary,
            assetVariant: "mask"
        ),
        Fur(
            id: "fur_placeholder",
            name: "Placeholder",
            rarity: .legendary,
            assetVariant: "placeholder"
        ),
    ]

    // MARK: - Defaults

    var defaultFur: Fur {
        furs.first { $0.id == "fur_white" } ?? furs[0]
    }

    var placeholderFur: Fur {
        furs.first { $0.id == "fur_placeholder" } ?? furs[0]
    }

    var defaultFace: Face {
        faces.first { $0.id == "face_cute" } ?? faces[0]
    }

    var placeholderFace: Face {
        faces.first { $0.id == "face_placeholder" } ?? faces[0]
    }

    // MARK: - Lookup

    func hat(id: String) -> Hat? {
        hats.first { $0.id == id }
    }

    func face(id: String) -> Face? {
        faces.first { $0.id == id }
    }

    func fur(id: String) -> Fur? {
        furs.first { $0.id == id }
    }

    // MARK: - Type-Erased (for UI lists)

    var allCollectibles: [AnyCollectible] {
        hats.map { .hat($0) }
            + faces.map { .face($0) }
            + furs.map { .fur($0) }
    }

    func collectibles(ofType type: AnyCollectible.SlotType) -> [AnyCollectible]
    {
        switch type {
        case .hat: return hats.map { .hat($0) }
        case .face: return faces.map { .face($0) }
        case .fur: return furs.map { .fur($0) }
        }
    }

    func collectible(id: String) -> AnyCollectible? {
        if let hat = hat(id: id) { return .hat(hat) }
        if let face = face(id: id) { return .face(face) }
        if let fur = fur(id: id) { return .fur(fur) }
        return nil
    }

    private init() {}
}
