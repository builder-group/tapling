//
//  AppGroup.swift
//  Tapling
//
//  Created by Benno on 03.12.25.
//

import Foundation

/// App Group UserDefaults for syncing data between the main app and keyboard extension.
struct AppGroup {
    static let shared = AppGroup()

    /// App Group identifier (must match entitlements in both targets)
    private static let appGroupId = "group.com.buildergroup.Tapling"

    private let userDefaults: UserDefaults?

    private init() {
        userDefaults = UserDefaults(suiteName: Self.appGroupId)
    }

    // MARK: - Keys (organized by domain)

    private enum Keys {
        enum Tapling {
            static let userScale = "tapling.userScale"
            static let userBottomOffset = "tapling.userBottomOffset"
        }

        enum Keyboard {
            static let debug = "keyboard.debug"
        }
    }

    // MARK: - Tapling

    enum Tapling {
        /// User-defined scale multiplier for Tapling size (default: 1.5)
        static var userScale: CGFloat {
            get {
                guard let userDefaults = AppGroup.shared.userDefaults else {
                    return 1.5  // Fallback value
                }
                if userDefaults.object(forKey: Keys.Tapling.userScale) == nil {
                    return 1.5  // Default value
                }
                return CGFloat(
                    userDefaults.double(forKey: Keys.Tapling.userScale)
                )
            }
            set {
                AppGroup.shared.userDefaults?.set(
                    newValue,
                    forKey: Keys.Tapling.userScale
                )
            }
        }

        /// User-defined bottom offset for Tapling positioning (default: 4.0)
        static var userBottomOffset: CGFloat {
            get {
                guard let userDefaults = AppGroup.shared.userDefaults else {
                    return 4.0  // Fallback value
                }
                if userDefaults.object(forKey: Keys.Tapling.userBottomOffset)
                    == nil
                {
                    return 4.0  // Default value
                }
                return CGFloat(
                    userDefaults.double(forKey: Keys.Tapling.userBottomOffset)
                )
            }
            set {
                AppGroup.shared.userDefaults?.set(
                    newValue,
                    forKey: Keys.Tapling.userBottomOffset
                )
            }
        }
    }

    // MARK: - Keyboard

    enum Keyboard {
        /// Debug flag for keyboard extension (default: false)
        static var debug: Bool {
            get {
                guard let userDefaults = AppGroup.shared.userDefaults else {
                    return false  // Fallback value
                }
                if userDefaults.object(forKey: Keys.Keyboard.debug) == nil {
                    return false  // Default value
                }
                return userDefaults.bool(forKey: Keys.Keyboard.debug)
            }
            set {
                AppGroup.shared.userDefaults?.set(
                    newValue,
                    forKey: Keys.Keyboard.debug
                )
            }
        }
    }
}
