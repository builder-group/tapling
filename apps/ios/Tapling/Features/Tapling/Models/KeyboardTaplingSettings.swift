//
//  KeyboardTaplingSettings.swift
//  Tapling
//
//  Created by Benno on 03.12.25.
//

import Foundation
import SwiftData

@Model
final class KeyboardTaplingSettings: SingletonModel {
    var userScale: Double
    var userBottomOffset: Double

    var equippedFurId: String
    var equippedFaceId: String
    var equippedHatId: String?

    init(
        userScale: Double = 1.5,
        userBottomOffset: Double = 4.0,
        equippedFurId: String = "fur_white",
        equippedFaceId: String = "face_cute",
        equippedHatId: String? = nil
    ) {
        self.userScale = userScale
        self.userBottomOffset = userBottomOffset
        self.equippedFurId = equippedFurId
        self.equippedFaceId = equippedFaceId
        self.equippedHatId = equippedHatId
    }

    static var `default`: KeyboardTaplingSettings {
        KeyboardTaplingSettings()
    }

    var equippedFur: Fur {
        Fur.get(equippedFurId) ?? .default
    }

    var equippedFace: Face {
        Face.get(equippedFaceId) ?? .default
    }

    var equippedHat: Hat? {
        equippedHatId.flatMap { Hat.get($0) }
    }
}
