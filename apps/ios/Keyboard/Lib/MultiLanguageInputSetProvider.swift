//
//  MultiLanguageInputSetProvider.swift
//  Keyboard
//
//  Created by Benno on 05.12.25.
//

import Foundation
import KeyboardKit

class MultiLanguageInputSetProvider {

    private let context: KeyboardContext

    init(context: KeyboardContext) {
        self.context = context
    }

    var alphabeticInputSet: KeyboardLayout.InputSet {
        if context.locale.identifier.hasPrefix("de") {
            return .german
        }
        return .qwerty
    }

    var numericInputSet: KeyboardLayout.InputSet {
        .numeric(currency: "$")
    }

    var symbolicInputSet: KeyboardLayout.InputSet {
        .symbolic(currencies: ["€", "£", "$", "¥"])
    }
}
