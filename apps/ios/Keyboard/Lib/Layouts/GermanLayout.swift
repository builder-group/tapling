//
//  GermanLayout.swift
//  Keyboard
//
//  Created by Benno on 05.12.25.
//

import KeyboardKit

extension KeyboardLayout.InputSet {

    /// German QWERTZ layout with umlauts (ü, ö, ä)
    static var german: KeyboardLayout.InputSet {
        .init(rows: [
            .init(chars: "qwertzuiopü"),
            .init(chars: "asdfghjklöä"),
            .init(chars: "yxcvbnm"),
        ])
    }
}
