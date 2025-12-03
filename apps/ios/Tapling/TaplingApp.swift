//
//  TaplingApp.swift
//  Tapling
//
//  Created by Benno on 02.12.25.
//

import SwiftUI
import SwiftData

@main
struct TaplingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(DataContainer.shared.modelContainer)
    }
}
