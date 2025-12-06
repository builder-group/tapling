//
//  KeyboardDataContainer.swift
//  Tapling
//
//  Created by Benno on 06.12.25.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
@MainActor
class KeyboardDataContainer {
    static let shared = KeyboardDataContainer()

    let modelContainer: ModelContainer
    var modelContext: ModelContext {
        modelContainer.mainContext
    }

    init(isStoredInMemoryOnly: Bool = false) {
        let configurations = [
            KeyboardDataContainer.configuration(
                isStoredInMemoryOnly: isStoredInMemoryOnly
            ),
        ]

        do {
            modelContainer = try ModelContainer(
                // Note: ModelContainer requires full schema even if configuration only uses subset
                for: Schema(KeyboardDataContainer.schema() + DataContainer.schema()),
                configurations: configurations
            )

            KeyboardDataContainer.ensureDefaults(in: modelContext)
        } catch {
            fatalError("Could not create KeyboardDataContainer: \(error)")
        }
    }

    static func schema() -> [any PersistentModel.Type] {
        [
            KeyboardTaplingSettings.self,
            KeyboardSettings.self,
        ]
    }

    static func configuration(isStoredInMemoryOnly: Bool = false)
        -> ModelConfiguration
    {
        let schema = Schema(KeyboardDataContainer.schema())

        if isStoredInMemoryOnly {
            return ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: true
            )
        } else {
            return ModelConfiguration(
                "TaplingKeyboardData",
                schema: schema,
                isStoredInMemoryOnly: false,
                allowsSave: true,
                groupContainer: .identifier("group.com.buildergroup.Tapling"),
                cloudKitDatabase: .none
            )
        }
    }

    static func ensureDefaults(in context: ModelContext) {
        _ = KeyboardTaplingSettings.instance(with: context)
        _ = KeyboardSettings.instance(with: context)
    }
}

// MARK: - Preview Support

extension KeyboardDataContainer {
    static let preview = KeyboardDataContainer(isStoredInMemoryOnly: true)
}

extension View {
    func previewKeyboardDataContainer() -> some View {
        self.modelContainer(KeyboardDataContainer.preview.modelContainer)
    }
}
