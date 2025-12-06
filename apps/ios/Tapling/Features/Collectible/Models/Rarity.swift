//
//  Rarity.swift
//  Tapling
//
//  Created by Benno on 05.12.25.
//

import Foundation
import SwiftUI

enum Rarity: String, CaseIterable, Comparable, Codable {
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

    var sortOrder: Int {
        switch self {
        case .common: return 0
        case .rare: return 1
        case .epic: return 2
        case .legendary: return 3
        }
    }

    static func < (lhs: Rarity, rhs: Rarity) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }
}
