//
//  AutocompleteToolbarView.swift
//  Keyboard
//
//  Created by Benno on 02.12.25.
//

import KeyboardKit
import SwiftUI

struct AutocompleteToolbarView: View {
    let standardToolbar:
        Autocomplete.Toolbar<
            Autocomplete.ToolbarItem, Autocomplete.ToolbarSeparator
        >
    let autocompleteAction: (Autocomplete.Suggestion) -> Void

    private var debug: Bool { true }

    private var taplingScale: CGFloat { 1.0 }  // Scale: 1x = 128px. TODO: Read from shared group (UserDefaults/App Group)
    private var taplingSize: CGFloat { 128 * taplingScale }
    private var taplingBottomOffset: CGFloat {
        TaplingConfig.shared.baseBodyBottomOffset
            * (taplingSize / TaplingConfig.shared.baseSize)
    }

    var body: some View {
        HStack(spacing: 8) {
            // Standard autocomplete toolbar
            standardToolbar

            // Reserve width for Tapling (invisible)
            Color.clear
                .frame(width: taplingSize)
                .overlay {
                    if debug {
                        Rectangle()
                            .stroke(.blue, lineWidth: 1)
                    }
                }
        }
        .overlay(alignment: .bottomTrailing) {
            // Tapling
            Button {
                // TODO: Add action here
            } label: {
                TaplingView(
                    tapling: Tapling(
                        fur: TaplingConfig.Fur.white,
                        hat: TaplingConfig.Hat.lilDuck,
                        face: TaplingConfig.Face.cute,
                        leftHand: TaplingConfig.Hand.up,
                        rightHand: TaplingConfig.Hand.down
                    )
                )
                .frame(width: taplingSize, height: taplingSize)
                .overlay {
                    if debug {
                        Rectangle()
                            .stroke(.red, lineWidth: 1)
                    }
                }
            }
            .offset(y: taplingBottomOffset)
            .overlay {
                if debug {
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(.green.opacity(0.3))
                            .frame(height: 1)
                    }
                }
            }
        }
        .overlay {
            if debug {
                Rectangle()
                    .stroke(.orange, lineWidth: 1)
            }
        }
        .zIndex(100)  // Ensure toolbar and Tapling appear above keyboard keys
    }
}

// TODO: Preview not supported in Keyboard extension?
//#Preview {
//    let mockSuggestions = [
//        Autocomplete.Suggestion(text: "hello", title: "hello"),
//        Autocomplete.Suggestion(text: "world", title: "world"),
//        Autocomplete.Suggestion(text: "test", title: "test")
//    ]
//
//    let mockToolbar = Autocomplete.Toolbar(
//        suggestions: mockSuggestions,
//        suggestionAction: { _ in }
//    )
//
//    return AutocompleteToolbarView(
//        standardToolbar: mockToolbar,
//        autocompleteAction: { _ in }
//    )
//    .padding()
//}
