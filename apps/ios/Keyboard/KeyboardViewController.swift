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
            if case .success = result {
                // Set up native autocomplete service using iOS APIs
                let autocompleteService = NativeAutocompleteService()
                autocompleteService.locale = self.state.keyboardContext.locale
                self.services.autocompleteService = autocompleteService

                // Request lexicon asynchronously and register it when ready
                self.requestSupplementaryLexicon { lexicon in
                    autocompleteService.registerLexicon(lexicon)
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
