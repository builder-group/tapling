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

    init() {
        let schema = Schema([
            TaplingSettings.self,
            KeyboardSettings.self,
        ])

        // Configure for App Group
        let appGroupId = "group.com.buildergroup.Tapling"
        let configuration = ModelConfiguration(
            "TaplingData",
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true,
            groupContainer: .identifier(appGroupId),
            cloudKitDatabase: .none
        )

        do {
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )

            ensureSingletons()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    /// Ensures singleton models exist in the store
    private func ensureSingletons() {
        _ = TaplingSettings.instance(with: modelContext)
        _ = KeyboardSettings.instance(with: modelContext)
    }
}
