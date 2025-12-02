//
//  KeyboardActionHandler.swift
//  Keyboard
//
//  Created by Benno on 02.12.25.
//

import KeyboardKit
import UIKit

extension Notification.Name {
    /// Posted when a character is inserted via keyboard action.
    static let keyboardCharacterInserted = Notification.Name(
        "keyboardCharacterInserted"
    )
}

class KeyboardActionHandler: KeyboardAction.StandardActionHandler {

    override func handle(_ gesture: Keyboard.Gesture, on action: KeyboardAction)
    {
        super.handle(gesture, on: action)

        // Notify when a character is inserted (on release gesture)
        // This allows other components (like Tapling) to react to key presses
        if gesture == .release, action.isCharacterAction {
            NotificationCenter.default.post(
                name: .keyboardCharacterInserted,
                object: nil
            )
        }
    }
}
