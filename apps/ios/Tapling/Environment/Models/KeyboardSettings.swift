//
//  KeyboardSettings.swift
//  Tapling
//
//  Created by Benno on 03.12.25.
//

import Foundation
import SwiftData

@Model
final class KeyboardSettings: SingletonModel {
    var debug: Bool

    init(debug: Bool = false) {
        self.debug = debug
    }
    
    static var `default`: KeyboardSettings {
        KeyboardSettings()
    }
}
