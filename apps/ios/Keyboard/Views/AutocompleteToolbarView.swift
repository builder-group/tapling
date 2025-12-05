//
//  AutocompleteToolbarView.swift
//  Keyboard
//
//  Created by Benno on 02.12.25.
//

import KeyboardKit
import SwiftData
import SwiftUI

struct AutocompleteToolbarView: View {
    let standardToolbar:
        Autocomplete.Toolbar<
            Autocomplete.ToolbarItem, Autocomplete.ToolbarSeparator
        >
    let autocompleteAction: (Autocomplete.Suggestion) -> Void

    @QuerySingleton private var taplingSettings: TaplingSettings
    @QuerySingleton private var keyboardSettings: KeyboardSettings

    @State private var leftHand: HandPosition = .up
    @State private var rightHand: HandPosition = .down

    private var baseScale: CGFloat {
        // Base scale: upper part (baseSize - baseBodyBottomOffset) fits toolbar height
        let baseVisibleHeight =
            TaplingConfig.shared.baseSize
            - TaplingConfig.shared.baseBodyBottomOffset
        let toolbarHeight = Keyboard.ToolbarStyle.standardHeight
        return toolbarHeight / baseVisibleHeight
    }
    private var userScale: CGFloat {
        CGFloat(taplingSettings.userScale)
    }
    private var taplingScale: CGFloat { baseScale * userScale }

    private var taplingSize: CGFloat {
        TaplingConfig.shared.baseSize * taplingScale
    }
    private var userBottomOffset: CGFloat {
        CGFloat(taplingSettings.userBottomOffset)
    }
    private var taplingBottomOffset: CGFloat {
        TaplingConfig.shared.baseBodyBottomOffset
            * (taplingSize / TaplingConfig.shared.baseSize) + userBottomOffset
    }

    private var currentTapling: Tapling {
        Tapling(
            fur: .default,
            hat: Hat.get("hat_lil-duck"),
            face: .default,
            leftHand: leftHand,
            rightHand: rightHand
        )
    }

    // MARK: - UI

    var body: some View {
        HStack(spacing: 8) {
            // Standard autocomplete toolbar
            standardToolbar

            // Reserve width for Tapling (invisible)
            Color.clear
                .frame(width: taplingSize)
                .overlay {
                    if keyboardSettings.debug {
                        Rectangle()
                            .fill(Color.blue.opacity(0.1))
                            .stroke(.blue, lineWidth: 1)
                            .allowsHitTesting(false)
                    }
                }
        }
        .background(alignment: .topTrailing) {
            // Hitbox (invisible)
            Button {
                print("Tapling hitbox tapped")
            } label: {
                Color.white  // Note: White with 0.01 opacity (Color.clear doesn't seem to register hits)
                    .opacity(0.01)
                    .frame(width: taplingSize)
                    .frame(height: Keyboard.ToolbarStyle.standardHeight)
                    .overlay {
                        if keyboardSettings.debug {
                            Rectangle()
                                .fill(Color.purple.opacity(0.1))
                                .stroke(.purple, lineWidth: 1)
                                .allowsHitTesting(false)
                        }
                    }
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: .keyboardActionTriggered
            )
        ) { _ in
            toggleHands()
        }
        .overlay(alignment: .bottomTrailing) {
            // Tapling
            TaplingView(tapling: currentTapling)
                .overlay {
                    if keyboardSettings.debug {
                        Rectangle()
                            .fill(Color.red.opacity(0.1))
                            .stroke(.red, lineWidth: 1)
                            .allowsHitTesting(false)
                    }
                }
                .frame(width: taplingSize, height: taplingSize)
                .offset(y: taplingBottomOffset)
                .allowsHitTesting(false)
        }
        .overlay {
            if keyboardSettings.debug {
                Rectangle()
                    .fill(Color.orange.opacity(0.1))
                    .stroke(.orange, lineWidth: 1)
                    .allowsHitTesting(false)
            }
        }
        .zIndex(100)  // Ensure toolbar and Tapling appear above keyboard keys
    }

    // MARK: - Actions

    private func toggleHands() {
        leftHand = leftHand == .down ? .up : .down
        rightHand = rightHand == .down ? .up : .down
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
