//
//  Item.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import Foundation

/// Represents a collectible item in the game.
struct Item: Identifiable, Hashable {
    let id: String
    let name: String
    let type: ItemType
    let rarity: Rarity
    let assetName: String

    enum ItemType: String, CaseIterable {
        case hat
        case face
        case fur
    }

    enum Rarity: String, CaseIterable {
        case common
        case rare
        case epic
        case legendary

        var color: String {
            switch self {
            case .common: return "gray"
            case .rare: return "blue"
            case .epic: return "purple"
            case .legendary: return "orange"
            }
        }

        var sortOrder: Int {
            switch self {
            case .common: return 0
            case .rare: return 1
            case .epic: return 2
            case .legendary: return 3
            }
        }
    }
}
