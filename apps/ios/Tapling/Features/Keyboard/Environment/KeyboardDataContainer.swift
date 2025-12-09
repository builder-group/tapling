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
            )
        ]

        do {
            modelContainer = try ModelContainer(
                // Note: ModelContainer requires full schema even if configuration only uses subset
                for: Schema(
                    KeyboardDataContainer.schema() + DataContainer.schema()
                ),
                configurations: configurations
            )

            KeyboardDataContainer.ensureDefaults(in: modelContext)
        } catch {
            fatalError("Could not create KeyboardDataContainer: \(error)")
        }
    }

    static func schema() -> [any PersistentModel.Type] {
        [
            KeyboardTapling.self,
            KeyboardSettings.self,
            KeyboardSession.self,
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
        _ = KeyboardTapling.instance(with: context)
        _ = KeyboardSettings.instance(with: context)
    }
}

// MARK: - Preview Support

extension View {
    func previewKeyboardDataContainer(seed: ((ModelContext) -> Void)? = nil)
        -> some View
    {
        let container = KeyboardDataContainer(isStoredInMemoryOnly: true)
        if let seed = seed {
            seed(container.modelContext)
            try? container.modelContext.save()
        }
        return self.modelContainer(container.modelContainer)
    }
}
