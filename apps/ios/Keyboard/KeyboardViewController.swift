//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Benno on 02.12.25.
//

import KeyboardKit
import SwiftUI
import UIKit

class KeyboardViewController: KeyboardInputViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up custom action handler
        self.services.actionHandler = KeyboardActionHandler(
            controller: self
        )

        // Set up keyboard with the shared keyboard app instance
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

    override func viewWillSetupKeyboardView() {
        super.viewWillSetupKeyboardView()

        setupKeyboardView { controller in
            KeyboardView(services: controller.services) { params in
                params.view
            } buttonView: { params in
                params.view
            } collapsedView: { params in
                params.view
            } emojiKeyboard: { params in
                params.view
            } toolbar: { params in
                AutocompleteToolbarView(
                    standardToolbar: params.view,
                    autocompleteAction: params.autocompleteAction
                )
            }
        }
    }
}
