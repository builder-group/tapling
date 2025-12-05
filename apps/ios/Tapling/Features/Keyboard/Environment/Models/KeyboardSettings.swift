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
    var languageCode: String

    var language: KeyboardLanguage {
        get { KeyboardLanguage(rawValue: languageCode) ?? .system }
        set { languageCode = newValue.rawValue }
    }

    init(
        debug: Bool = false,
        isPreviewMode: Bool = false,
        language: KeyboardLanguage = .system
    ) {
        self.debug = debug
        self.isPreviewMode = isPreviewMode
        self.languageCode = language.rawValue
    }

    static var `default`: KeyboardSettings {
        KeyboardSettings()
    }
}
