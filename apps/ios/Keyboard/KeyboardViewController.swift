//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Benno on 02.12.25.
//

import KeyboardKit
import SwiftData
import SwiftUI
import UIKit

class KeyboardViewController: KeyboardInputViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLocaleFromSettings()
        updateAutocompleteLocale()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateLocaleFromSettings()

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
            VStack(spacing: 0) {
                PreviewBannerView()

                KeyboardView(
                    layout: self.generateLayout(for: controller),
                    services: controller.services
                ) { params in
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
            .modelContainer(DataContainer.shared.modelContainer)
        }
    }

    private func generateLayout(for controller: KeyboardInputViewController)
        -> KeyboardLayout
    {
        let context = controller.state.keyboardContext
        let language = context.keyboardLanguage

        let baseLayout = KeyboardLayout.baseLayout(
            for: context,
            alphabeticInputSet: language.layout,
            numericInputSet: .numeric(currency: language.primaryCurrency),
            symbolicInputSet: .symbolic(currencies: language.currencies)
        )

        if context.deviceType == .pad {
            return KeyboardLayout.iPadLayout(
                from: baseLayout,
                keyboardContext: context
            )
        } else {
            return KeyboardLayout.iPhoneLayout(
                from: baseLayout,
                keyboardContext: context
            )
        }
    }

    private func updateLocaleFromSettings() {
        let modelContext = DataContainer.shared.modelContext
        let settings = try? modelContext.fetch(
            FetchDescriptor<KeyboardSettings>()
        ).first

        let language = settings?.language ?? .system

        // Always support all available locales so the globe key works
        self.state.keyboardContext.locales = KeyboardLanguage.allCases
            .compactMap { $0.localeIdentifier }
            .map { Locale(identifier: $0) }

        if let localeIdentifier = language.localeIdentifier {
            self.state.keyboardContext.locale = Locale(
                identifier: localeIdentifier
            )
        } else {
            // For .system, use the current system locale
            self.state.keyboardContext.locale = Locale.current
        }
    }

    private func updateAutocompleteLocale() {
        // Sync autocomplete service locale with keyboard context locale
        self.services.autocompleteService.locale =
            self.state.keyboardContext.locale
    }
}
