//
//  GermanInputSet.swift
//  Keyboard
//
//  Created by Benno on 05.12.25.
//

import KeyboardKit

extension KeyboardLayout.InputSet {

    static var german: KeyboardLayout.InputSet {
        .init(rows: [
            .init(chars: "qwertzuiopü"),
            .init(chars: "asdfghjklöä"),
            .init(chars: "yxcvbnm"),
        ])
    }
}
