//
//  TaplingSettings.swift
//  Tapling
//
//  Created by Benno on 03.12.25.
//

import Foundation
import SwiftData

@Model
final class TaplingSettings {
    var userScale: Double
    var userBottomOffset: Double

    init(
        userScale: Double = 1.5,
        userBottomOffset: Double = 4.0
    ) {
        self.userScale = userScale
        self.userBottomOffset = userBottomOffset
    }

    /// Fetches or creates the singleton TaplingSettings instance.
    /// Note: For reactive access in SwiftUI views, use `@Query` instead.
    static func instance(with modelContext: ModelContext) -> TaplingSettings {
        let descriptor = FetchDescriptor<TaplingSettings>()
        if let result = try? modelContext.fetch(descriptor).first {
            return result
        } else {
            let instance = TaplingSettings()
            modelContext.insert(instance)
            try? modelContext.save()
            return instance
        }
    }
}
