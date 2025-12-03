//
//  ContentView.swift
//  Tapling
//
//  Created by Benno on 02.12.25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        SettingsView()
    }
}

#Preview {
    ContentView()
        .modelContainer(DataContainer.shared.modelContainer)
}
