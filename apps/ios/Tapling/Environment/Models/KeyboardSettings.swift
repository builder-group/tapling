//
//  KeyboardSettings.swift
//  Tapling
//
//  Created by Benno on 03.12.25.
//

import Foundation
import SwiftData

@Model
final class KeyboardSettings {
    var debug: Bool

    init(debug: Bool = false) {
        self.debug = debug
    }

    /// Fetches or creates the singleton KeyboardSettings instance.
    /// Note: For reactive access in SwiftUI views, use `@Query` instead.
    static func instance(with modelContext: ModelContext) -> KeyboardSettings {
        let descriptor = FetchDescriptor<KeyboardSettings>()
        if let result = try? modelContext.fetch(descriptor).first {
            return result
        } else {
            let instance = KeyboardSettings()
            modelContext.insert(instance)
            try? modelContext.save()
            return instance
        }
    }
}
