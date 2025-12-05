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
    var languageCode: String // "system", "en", "de"

    init(
        debug: Bool = false,
        isPreviewMode: Bool = false,
        languageCode: String = "system"
    ) {
        self.debug = debug
        self.isPreviewMode = isPreviewMode
        self.languageCode = languageCode
    }

    static var `default`: KeyboardSettings {
        KeyboardSettings()
    }
}
