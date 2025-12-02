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

    @State private var leftHand: TaplingConfig.Hand = .up
    @State private var rightHand: TaplingConfig.Hand = .down

    private var debug: Bool { true }

    private var baseScale: CGFloat {
        // Base scale: upper part (baseSize - baseBodyBottomOffset) fits toolbar height
        let baseVisibleHeight =
            TaplingConfig.shared.baseSize
            - TaplingConfig.shared.baseBodyBottomOffset
        let toolbarHeight = Keyboard.ToolbarStyle.standardHeight
        return toolbarHeight / baseVisibleHeight
    }
    private var userScale: CGFloat { 1.5 }  // TODO: User can override via UserDefaults/App Group
    private var taplingScale: CGFloat { baseScale * userScale }

    private var taplingSize: CGFloat {
        TaplingConfig.shared.baseSize * taplingScale
    }
    private var userBottomOffset: CGFloat { 4 }  // TODO: User can override via UserDefaults/App Group
    private var taplingBottomOffset: CGFloat {
        TaplingConfig.shared.baseBodyBottomOffset
            * (taplingSize / TaplingConfig.shared.baseSize) + userBottomOffset
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
                        if debug {
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
            TaplingView(
                tapling: Tapling(
                    fur: TaplingConfig.Fur.white,
                    hat: TaplingConfig.Hat.lilDuck,
                    face: TaplingConfig.Face.cute,
                    leftHand: leftHand,
                    rightHand: rightHand
                )
            )
            .overlay {
                if debug {
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
            if debug {
                Rectangle()
                    .fill(Color.orange.opacity(0.1))
                    .stroke(.orange, lineWidth: 1)
                    .allowsHitTesting(false)
            }
        }
        .zIndex(100)  // Ensure toolbar and Tapling appear above keyboard keys
    }

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
