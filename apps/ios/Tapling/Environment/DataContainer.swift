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
        let configurations = [
            DataContainer.configuration(
                isStoredInMemoryOnly: isStoredInMemoryOnly
            ),
            KeyboardDataContainer.configuration(
                isStoredInMemoryOnly: isStoredInMemoryOnly
            ),
        ]

        do {
            modelContainer = try ModelContainer(
                for: Schema(
                    DataContainer.schema() + KeyboardDataContainer.schema()
                ),
                configurations: configurations
            )

            KeyboardDataContainer.ensureDefaults(in: modelContext)
            DataContainer.ensureDefaults(in: modelContext)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    static func schema() -> [any PersistentModel.Type] {
        [
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
                groupContainer: .identifier("group.com.buildergroup.Tapling"),
                cloudKitDatabase: .none
            )
        }
    }

    static func ensureDefaults(in context: ModelContext) {
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
                    unlockedAt: Date()
                )
                context.insert(ownedCollectible)
            }
        }

        try? context.save()
    }
}

// MARK: - Preview Support

extension DataContainer {
    static let preview = DataContainer(isStoredInMemoryOnly: true)
}

extension View {
    func previewDataContainer() -> some View {
        self.modelContainer(DataContainer.preview.modelContainer)
    }
}
