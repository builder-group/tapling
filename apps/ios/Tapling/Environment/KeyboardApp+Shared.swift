//
//  KeyboardApp+Extension.swift
//  Tapling
//
//  Created by Benno on 02.12.25.
//

import KeyboardKit

extension KeyboardApp {
    static var shared: KeyboardApp {
        .init(
            name: "Tapling Keyboard",
            appGroupId: "group.com.buildergroup.Tapling",
            locales: .keyboardKitSupported,
        )
    }
}
