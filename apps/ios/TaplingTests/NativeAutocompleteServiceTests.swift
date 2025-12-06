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
}
