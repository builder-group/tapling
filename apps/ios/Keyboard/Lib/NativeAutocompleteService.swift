//
//  NativeAutocompleteService.swift
//  Keyboard
//
//  Created by Benno on 02.12.25.
//

import KeyboardKit
import UIKit

/// Autocomplete service using native iOS APIs (UILexicon and UITextChecker).
class NativeAutocompleteService: AutocompleteService {
    var locale: Locale = .current
    var canIgnoreWords: Bool { false }
    var canLearnWords: Bool { false }
    var ignoredWords: [String] = []
    var learnedWords: [String] = []

    private var lexicon: UILexicon?
    private let textChecker = UITextChecker()

    private static let maxSuggestions = 3

    func setLexicon(_ lexicon: UILexicon) {
        self.lexicon = lexicon
    }

    func autocomplete(_ text: String) async throws -> Autocomplete.Result {
        let currentWord = extractCurrentWord(from: text)
        let suggestions = getSuggestions(for: currentWord)
        return Autocomplete.Result(
            inputText: text,
            suggestions: suggestions
        )
    }

    func hasIgnoredWord(_ word: String) -> Bool {
        ignoredWords.contains(word)
    }

    func hasLearnedWord(_ word: String) -> Bool {
        learnedWords.contains(word)
    }

    func ignoreWord(_ word: String) {
        // Not implemented
    }

    func learnWord(_ word: String) {
        // Not implemented
    }

    func removeIgnoredWord(_ word: String) {
        // Not implemented
    }

    func unlearnWord(_ word: String) {
        // Not implemented
    }

    private func extractCurrentWord(from text: String) -> String {
        // Extract the last word being typed (everything after the last space)
        let components = text.split(
            separator: " ",
            omittingEmptySubsequences: false
        )

        // If there are spaces, get the last component (current word being typed)
        if components.count > 1, let lastComponent = components.last {
            return String(lastComponent)
        }

        // If no spaces, the whole text is the current word
        return text
    }

    private func getSuggestions(for text: String) -> [Autocomplete.Suggestion] {
        // Provide suggestions for empty text (sentence starters)
        if text.isEmpty {
            return getEmptyTextSuggestions()
        }

        var suggestions: [String] = []

        // 1. Use UILexicon (user's contacts, shortcuts, common words)
        if let lexicon = lexicon {
            let lowercasedText = text.lowercased()
            for entry in lexicon.entries {
                let entryText = entry.userInput.lowercased()
                if entryText.hasPrefix(lowercasedText)
                    && entryText != lowercasedText
                {
                    suggestions.append(entry.userInput)
                }
            }
        }

        // 2. Use UITextChecker for spell checking and word completions
        let range = NSRange(location: 0, length: text.utf16.count)
        let language = getLanguageCode()
        if let completions = textChecker.completions(
            forPartialWordRange: range,
            in: text,
            language: language
        ) {
            suggestions.append(contentsOf: completions)
        }

        // Remove duplicates, filter out exact matches, and sort by length (shorter = more common)
        let lowercasedText = text.lowercased()
        let uniqueSuggestions = Array(Set(suggestions))
            .filter { $0.lowercased() != lowercasedText }
            .sorted { word1, word2 in
                if word1.count != word2.count {
                    return word1.count < word2.count
                }
                return word1 < word2
            }
            .prefix(Self.maxSuggestions)

        // If no suggestions found, show the current word as fallback (wrapped in quotes)
        if uniqueSuggestions.isEmpty && !text.isEmpty {
            return [
                Autocomplete.Suggestion(
                    text: text,
                    title: "\"\(text)\""
                )
            ]
        }

        return uniqueSuggestions.map { word in
            Autocomplete.Suggestion(
                text: word,
                title: word
            )
        }
    }

    private func getEmptyTextSuggestions() -> [Autocomplete.Suggestion] {
        let languageCode = getLanguageCode()

        switch languageCode {
        case "es":  // Spanish
            return [
                Autocomplete.Suggestion(text: "El", title: "El"),
                Autocomplete.Suggestion(text: "La", title: "La"),
                Autocomplete.Suggestion(text: "Yo", title: "Yo"),
            ]
        case "fr":  // French
            return [
                Autocomplete.Suggestion(text: "Le", title: "Le"),
                Autocomplete.Suggestion(text: "La", title: "La"),
                Autocomplete.Suggestion(text: "Je", title: "Je"),
            ]
        case "de":  // German
            return [
                Autocomplete.Suggestion(text: "Der", title: "Der"),
                Autocomplete.Suggestion(text: "Die", title: "Die"),
                Autocomplete.Suggestion(text: "Ich", title: "Ich"),
            ]
        case "it":  // Italian
            return [
                Autocomplete.Suggestion(text: "Il", title: "Il"),
                Autocomplete.Suggestion(text: "La", title: "La"),
                Autocomplete.Suggestion(text: "Io", title: "Io"),
            ]
        case "pt":  // Portuguese
            return [
                Autocomplete.Suggestion(text: "O", title: "O"),
                Autocomplete.Suggestion(text: "A", title: "A"),
                Autocomplete.Suggestion(text: "Eu", title: "Eu"),
            ]
        case "nl":  // Dutch
            return [
                Autocomplete.Suggestion(text: "De", title: "De"),
                Autocomplete.Suggestion(text: "Het", title: "Het"),
                Autocomplete.Suggestion(text: "Ik", title: "Ik"),
            ]
        default:  // English and others
            return [
                Autocomplete.Suggestion(text: "I", title: "I"),
                Autocomplete.Suggestion(text: "The", title: "The"),
                Autocomplete.Suggestion(text: "You", title: "You"),
            ]
        }
    }

    private func getLanguageCode() -> String {
        locale.language.languageCode?.identifier ?? "en"
    }
}
