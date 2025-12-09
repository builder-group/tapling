//
//  KeyboardActionHandler.swift
//  Keyboard
//
//  Created by Benno on 02.12.25.
//

import KeyboardKit
import UIKit

extension Notification.Name {
    /// Posted when any keyboard action is triggered (on release gesture).
    static let keyboardActionTriggered = Notification.Name(
        "keyboardActionTriggered"
    )
}

class KeyboardActionHandler: KeyboardAction.StandardActionHandler {

    override func handle(_ gesture: Keyboard.Gesture, on action: KeyboardAction)
    {
        super.handle(gesture, on: action)

        // Handle keystrokes when any keyboard action is triggered (on release gesture)
        if gesture == .release {
            Task { @MainActor in
                KeyboardSessionTracker.shared.trackKeystroke()
            }

            NotificationCenter.default.post(
                name: .keyboardActionTriggered,
                object: nil
            )
        }
    }
}
