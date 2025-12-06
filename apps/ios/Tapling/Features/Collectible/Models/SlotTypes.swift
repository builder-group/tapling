//
//  SlotTypes.swift
//  Tapling
//
//  Created by Benno on 05.12.25.
//

import Foundation

/// Phantom type markers for type-safe collectible slots.
/// These empty enums exist only at compile-time to provide type safety.

enum HatSlot {}
enum FaceSlot {}
enum FurSlot {}

/// Type aliases for clarity
typealias Hat = Collectible<HatSlot>
typealias Face = Collectible<FaceSlot>
typealias Fur = Collectible<FurSlot>
