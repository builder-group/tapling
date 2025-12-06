//
//  NativeAutocompleteServiceTests.swift
//  TaplingTests
//
//  Created by Benno on 06.12.25.
//

import Foundation
import KeyboardKit
import Testing

@testable import Tapling

struct NativeAutocompleteServiceTests {

    @Test @MainActor func playground() async throws {
        let service = NativeAutocompleteService()
        service.locale = Locale(identifier: "en_US")

        let input = "hel"

        let result = try await service.autocomplete(input)

        print("Input: '\(input)'")
        print("Suggestions count: \(result.suggestions.count)")
        for (index, suggestion) in result.suggestions.enumerated() {
            print(
                "  [\(index)] \(suggestion.text) (type: \(suggestion.type), title: '\(suggestion.title)')"
            )
        }

        #expect(result.inputText == input)
        #expect(result.suggestions.count <= 3)
    }

    @Test @MainActor func testHel_enUS_ReturnsHelloHelpHelps() async throws {
        // Real keyboard: "hel" | hello | help
        try await expectAutocomplete(
            input: "hel",
            locale: Locale(identifier: "en_US"),
            expected: [
                Autocomplete.Suggestion(
                    text: "hel",
                    type: .regular,
                    title: "\"hel\""
                ),
                Autocomplete.Suggestion(
                    text: "hello",
                    type: .regular,
                    title: "hello"
                ),
                Autocomplete.Suggestion(
                    text: "help",
                    type: .regular,
                    title: "help"
                ),
            ]
        )
    }

    @Test @MainActor func testHel_deDE_ReturnsHelmeHelfeHellblau() async throws
    {
        // Real keyboard: "hel" | helfen | hell
        try await expectAutocomplete(
            input: "hel",
            locale: Locale(identifier: "de_DE"),
            expected: [
                Autocomplete.Suggestion(
                    text: "hel",
                    type: .regular,
                    title: "\"hel\""
                ),
                Autocomplete.Suggestion(
                    text: "helme",
                    type: .regular,
                    title: "helme"
                ),
                Autocomplete.Suggestion(
                    text: "helfe",
                    type: .regular,
                    title: "helfe"
                ),
            ]
        )
    }

    @Test @MainActor func testHelo_enUS_ReturnsHelpAsAutocorrect() async throws
    {
        // Real keyboard: "helo" | help (autocorrect) | helping
        // Note: UITextChecker ranks "helps" before "helping", so we match that
        try await expectAutocomplete(
            input: "helo",
            locale: Locale(identifier: "en_US"),
            expected: [
                Autocomplete.Suggestion(
                    text: "helo",
                    type: .regular,
                    title: "\"helo\""
                ),
                Autocomplete.Suggestion(
                    text: "help",
                    type: .autocorrect,
                    title: "help"
                ),
                Autocomplete.Suggestion(
                    text: "helps",
                    type: .regular,
                    title: "helps"
                ),
            ]
        )
    }

    @Test @MainActor func testEmpty_enUS_ReturnsEmptyTextSuggestions()
        async throws
    {
        // Real keyboard: I | The | I'm
        try await expectAutocomplete(
            input: "",
            locale: Locale(identifier: "en_US"),
            expected: [
                Autocomplete.Suggestion(text: "I", type: .regular, title: "I"),
                Autocomplete.Suggestion(
                    text: "The",
                    type: .regular,
                    title: "The"
                ),
                Autocomplete.Suggestion(
                    text: "I'm",
                    type: .regular,
                    title: "I'm"
                ),
            ]
        )
    }

    @Test @MainActor func testEmpty_deDE_ReturnsEmptyTextSuggestions()
        async throws
    {
        // Real keyboard: Ich | Ja | Das
        try await expectAutocomplete(
            input: "",
            locale: Locale(identifier: "de_DE"),
            expected: [
                Autocomplete.Suggestion(
                    text: "Ich",
                    type: .regular,
                    title: "Ich"
                ),
                Autocomplete.Suggestion(
                    text: "Ja",
                    type: .regular,
                    title: "Ja"
                ),
                Autocomplete.Suggestion(
                    text: "Das",
                    type: .regular,
                    title: "Das"
                ),
            ]
        )
    }

    @Test @MainActor func testHelloW_enUS_ExtractsW() async throws {
        // Real keyboard: "w" | we | what
        // UITextChecker returns "we" before "what", so we match that
        try await expectAutocomplete(
            input: "Hello w",
            locale: Locale(identifier: "en_US"),
            expected: [
                Autocomplete.Suggestion(
                    text: "w",
                    type: .regular,
                    title: "\"w\""
                ),
                Autocomplete.Suggestion(
                    text: "we",
                    type: .regular,
                    title: "we"
                ),
                Autocomplete.Suggestion(
                    text: "what",
                    type: .regular,
                    title: "what"
                ),
            ]
        )
    }

    @Test @MainActor func testHel_Capitalized_enUS_ReturnsCapitalized()
        async throws
    {
        // Real keyboard: "Hel" | Hello | Help
        try await expectAutocomplete(
            input: "Hel",
            locale: Locale(identifier: "en_US"),
            expected: [
                Autocomplete.Suggestion(
                    text: "Hel",
                    type: .regular,
                    title: "\"Hel\""
                ),
                Autocomplete.Suggestion(
                    text: "Hello",
                    type: .regular,
                    title: "Hello"
                ),
                Autocomplete.Suggestion(
                    text: "Help",
                    type: .regular,
                    title: "Help"
                ),
            ]
        )
    }

    @Test @MainActor func testXyzabc123_UnknownWord_ReturnsWordInQuotes()
        async throws
    {
        // Real keyboard: "xyzabc123"
        try await expectAutocomplete(
            input: "xyzabc123",
            locale: Locale(identifier: "en_US"),
            expected: [
                Autocomplete.Suggestion(
                    text: "xyzabc123",
                    type: .regular,
                    title: "\"xyzabc123\""
                )
            ]
        )
    }

    @Test @MainActor func testThsi_enUS_ReturnsThisAsAutocorrect() async throws
    {
        // Real keyboard: "thsi" | this (autocorrect)
        try await expectAutocomplete(
            input: "thsi",
            locale: Locale(identifier: "en_US"),
            expected: [
                Autocomplete.Suggestion(
                    text: "thsi",
                    type: .regular,
                    title: "\"thsi\""
                ),
                Autocomplete.Suggestion(
                    text: "this",
                    type: .autocorrect,
                    title: "this"
                ),
                Autocomplete.Suggestion(
                    text: "this'll",
                    type: .regular,
                    title: "this'll"
                ),
            ]
        )
    }

    @Test @MainActor func testHEL_enUS_ReturnsAllCaps() async throws {
        // Real keyboard: "HEL" | HELLO | HELP
        try await expectAutocomplete(
            input: "HEL",
            locale: Locale(identifier: "en_US"),
            expected: [
                Autocomplete.Suggestion(
                    text: "HEL",
                    type: .regular,
                    title: "\"HEL\""
                ),
                Autocomplete.Suggestion(
                    text: "HELLO",
                    type: .regular,
                    title: "HELLO"
                ),
                Autocomplete.Suggestion(
                    text: "HELP",
                    type: .regular,
                    title: "HELP"
                ),
            ]
        )
    }

    @Test @MainActor func testA_enUS_ReturnsSingleCharacterSuggestions()
        async throws
    {
        // Real keyboard: "a" | and | are
        try await expectAutocomplete(
            input: "a",
            locale: Locale(identifier: "en_US"),
            expected: [
                Autocomplete.Suggestion(
                    text: "a",
                    type: .regular,
                    title: "\"a\""
                ),
                Autocomplete.Suggestion(
                    text: "and",
                    type: .regular,
                    title: "and"
                ),
                Autocomplete.Suggestion(
                    text: "are",
                    type: .regular,
                    title: "are"
                ),
            ]
        )
    }

    @Test @MainActor func testHallo_deDE_ReturnsHalloCompletions()
        async throws
    {
        // Real keyboard: "hallo" | Hallos | 🙋‍♂️
        try await expectAutocomplete(
            input: "hallo",
            locale: Locale(identifier: "de_DE"),
            expected: [
                Autocomplete.Suggestion(
                    text: "hallo",
                    type: .regular,
                    title: "\"hallo\""
                ),
                Autocomplete.Suggestion(
                    text: "hallos",
                    type: .regular,
                    title: "hallos"
                ),
            ]
        )
    }

    @Test @MainActor func testH_SingleCapital_enUS_ReturnsCapitalized()
        async throws
    {
        // Real keyboard: "H" | Hey | How
        try await expectAutocomplete(
            input: "H",
            locale: Locale(identifier: "en_US"),
            expected: [
                Autocomplete.Suggestion(
                    text: "H",
                    type: .regular,
                    title: "\"H\""
                ),
                Autocomplete.Suggestion(
                    text: "He",
                    type: .regular,
                    title: "He"
                ),
                Autocomplete.Suggestion(
                    text: "Hey",
                    type: .regular,
                    title: "Hey"
                ),
            ]
        )
    }

    // MARK: - Helpers

    @MainActor
    func expectAutocomplete(
        input: String,
        locale: Locale,
        expected: [Autocomplete.Suggestion]
    ) async throws {
        let service = NativeAutocompleteService()
        service.locale = locale
        let result = try await service.autocomplete(input)

        #expect(
            result.suggestions.count == expected.count,
            "Expected \(expected.count) suggestions but got \(result.suggestions.count)"
        )
        for (index, (actual, expected)) in zip(result.suggestions, expected)
            .enumerated()
        {
            #expect(
                actual.text == expected.text,
                "[\(index)] text: expected '\(expected.text)' but got '\(actual.text)'"
            )
            #expect(
                actual.type == expected.type,
                "[\(index)] type: expected '\(expected.type)' but got '\(actual.type)'"
            )
            #expect(
                actual.title == expected.title,
                "[\(index)] title: expected '\(expected.title)' but got '\(actual.title)'"
            )
        }
    }
}
