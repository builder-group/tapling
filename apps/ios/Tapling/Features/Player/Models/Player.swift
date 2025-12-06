//
//  Player.swift
//  Tapling
//
//  Created by Benno on 06.12.25.
//

import Foundation
import SwiftData

@Model
final class Player: SingletonModel {

    var currentKeycaps: Int
    var totalKeycapsEarned: Int

    var totalKeystrokes: Int
    var firstActiveDate: Date?
    var lastActiveDate: Date?

    //    @Relationship(deleteRule: .cascade, inverse: \OwnedCollectible.player)
    //    var ownedCollectibles: [OwnedCollectible]

    init(
        currentKeycaps: Int = 0,
        totalKeycapsEarned: Int = 0,
        totalKeystrokes: Int = 0,
        firstActiveDate: Date? = nil,
        lastActiveDate: Date? = nil,
        // ownedCollectibles: [OwnedCollectible]
    ) {
        self.currentKeycaps = currentKeycaps
        self.totalKeycapsEarned = totalKeycapsEarned
        self.totalKeystrokes = totalKeystrokes
        self.firstActiveDate = firstActiveDate
        self.lastActiveDate = lastActiveDate
        // self.ownedCollectibles = ownedCollectibles
    }

    static var `default`: Player {
        Player()
    }

}
