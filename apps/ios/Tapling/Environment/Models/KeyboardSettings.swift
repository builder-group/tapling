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

enum KeyboardLanguage: String, CaseIterable, Identifiable {
    case system = "system"
    case english = "en"
    case german = "de"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .system: return "System Default"
        case .english: return "English"
        case .german: return "German"
        }
    }

    /// Returns the Locale identifier if this is a specific language, or nil for system default
    var localeIdentifier: String? {
        switch self {
        case .system: return nil
        case .english: return "en"
        case .german: return "de"
        }
    }
}
