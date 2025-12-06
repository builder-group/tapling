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
    var autocorrectEnabled: Bool = true
    var autocompleteEnabled: Bool = true
    var canIgnoreWords: Bool { false }
    var canLearnWords: Bool { false }
    var ignoredWords: [String] = []
    var learnedWords: [String] = []

    private var lexicon: UILexicon?
    private let textChecker = UITextChecker()
    private static let maxSuggestions = 3
    private static let manyCompletionsThreshold = 5

    init(lexicon: UILexicon? = nil) {
        self.lexicon = lexicon
    }

    func registerLexicon(_ lexicon: UILexicon) {
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

    func ignoreWord(_ word: String) {}
    func learnWord(_ word: String) {}
    func removeIgnoredWord(_ word: String) {}
    func unlearnWord(_ word: String) {}

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

    /// Main suggestion algorithm: prioritizes completions over autocorrect when we have many good matches.
    /// Strategy: If user typed "hel" (many completions), show completions. If "helo" (few completions), show autocorrect.
    private func getSuggestions(for text: String) -> [Autocomplete.Suggestion] {
        if text.isEmpty {
            return autocompleteEnabled
                ? locale.keyboardLanguage.emptyTextSuggestions : []
        }

        guard autocompleteEnabled else {
            // If autocomplete is disabled, only show current word in quotes if it's not empty
            return [Autocomplete.Suggestion(text: text, title: "\"\(text)\"")]
        }

        let language = locale.keyboardLanguage.config.localeIdentifier
        let isCorrectlySpelled = isWordCorrectlySpelled(
            text,
            language: language
        )

        let inputCompletions = getInputCompletions(text, language: language)
        let (autocorrectCandidate, autocorrectCompletions) =
            getAutocorrectIfNeeded(
                text: text,
                isCorrectlySpelled: isCorrectlySpelled,
                inputCompletions: inputCompletions,
                language: language
            )

        var allSuggestions = buildSuggestionList(
            autocorrectCandidate: autocorrectCandidate,
            autocorrectCompletions: autocorrectCompletions,
            inputCompletions: inputCompletions
        )

        addLexiconMatches(to: &allSuggestions, for: text)

        let uniqueSuggestions = deduplicateSuggestions(
            allSuggestions,
            excluding: text
        )
        let capitalizedSuggestions = uniqueSuggestions.map {
            matchCapitalization(suggestion: $0, to: text)
        }
        // Take top 2 suggestions (current word will be added as first, total = 3)
        let topSuggestions = Array(capitalizedSuggestions.prefix(2))

        if topSuggestions.isEmpty && !text.isEmpty {
            return [Autocomplete.Suggestion(text: text, title: "\"\(text)\"")]
        }

        return buildFinalSuggestions(
            currentWord: text,
            topSuggestions: topSuggestions,
            autocorrectCandidate: autocorrectCandidate
        )
    }

    private func isWordCorrectlySpelled(_ text: String, language: String)
        -> Bool
    {
        textChecker.rangeOfMisspelledWord(
            in: text,
            range: NSRange(location: 0, length: text.utf16.count),
            startingAt: 0,
            wrap: false,
            language: language
        ).location == NSNotFound
    }

    private func getInputCompletions(_ text: String, language: String)
        -> [String]
    {
        textChecker.completions(
            forPartialWordRange: NSRange(location: 0, length: text.utf16.count),
            in: text,
            language: language
        ) ?? []
    }

    /// Determines if autocorrect should be used instead of input completions.
    /// Rule: Use autocorrect only if enabled, first guess doesn't start with input AND we have few completions.
    /// This prevents autocorrect from overriding good partial word matches (e.g., "hel" → "hello", "help").
    private func getAutocorrectIfNeeded(
        text: String,
        isCorrectlySpelled: Bool,
        inputCompletions: [String],
        language: String
    ) -> (candidate: String?, completions: [String]) {
        guard autocorrectEnabled,
            !isCorrectlySpelled,
            let guesses = textChecker.guesses(
                forWordRange: NSRange(location: 0, length: text.utf16.count),
                in: text,
                language: language
            ),
            !guesses.isEmpty,
            let firstGuess = guesses.first
        else {
            return (nil, [])
        }

        // Prefer completions over autocorrect when we have many good matches
        let hasManyCompletions =
            inputCompletions.count >= Self.manyCompletionsThreshold
        let firstGuessLower = firstGuess.lowercased()
        let inputLower = text.lowercased()

        // Only use autocorrect if first guess is a correction (doesn't start with input)
        // AND we don't have many completions to show instead
        guard !firstGuessLower.hasPrefix(inputLower) && !hasManyCompletions
        else {
            return (nil, [])
        }

        let autocorrectCompletions = getAutocorrectCompletions(
            firstGuess,
            language: language
        )
        return (firstGuess, autocorrectCompletions)
    }

    private func getAutocorrectCompletions(
        _ autocorrect: String,
        language: String
    ) -> [String] {
        guard
            let completions = textChecker.completions(
                forPartialWordRange: NSRange(
                    location: 0,
                    length: autocorrect.utf16.count
                ),
                in: autocorrect,
                language: language
            )
        else {
            return []
        }

        let autocorrectLower = autocorrect.lowercased()
        return completions.filter {
            $0.lowercased() != autocorrectLower && $0.count > autocorrect.count
        }
    }

    private func buildSuggestionList(
        autocorrectCandidate: String?,
        autocorrectCompletions: [String],
        inputCompletions: [String]
    ) -> [String] {
        if let autocorrect = autocorrectCandidate {
            return [autocorrect] + autocorrectCompletions
        } else {
            return inputCompletions
        }
    }

    private func addLexiconMatches(
        to suggestions: inout [String],
        for text: String
    ) {
        guard let lexicon = lexicon else { return }
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

    private func deduplicateSuggestions(
        _ suggestions: [String],
        excluding text: String
    ) -> [String] {
        var seen = Set<String>()
        let textLower = text.lowercased()
        return suggestions.filter { suggestion in
            let lowercased = suggestion.lowercased()
            guard lowercased != textLower else { return false }
            return seen.insert(lowercased).inserted
        }
    }

    private func buildFinalSuggestions(
        currentWord: String,
        topSuggestions: [String],
        autocorrectCandidate: String?
    ) -> [Autocomplete.Suggestion] {
        var finalSuggestions: [Autocomplete.Suggestion] = []

        if !topSuggestions.isEmpty {
            finalSuggestions.append(
                Autocomplete.Suggestion(
                    text: currentWord,
                    type: .regular,
                    title: "\"\(currentWord)\""
                )
            )
        }

        for (index, word) in topSuggestions.enumerated() {
            let isAutocorrect =
                word.lowercased() == autocorrectCandidate?.lowercased()
                && autocorrectCandidate != nil
                && index == 0

            finalSuggestions.append(
                Autocomplete.Suggestion(
                    text: word,
                    type: isAutocorrect ? .autocorrect : .regular,
                    title: word
                )
            )
        }

        return finalSuggestions
    }

    /// Matches suggestion capitalization to user input pattern.
    private func matchCapitalization(suggestion: String, to input: String)
        -> String
    {
        guard !input.isEmpty, !suggestion.isEmpty else { return suggestion }

        if input.lowercased() == input {
            return suggestion.lowercased()
        }

        if input.uppercased() == input {
            return suggestion.uppercased()
        }

        if input.first!.isUppercase {
            return suggestion.prefix(1).uppercased()
                + suggestion.dropFirst().lowercased()
        }

        return suggestion
    }
}
