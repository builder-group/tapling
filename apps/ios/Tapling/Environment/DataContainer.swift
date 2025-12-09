//
//  DataContainer.swift
//  Tapling
//
//  Created by Benno on 03.12.25.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
@MainActor
class DataContainer {
    static let shared = DataContainer()

    let modelContainer: ModelContainer
    var modelContext: ModelContext {
        modelContainer.mainContext
    }
    init(isStoredInMemoryOnly: Bool = false) {
        let configurations: [ModelConfiguration]
        if isStoredInMemoryOnly {
            // For in-memory (previews), use a single configuration to avoid
            // store routing issues in SwiftUI Previews.
            configurations = [
                ModelConfiguration(
                    schema: Schema(
                        DataContainer.schema() + KeyboardDataContainer.schema()
                    ),
                    isStoredInMemoryOnly: true
                )
            ]
        } else {
            // Otherwise use separate configurations for isolation.
            // DataContainer: App models (AppSettings, Player, etc.)
            // KeyboardDataContainer: Keyboard models in shared group container
            // for keyboard extension access (KeyboardTaplingSettings, KeyboardSettings, etc.)
            configurations = [
                DataContainer.configuration(
                    isStoredInMemoryOnly: false
                ),
                KeyboardDataContainer.configuration(
                    isStoredInMemoryOnly: false
                ),
            ]
        }

        do {
            modelContainer = try ModelContainer(
                for: Schema(
                    DataContainer.schema() + KeyboardDataContainer.schema()
                ),
                configurations: configurations
            )

            // Ensure defaults
            DataContainer.ensureDefaults(in: modelContext)
            KeyboardDataContainer.ensureDefaults(in: modelContext)

            // Start monitors
            KeyboardSessionMonitor.shared.start()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    static func schema() -> [any PersistentModel.Type] {
        [
            AppSettings.self,
            OwnedCollectible.self,
            Player.self,
        ]
    }

    static func configuration(isStoredInMemoryOnly: Bool = false)
        -> ModelConfiguration
    {
        let schema = Schema(DataContainer.schema())

        if isStoredInMemoryOnly {
            return ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: true
            )
        } else {
            return ModelConfiguration(
                "TaplingData",
                schema: schema,
                isStoredInMemoryOnly: false,
                allowsSave: true,
                cloudKitDatabase: .none
            )
        }
    }

    static func ensureDefaults(in context: ModelContext) {
        _ = AppSettings.instance(with: context)
        let player = Player.instance(with: context)

        // Ensure default collectibles exist
        let defaultCollectibleIds = ["fur_white", "face_cute"]

        for collectibleId in defaultCollectibleIds {
            let descriptor = FetchDescriptor<OwnedCollectible>(
                predicate: #Predicate { $0.collectibleId == collectibleId }
            )

            if let existing = try? context.fetch(descriptor).first {
                if existing.unlockedAt == nil {
                    existing.unlockedAt = Date()
                }
            } else {
                let ownedCollectible = OwnedCollectible(
                    collectibleId: collectibleId,
                    unlockedAt: Date(),
                    player: player
                )
                context.insert(ownedCollectible)
            }
        }

        try? context.save()
    }
}

// MARK: - Preview Support

extension View {
    func previewDataContainer(seed: ((ModelContext) -> Void)? = nil)
        -> some View
    {
        let container = DataContainer(isStoredInMemoryOnly: true)
        if let seed = seed {
            seed(container.modelContext)
            try? container.modelContext.save()
        }
        return self.modelContainer(container.modelContainer)
    }
}
