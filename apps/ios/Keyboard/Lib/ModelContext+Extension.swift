//
//  ModelContext+Extension.swift
//  Keyboard
//
//  Created by Benno on 07.12.25.
//

import Foundation
import SwiftData

extension ModelContext {
    func fetchKeyboardSettings() -> KeyboardSettings {
        (try? fetch(FetchDescriptor<KeyboardSettings>()).first)
            ?? KeyboardSettings.default
    }
}
