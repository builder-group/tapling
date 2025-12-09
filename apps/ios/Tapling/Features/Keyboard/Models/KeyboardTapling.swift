//
//  KeyboardTapling.swift
//  Tapling
//
//  Created by Benno on 09.12.25.
//

import Foundation
import SwiftData

@Model
final class KeyboardTapling: SingletonModel {
    var equippedFurId: String
    var equippedFaceId: String
    var equippedHatId: String?

    init(
        equippedFurId: String = "fur_white",
        equippedFaceId: String = "face_cute",
        equippedHatId: String? = nil
    ) {
        self.equippedFurId = equippedFurId
        self.equippedFaceId = equippedFaceId
        self.equippedHatId = equippedHatId
    }

    static var `default`: KeyboardTapling {
        KeyboardTapling()
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
