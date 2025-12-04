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
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    /// Ensures singleton models exist in the given context
    static func ensureSingletons(in context: ModelContext) {
        _ = TaplingSettings.instance(with: context)
        _ = KeyboardSettings.instance(with: context)
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
