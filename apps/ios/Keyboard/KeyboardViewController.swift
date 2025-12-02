//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Benno on 02.12.25.
//

import KeyboardKit
import UIKit

class KeyboardViewController: KeyboardInputViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the keyboard with the app we created above
        setup(for: .shared) { result in
            // If `result` is `.success`, the setup did succeed.
            // This is where you can setup custom services, etc.

            if case .success = result {
                // Set up native autocomplete service using iOS APIs
                let autocompleteService = NativeAutocompleteService()
                autocompleteService.locale = self.state.keyboardContext.locale
                self.services.autocompleteService = autocompleteService

                // Request UILexicon and pass it to the service
                self.requestSupplementaryLexicon { lexicon in
                    autocompleteService.setLexicon(lexicon)
                }

                // Trigger initial autocomplete to show suggestions on keyboard launch
                autocompleteService.autocomplete(
                    "",
                    updating: self.state.autocompleteContext
                )
            }
        }
    }
}
