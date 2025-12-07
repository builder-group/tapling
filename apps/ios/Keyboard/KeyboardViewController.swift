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
                let modelContext = KeyboardDataContainer.shared.modelContext
                let settings = modelContext.fetchKeyboardSettings()

                // Set up native autocomplete service using iOS APIs
                let autocompleteService = NativeAutocompleteService()
                autocompleteService.locale = self.state.keyboardContext.locale
                autocompleteService.autocorrectEnabled =
                    settings.autocorrectEnabled
                autocompleteService.autocompleteEnabled =
                    settings.autocompleteEnabled
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

        let modelContext = KeyboardDataContainer.shared.modelContext
        let settings = modelContext.fetchKeyboardSettings()
        let isEmojiPickerEnabled = settings.emojiPickerEnabled

        setupKeyboardView { controller in
            VStack(spacing: 0) {
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
                    // EmojiPickerView(controller: controller)
                    //
                    // NOTE: KeyboardKit's basic emoji keyboard seems to be partially working in the free version?
                    // This is probably a bug that may not be available in future KeyboardKit versions.
                    params.view
                        .emojiKeyboardSizes(
                            EmojiKeyboard.Sizes(
                                emojiFontSize: 36,
                                emojiFrameWidth: 50,
                                emojiFrameHeight: 40
                            )
                        )
                        .frame(height: 220)
                } toolbar: { params in
                    AutocompleteToolbarView(
                        standardToolbar: params.view,
                        autocompleteAction: params.autocompleteAction
                    )
                }

                PreviewBannerView()
            }
            .modelContainer(KeyboardDataContainer.shared.modelContainer)
        }
    }

    private func generateLayout(for controller: KeyboardInputViewController)
        -> KeyboardLayout
    {
        let context = controller.state.keyboardContext
        let language = context.keyboardLanguage

        // Sync autocomplete settings whenever layout is generated
        // This ensures autocomplete language and settings match current keyboard state
        if let autocompleteService = self.services.autocompleteService
            as? NativeAutocompleteService
        {
            autocompleteService.locale = context.locale

            let modelContext = KeyboardDataContainer.shared.modelContext
            let settings = modelContext.fetchKeyboardSettings()
            autocompleteService.autocorrectEnabled = settings.autocorrectEnabled
            autocompleteService.autocompleteEnabled =
                settings.autocompleteEnabled
        }

        let baseLayout = KeyboardLayout.baseLayout(
            for: context,
            alphabeticInputSet: language.layout,
            numericInputSet: .numeric(currency: language.primaryCurrency),
            symbolicInputSet: .symbolic(currencies: language.currencies)
        )

        var layout: KeyboardLayout
        if context.deviceType == .pad {
            layout = KeyboardLayout.iPadLayout(
                from: baseLayout,
                keyboardContext: context
            )
        } else {
            layout = KeyboardLayout.iPhoneLayout(
                from: baseLayout,
                keyboardContext: context
            )
        }

        // Remove emoji keyboard button if emoji picker is disabled
        let modelContext = KeyboardDataContainer.shared.modelContext
        let settings = modelContext.fetchKeyboardSettings()
        if !settings.emojiPickerEnabled {
            layout.remove(.keyboardType(.emojis))
        }

        return layout
    }

    private func updateLocaleFromSettings() {
        let modelContext = KeyboardDataContainer.shared.modelContext
        let settings = modelContext.fetchKeyboardSettings()

        let language = settings.language

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

        // Update autocomplete service settings
        if let autocompleteService = self.services.autocompleteService
            as? NativeAutocompleteService
        {
            autocompleteService.autocorrectEnabled = settings.autocorrectEnabled
            autocompleteService.autocompleteEnabled =
                settings.autocompleteEnabled
        }
    }
}
