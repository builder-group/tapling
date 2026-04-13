//
//  HomeStatsView.swift
//  Tapling
//
//  Created by Codex on 13.04.26.
//

import SwiftData
import SwiftUI

struct HomeStatsView: View {
    @Query(
        filter: #Predicate<OwnedCollectible> { $0.unlockedAt != nil }
    ) private var ownedCollectibles: [OwnedCollectible]
    @QuerySingleton private var player: Player

    private var collectedItemCount: Int {
        Set(ownedCollectibles.map(\.collectibleId)).count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Stats")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)

            statCard(
                icon: "keyboard",
                title: "Keystrokes",
                value: player.totalKeystrokes.formatted(),
                valueFont: .system(size: 34, weight: .bold, design: .rounded)
            )

            HStack(spacing: 12) {
                statCard(
                    icon: "square.stack.3d.up.fill",
                    title: "Items Collected",
                    value: collectedItemCount.formatted(),
                    valueFont: .system(
                        size: 24,
                        weight: .bold,
                        design: .rounded
                    )
                )

                statCard(
                    icon: "k.square",
                    title: "Keycaps Earned",
                    value: player.totalKeycapsEarned.formatted(),
                    valueFont: .system(
                        size: 24,
                        weight: .bold,
                        design: .rounded
                    )
                )
            }
        }
    }

    private func statCard(
        icon: String,
        title: String,
        value: String,
        valueFont: Font
    )
        -> some View
    {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            Text(value)
                .font(valueFont)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    HomeStatsView()
        .previewDataContainer { context in
            let player = Player.instance(with: context)
            player.totalKeystrokes = 12_534
            player.totalKeycapsEarned = 14_287

            context.insert(
                OwnedCollectible(
                    collectibleId: "preview-1",
                    unlockedAt: Date(),
                    player: player
                )
            )
            context.insert(
                OwnedCollectible(
                    collectibleId: "preview-2",
                    unlockedAt: Date(),
                    player: player
                )
            )
            context.insert(
                OwnedCollectible(
                    collectibleId: "preview-3",
                    unlockedAt: Date(),
                    player: player
                )
            )
        }
        .padding()
}
