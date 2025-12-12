//
//  GameConfig.swift
//  Tapling
//
//  Created by Benno on 12.12.25.
//

import Foundation

enum GameConfig {
    static let cardboardBoxCost: Int = 5000
    static let initialKeycaps: Int = 5000

    /// Upgrade chances per tap. Target distribution: Common ~60%, Rare ~25%, Epic ~12%, Legendary ~3%
    /// Sequential chain over 4 taps: Common → Rare → Epic → Legendary
    static let upgradeChanceToRare: Double = 0.12
    static let upgradeChanceToEpic: Double = 0.275
    static let upgradeChanceToLegendary: Double = 0.275
}
