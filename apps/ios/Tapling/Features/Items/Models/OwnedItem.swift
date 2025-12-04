//
//  OwnedItem.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import Foundation
import SwiftData

@Model
final class OwnedItem {
    var itemId: String
    var unlockedAt: Date?

    init(itemId: String, unlockedAt: Date? = nil) {
        self.itemId = itemId
        self.unlockedAt = unlockedAt
    }

    var isUnlocked: Bool {
        unlockedAt != nil
    }
}
