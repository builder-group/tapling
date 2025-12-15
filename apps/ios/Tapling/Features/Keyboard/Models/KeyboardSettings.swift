//
//  KeyboardSettings.swift
//  Tapling
//
//  Created by Benno on 03.12.25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class KeyboardSettings: SingletonModel {
    var debug: Bool
    var isPreviewMode: Bool

    var language: KeyboardLanguage
    var autocompleteEnabled: Bool
    var autocorrectEnabled: Bool
    var emojiPickerEnabled: Bool

    var trackSessions: Bool

    var taplingScale: Double
    var taplingBottomOffset: Double
    var taplingPosition: KeyboardTaplingPosition
    var taplingOrientation: KeyboardTaplingOrientation

    init(
        debug: Bool = false,
        isPreviewMode: Bool = false,
        language: KeyboardLanguage = .system,
        autocompleteEnabled: Bool = true,
        autocorrectEnabled: Bool = false,
        emojiPickerEnabled: Bool = false,
        taplingScale: Double = 1.5,
        taplingBottomOffset: Double = 4.0,
        taplingPosition: KeyboardTaplingPosition = .right,
        taplingOrientation: KeyboardTaplingOrientation = .left,
        trackSessions: Bool = true
    ) {
        self.debug = debug
        self.isPreviewMode = isPreviewMode
        self.language = language
        self.autocompleteEnabled = autocompleteEnabled
        self.autocorrectEnabled = autocorrectEnabled
        self.emojiPickerEnabled = emojiPickerEnabled
        self.taplingScale = taplingScale
        self.taplingBottomOffset = taplingBottomOffset
        self.taplingPosition = taplingPosition
        self.taplingOrientation = taplingOrientation
        self.trackSessions = trackSessions
    }

    static var `default`: KeyboardSettings {
        KeyboardSettings()
    }
}

enum KeyboardTaplingPosition: String, Codable, CaseIterable {
    case left
    case right

    var displayName: String {
        switch self {
        case .left: return "Left"
        case .right: return "Right"
        }
    }

    var isLeft: Bool {
        self == .left
    }

    var isRight: Bool {
        self == .right
    }
}

enum KeyboardTaplingOrientation: String, Codable, CaseIterable {
    case left
    case right

    var displayName: String {
        switch self {
        case .left: return "Left"
        case .right: return "Right"
        }
    }

    var scaleX: CGFloat {
        switch self {
        case .left: return 1
        case .right: return -1
        }
    }
}
