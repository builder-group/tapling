//
//  Collectible.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import Foundation

/// A generic collectible parameterized by its slot type.
/// The phantom type `Slot` provides compile-time type safety.
struct Collectible<Slot>: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let rarity: Rarity
    let assetVariant: String
}

// MARK: - Hat

extension Collectible where Slot == HatSlot {
    static var all: [Hat] { CollectibleRegistry.shared.hats }

    static func get(_ id: String) -> Hat? {
        CollectibleRegistry.shared.hat(id: id)
    }

    func assetName() -> String {
        "hat_\(assetVariant)"
    }
}

// MARK: - Face

extension Collectible where Slot == FaceSlot {
    static var all: [Face] { CollectibleRegistry.shared.faces }
    static var `default`: Face { CollectibleRegistry.shared.defaultFace }
    static var placeholder: Face { CollectibleRegistry.shared.placeholderFace }

    static func get(_ id: String) -> Face? {
        CollectibleRegistry.shared.face(id: id)
    }

    func assetName() -> String {
        "face_\(assetVariant)"
    }
}

// MARK: - Fur

extension Collectible where Slot == FurSlot {
    static var all: [Fur] { CollectibleRegistry.shared.furs }
    static var `default`: Fur { CollectibleRegistry.shared.defaultFur }
    static var placeholder: Fur { CollectibleRegistry.shared.placeholderFur }

    static func get(_ id: String) -> Fur? {
        CollectibleRegistry.shared.fur(id: id)
    }

    func baseAssetName() -> String {
        "fur_\(assetVariant)_base"
    }

    func leftHandAssetName(_ position: HandPosition) -> String {
        "fur_\(assetVariant)_left-\(position.rawValue)"
    }

    func rightHandAssetName(_ position: HandPosition) -> String {
        "fur_\(assetVariant)_right-\(position.rawValue)"
    }
}
