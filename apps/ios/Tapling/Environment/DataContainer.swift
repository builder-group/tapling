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
        let schema = Schema([
            TaplingSettings.self,
            KeyboardSettings.self,
            OwnedCollectible.self,
        ])

        let modelConfiguration: ModelConfiguration
        if isStoredInMemoryOnly {
            // Configure for in-memory only
            modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: true
            )
        } else {
            // Configure for App Group
            modelConfiguration = ModelConfiguration(
                "TaplingData",
                schema: schema,
                isStoredInMemoryOnly: false,
                allowsSave: true,
                groupContainer: .identifier("group.com.buildergroup.Tapling"),
                cloudKitDatabase: .none
            )
        }

        do {
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )

            // Initialize singletons
            DataContainer.ensureSingletons(in: modelContext)

            // Initialize default unlocked items
            DataContainer.ensureDefaultItems(in: modelContext)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    /// Ensures singleton models exist in the given context
    static func ensureSingletons(in context: ModelContext) {
        _ = TaplingSettings.instance(with: context)
        _ = KeyboardSettings.instance(with: context)
    }

    /// Ensures default collectibles are unlocked (white fur, cute face)
    static func ensureDefaultItems(in context: ModelContext) {
        let defaultCollectibleIds = ["fur_white", "face_cute"]
        let registry = CollectibleRegistry.shared

        for collectibleId in defaultCollectibleIds {
            // Check if already exists
            let descriptor = FetchDescriptor<OwnedCollectible>(
                predicate: #Predicate { $0.collectibleId == collectibleId }
            )

            if let existing = try? context.fetch(descriptor).first {
                // If exists but not unlocked, unlock it
                if existing.unlockedAt == nil {
                    existing.unlockedAt = Date()
                }
            } else {
                // Create new unlocked collectible
                let ownedCollectible = OwnedCollectible(collectibleId: collectibleId, unlockedAt: Date())
                context.insert(ownedCollectible)
            }
        }

        try? context.save()
    }
}

// MARK: - Preview Support

extension DataContainer {
    /// In-memory container for SwiftUI previews
    static let preview = DataContainer(isStoredInMemoryOnly: true)
}

extension View {
    /// Applies preview data container for SwiftUI previews
    func previewDataContainer() -> some View {
        self.modelContainer(DataContainer.preview.modelContainer)
    }
}
