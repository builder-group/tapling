//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Benno on 02.12.25.
//

import UIKit
import KeyboardKit

class KeyboardViewController: KeyboardInputViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the keyboard with the app we created above
        setup(for: .shared) { result in
            // If `result` is `.success`, the setup did succeed.
            // This is where you can setup custom services, etc.
        }
    }
}
