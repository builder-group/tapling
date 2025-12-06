//
//  KeyboardLanguage.swift
//  Tapling
//
//  Created by Benno on 05.12.25.
//

import Foundation
import KeyboardKit

enum KeyboardLanguage: String, CaseIterable, Identifiable {
    case system = "system"
    case english = "en"
    case german = "de"
    case spanish = "es"

    var id: String { rawValue }

    var config: LanguageConfig {
        switch self {
        case .system:
            // System resolves to actual language at runtime
            return Locale.current.keyboardLanguage.config

        case .english:
            return LanguageConfig(
                displayName: "English",
                localeIdentifier: "en",
                layout: .qwerty,
                emptyTextSuggestions: [
                    Autocomplete.Suggestion(text: "I", title: "I"),
                    Autocomplete.Suggestion(text: "The", title: "The"),
                    Autocomplete.Suggestion(text: "I'm", title: "I'm"),
                ],
                primaryCurrency: "$",
                currencies: ["$", "€", "£", "¥"]
            )

        case .german:
            return LanguageConfig(
                displayName: "German",
                localeIdentifier: "de",
                layout: .init(rows: [
                    .init(chars: "qwertzuiopü"),
                    .init(chars: "asdfghjklöä"),
                    .init(chars: "yxcvbnm"),
                ]),
                emptyTextSuggestions: [
                    Autocomplete.Suggestion(text: "Ich", title: "Ich"),
                    Autocomplete.Suggestion(text: "Ja", title: "Ja"),
                    Autocomplete.Suggestion(text: "Das", title: "Das"),
                ],
                primaryCurrency: "€",
                currencies: ["€", "$", "£", "¥"]
            )

        case .spanish:
            return LanguageConfig(
                displayName: "Spanish",
                localeIdentifier: "es",
                layout: .qwerty,
                emptyTextSuggestions: [
                    Autocomplete.Suggestion(text: "El", title: "El"),
                    Autocomplete.Suggestion(text: "La", title: "La"),
                    Autocomplete.Suggestion(text: "Yo", title: "Yo"),
                ],
                primaryCurrency: "€",
                currencies: ["€", "$", "£", "¥"]
            )
        }
    }

    var displayName: String {
        switch self {
        case .system:
            return "System Default"
        case .english:
            return "English"
        case .german:
            return "German"
        case .spanish:
            return "Spanish"
        }
    }

    var displayNameWithResolved: String {
        if self == .system {
            let resolved = Locale.current.keyboardLanguage
            if resolved != .system {
                return "System Default (\(resolved.displayName))"
            }
        }
        return displayName
    }

    var localeIdentifier: String? {
        self == .system ? nil : config.localeIdentifier
    }

    var layout: KeyboardLayout.InputSet {
        config.layout
    }

    var emptyTextSuggestions: [Autocomplete.Suggestion] {
        config.emptyTextSuggestions
    }

    var primaryCurrency: String {
        config.primaryCurrency
    }

    var currencies: [String] {
        config.currencies
    }
}

struct LanguageConfig {
    let displayName: String
    let localeIdentifier: String
    let layout: KeyboardLayout.InputSet
    let emptyTextSuggestions: [Autocomplete.Suggestion]
    let primaryCurrency: String
    let currencies: [String]
}

extension KeyboardContext {

    /// Returns the KeyboardLanguage based on the context's locale
    var keyboardLanguage: KeyboardLanguage {
        locale.keyboardLanguage
    }
}

extension Locale {

    /// Returns the KeyboardLanguage based on the locale's language code
    var keyboardLanguage: KeyboardLanguage {
        guard let languageCode = language.languageCode?.identifier else {
            return .english
        }

        // Map language code to KeyboardLanguage
        return KeyboardLanguage(rawValue: languageCode) ?? .english
    }
}
