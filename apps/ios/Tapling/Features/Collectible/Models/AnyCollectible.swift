//
//  AnyCollectible.swift
//  Tapling
//
//  Created by Benno on 05.12.25.
//

import Foundation
import SwiftUI

/// Type-erased wrapper for displaying collectibles in lists/UI.
/// Used when we need to show all collectibles regardless of slot type.
enum AnyCollectible: Identifiable, Hashable {
    case hat(Hat)
    case face(Face)
    case fur(Fur)

    var id: String {
        switch self {
        case .hat(let c): return c.id
        case .face(let c): return c.id
        case .fur(let c): return c.id
        }
    }

    var name: String {
        switch self {
        case .hat(let c): return c.name
        case .face(let c): return c.name
        case .fur(let c): return c.name
        }
    }

    var rarity: Rarity {
        switch self {
        case .hat(let c): return c.rarity
        case .face(let c): return c.rarity
        case .fur(let c): return c.rarity
        }
    }

    var isHidden: Bool {
        switch self {
        case .hat(let c): return c.isHidden
        case .face(let c): return c.isHidden
        case .fur(let c): return c.isHidden
        }
    }

    var slotType: SlotType {
        switch self {
        case .hat: return .hat
        case .face: return .face
        case .fur: return .fur
        }
    }

    /// Slot type enum for filtering and display purposes.
    enum SlotType: String, CaseIterable {
        case hat
        case face
        case fur
    }
}
