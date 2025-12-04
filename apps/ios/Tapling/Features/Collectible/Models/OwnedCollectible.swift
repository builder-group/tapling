//
//  OwnedCollectible.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import Foundation
import SwiftData

@Model
final class OwnedCollectible {
    var collectibleId: String
    var unlockedAt: Date?

    init(collectibleId: String, unlockedAt: Date? = nil) {
        self.collectibleId = collectibleId
        self.unlockedAt = unlockedAt
    }

    var isUnlocked: Bool {
        unlockedAt != nil
    }
}

