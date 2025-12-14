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

    @QuerySingleton private var keyboardSettings: KeyboardSettings
    @QuerySingleton private var keyboardTapling: KeyboardTapling

    @State private var leftHand: HandPosition = .up
    @State private var rightHand: HandPosition = .down

    private var baseScale: CGFloat {
        // Base scale: upper part (baseSize - baseBodyBottomOffset) fits toolbar height
        let baseVisibleHeight =
            TaplingConfig.baseSize
            - TaplingConfig.baseBodyBottomOffset
        let toolbarHeight = Keyboard.ToolbarStyle.standardHeight
        return toolbarHeight / baseVisibleHeight
    }
    private var userScale: CGFloat {
        CGFloat(keyboardSettings.taplingScale)
    }
    private var taplingScale: CGFloat { baseScale * userScale }

    private var taplingSize: CGFloat {
        TaplingConfig.baseSize * taplingScale
    }
    private var userBottomOffset: CGFloat {
        CGFloat(keyboardSettings.taplingBottomOffset)
    }
    private var taplingBottomOffset: CGFloat {
        TaplingConfig.baseBodyBottomOffset
            * (taplingSize / TaplingConfig.baseSize) + userBottomOffset
    }

    private var currentTapling: Tapling {
        Tapling(
            fur: keyboardTapling.equippedFur,
            hat: keyboardTapling.equippedHat,
            face: keyboardTapling.equippedFace,
            leftHand: leftHand,
            rightHand: rightHand
        )
    }

    // MARK: - UI

    var body: some View {
        HStack(spacing: 8) {
            if keyboardSettings.taplingPosition.isLeft {
                // Reserve width for Tapling (invisible) when on left
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

            // Standard autocomplete toolbar
            standardToolbar

            if keyboardSettings.taplingPosition.isRight {
                // Reserve width for Tapling (invisible) when on right
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
        }
        .frame(
            maxWidth: .infinity,
            alignment: keyboardSettings.taplingPosition.alignment
        )
        .background(alignment: keyboardSettings.taplingPosition.topAlignment) {
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
        .overlay(alignment: keyboardSettings.taplingPosition.bottomAlignment) {
            // Tapling
            TaplingView(tapling: currentTapling)
                .scaleEffect(
                    x: keyboardSettings.taplingOrientation.scaleX,
                    y: 1
                )
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
