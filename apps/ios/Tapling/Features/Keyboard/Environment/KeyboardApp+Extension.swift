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

extension KeyboardStatusContext {
    /// Check if Full Access is enabled for the Tapling keyboard
    static func hasFullAccess() -> Bool {
        let status = KeyboardStatusContext(
            bundleId: "com.buildergroup.Tapling.Keyboard"
        )
        status.refresh()
        return status.isFullAccessEnabled
    }
}
