//
//  NativeAutocompleteService.swift
//  Tapling
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

    init(lexicon: UILexicon? = nil) {
        self.lexicon = lexicon
    }

    /// Register a lexicon to improve autocomplete suggestions.
    func registerLexicon(_ lexicon: UILexicon) {
        self.lexicon = lexicon
    }

    func autocomplete(_ text: String) async throws -> Autocomplete.Result {
        // Note: `text` contains everything before cursor, stopping at sentence boundaries.
        // Examples: "Hello world|" → "Hello world", "Jeff is| cool" → "Jeff is",
        // "Hello. World|" → "World" (stops at period)
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
        if text.isEmpty {
            return locale.keyboardLanguage.emptyTextSuggestions
        }

        var allSuggestions: [String] = []
        let language = locale.keyboardLanguage.config.localeIdentifier

        // Check if word is correctly spelled (for autocorrect detection)
        let isCorrectlySpelled =
            textChecker.rangeOfMisspelledWord(
                in: text,
                range: NSRange(location: 0, length: text.utf16.count),
                startingAt: 0,
                wrap: false,
                language: language
            ).location == NSNotFound

        // Get spell corrections for misspelled words
        var autocorrectCandidate: String?
        if !isCorrectlySpelled {
            if let guesses = textChecker.guesses(
                forWordRange: NSRange(location: 0, length: text.utf16.count),
                in: text,
                language: language
            ), let firstGuess = guesses.first {
                autocorrectCandidate = firstGuess
                allSuggestions.append(contentsOf: guesses)
            }
        }

        // Add word completions (iOS ranks these by relevance)
        if let completions = textChecker.completions(
            forPartialWordRange: NSRange(location: 0, length: text.utf16.count),
            in: text,
            language: language
        ) {
            allSuggestions.append(contentsOf: completions)
        }

        // Add lexicon matches (contacts, shortcuts, user dictionary)
        if let lexicon = lexicon {
            let lowercasedText = text.lowercased()
            for entry in lexicon.entries {
                let entryText = entry.userInput.lowercased()
                if entryText.hasPrefix(lowercasedText)
                    && entryText != lowercasedText
                {
                    allSuggestions.append(entry.userInput)
                }
            }
        }

        // Remove duplicates while preserving order
        var seen = Set<String>()
        let uniqueSuggestions = allSuggestions.filter { suggestion in
            let lowercased = suggestion.lowercased()
            guard lowercased != text.lowercased() else { return false }
            return seen.insert(lowercased).inserted
        }

        // Match capitalization from user input
        let capitalizedSuggestions = uniqueSuggestions.map { suggestion in
            matchCapitalization(suggestion: suggestion, to: text)
        }

        // Take top suggestions
        let topSuggestions = Array(
            capitalizedSuggestions.prefix(Self.maxSuggestions)
        )

        // If no suggestions, show current word in quotes
        if topSuggestions.isEmpty && !text.isEmpty {
            return [
                Autocomplete.Suggestion(
                    text: text,
                    title: "\"\(text)\""
                )
            ]
        }

        // Mark autocorrect suggestion (bold middle suggestion that auto-applies)
        return topSuggestions.enumerated().map { index, word in
            let isAutocorrect =
                (word.lowercased() == autocorrectCandidate?.lowercased())
                && index == 0 && !isCorrectlySpelled

            return Autocomplete.Suggestion(
                text: word,
                type: isAutocorrect ? .autocorrect : .regular,
                title: word
            )
        }
    }

    private func matchCapitalization(suggestion: String, to input: String)
        -> String
    {
        guard !input.isEmpty, !suggestion.isEmpty else { return suggestion }

        // If input is all lowercase, lowercase suggestion
        if input.lowercased() == input {
            return suggestion.lowercased()
        }

        // If first character is uppercase, capitalize suggestion
        if input.first!.isUppercase {
            return suggestion.prefix(1).uppercased()
                + suggestion.dropFirst().lowercased()
        }

        // If input is all uppercase, uppercase suggestion
        if input.uppercased() == input {
            return suggestion.uppercased()
        }

        // Default: return as-is
        return suggestion
    }
}
