//
//  SettingsDebugView.swift
//  Tapling
//
//  Created by Benno on 07.12.25.
//

import SwiftData
import SwiftUI

struct SettingsDebugView: View {
    @Environment(\.modelContext) private var modelContext
    @QuerySingleton private var player: Player
    @QuerySingleton private var keyboardSettings: KeyboardSettings

    private var keyboardDebugBinding: Binding<Bool> {
        Binding(
            get: { keyboardSettings.debug },
            set: { newValue in
                keyboardSettings.debug = newValue
                try? modelContext.save()
            }
        )
    }

    var body: some View {
        Form {
            Section("Keyboard") {
                Toggle("Debug", isOn: keyboardDebugBinding)

                NavigationLink {
                    SettingsDebugSessionsView()
                } label: {
                    Label("Sessions", systemImage: "keyboard")
                }
            }

            #if DEBUG
                Section("Collectibles") {
                    Button {
                        unlockAllCollectibles()
                    } label: {
                        Label("Get All", systemImage: "tray.and.arrow.down")
                    }
                }

                Section("Keycaps") {
                    Button {
                        addCardboardBoxCost()
                    } label: {
                        Label(
                            "Add Cardbox Cost (+\(GameConfig.cardboardBoxCost))",
                            systemImage: "dollarsign.circle"
                        )
                    }
                }
            #endif
        }
        .navigationTitle("Debug")
        .navigationBarTitleDisplayMode(.inline)
    }

    #if DEBUG
        private func unlockAllCollectibles() {
            let allCollectibles = CollectibleRegistry.shared.allCollectibles

            for collectible in allCollectibles {
                let ownedCollectible = OwnedCollectible(
                    collectibleId: collectible.id,
                    unlockedAt: Date(),
                    player: player
                )
                modelContext.insert(ownedCollectible)
            }

            try? modelContext.save()
        }

        private func addCardboardBoxCost() {
            player.currentKeycaps += GameConfig.cardboardBoxCost
            try? modelContext.save()
        }
    #endif
}

#Preview {
    NavigationStack {
        SettingsDebugView()
            .previewDataContainer()
    }
}
