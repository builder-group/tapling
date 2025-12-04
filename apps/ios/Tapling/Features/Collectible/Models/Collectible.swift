//
//  Collectible.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import Foundation
import SwiftUI

/// Represents a collectible item in the game.
struct Collectible: Identifiable, Hashable {
    let id: String
    let name: String
    let type: CollectibleType
    let rarity: Rarity
    let assetName: String

    enum CollectibleType: String, CaseIterable {
        case hat
        case face
        case fur
    }

    enum Rarity: String, CaseIterable, Comparable {
        case common
        case rare
        case epic
        case legendary

        var color: Color {
            switch self {
            case .common: return .gray
            case .rare: return .blue
            case .epic: return .purple
            case .legendary: return .orange
            }
        }

        var order: Int {
            switch self {
            case .common: return 0
            case .rare: return 1
            case .epic: return 2
            case .legendary: return 3
            }
        }

        var sortOrder: Int {
            order
        }

        static func < (lhs: Rarity, rhs: Rarity) -> Bool {
            lhs.order < rhs.order
        }
    }
}

