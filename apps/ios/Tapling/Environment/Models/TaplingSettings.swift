//
//  TaplingSettings.swift
//  Tapling
//
//  Created by Benno on 03.12.25.
//

import Foundation
import SwiftData

@Model
final class TaplingSettings: SingletonModel {
    var userScale: Double
    var userBottomOffset: Double

    init(
        userScale: Double = 1.5,
        userBottomOffset: Double = 4.0
    ) {
        self.userScale = userScale
        self.userBottomOffset = userBottomOffset
    }
    
    static var `default`: TaplingSettings {
        TaplingSettings()
    }
}
