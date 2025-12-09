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
    var autocorrectEnabled: Bool
    var autocompleteEnabled: Bool
    var emojiPickerEnabled: Bool

    var trackSessions: Bool

    var taplingScale: Double
    var taplingBottomOffset: Double

    var language: KeyboardLanguage {
        get { KeyboardLanguage(rawValue: languageCode) ?? .system }
        set { languageCode = newValue.rawValue }
    }

    init(
        debug: Bool = false,
        isPreviewMode: Bool = false,
        language: KeyboardLanguage = .system,
        autocorrectEnabled: Bool = true,
        autocompleteEnabled: Bool = true,
        emojiPickerEnabled: Bool = false,
        taplingScale: Double = 1.5,
        taplingBottomOffset: Double = 4.0,
        trackSessions: Bool = true
    ) {
        self.debug = debug
        self.isPreviewMode = isPreviewMode
        self.languageCode = language.rawValue
        self.autocorrectEnabled = autocorrectEnabled
        self.autocompleteEnabled = autocompleteEnabled
        self.emojiPickerEnabled = emojiPickerEnabled
        self.taplingScale = taplingScale
        self.taplingBottomOffset = taplingBottomOffset
        self.trackSessions = trackSessions
    }

    static var `default`: KeyboardSettings {
        KeyboardSettings()
    }
}
