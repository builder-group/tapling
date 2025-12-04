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
    var isPreviewMode: Bool

    init(debug: Bool = false, isPreviewMode: Bool = false) {
        self.debug = debug
        self.isPreviewMode = isPreviewMode
    }

    static var `default`: KeyboardSettings {
        KeyboardSettings()
    }
}
