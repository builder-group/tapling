//
//  HomeView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @QuerySingleton private var player: Player
    @Query(sort: \KeyboardSession.createdAt, order: .reverse) private
        var sessions: [KeyboardSession]

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
