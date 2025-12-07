//
//  TaplingApp.swift
//  Tapling
//
//  Created by Benno on 02.12.25.
//

import SwiftData
import SwiftUI

@main
struct TaplingApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(DataContainer.shared.modelContainer)
    }
}
