//
//  HomeView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext

    @QuerySingleton private var player: Player
    @Query(sort: \KeyboardSession.createdAt, order: .reverse) private
        var sessions: [KeyboardSession]

    @State private var showCardboxOpening = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Player Stats")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Total Keystrokes: \(player.totalKeystrokes)")
                        .font(.headline)

                    Text("Total Keycaps Earned: \(player.totalKeycapsEarned)")
                        .font(.headline)

                    Text("Current Keycaps: \(player.currentKeycaps)")
                        .font(.headline)
                }
                .padding()

                Button("Open Cardbox") {
                    showCardboxOpening = true
                }
                .buttonStyle(.borderedProminent)
                .padding()

                // Debug: Show keyboard sessions count
                if !sessions.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Keyboard Sessions (Debug)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)

                        Text("Count: \(sessions.count)")
                            .font(.headline)
                    }
                    .padding()
                }
            }
            .padding()
        }
        .sheet(isPresented: $showCardboxOpening) {
            CardboxOpeningView(onCollect: handleCollectibleWon)
        }
    }

    private func handleCollectibleWon(_ collectible: AnyCollectible) {
        let ownedCollectible = OwnedCollectible(
            collectibleId: collectible.id,
            unlockedAt: Date()
        )
        modelContext.insert(ownedCollectible)
        try? modelContext.save()
    }

    private func formatDuration(from start: Date, to end: Date) -> String {
        let duration = end.timeIntervalSince(start)
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%dm %ds", minutes, seconds)
    }
}

#Preview {
    HomeView()
        .previewDataContainer()
}
