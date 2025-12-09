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

    var player: Player

    init(collectibleId: String, unlockedAt: Date? = nil, player: Player) {
        self.collectibleId = collectibleId
        self.unlockedAt = unlockedAt
        self.player = player
    }

    var isUnlocked: Bool {
        unlockedAt != nil
    }
}
