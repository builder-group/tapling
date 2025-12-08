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

    @State private var showCardboardBoxOpening = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Button("Open Cardboard Box") {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            showCardboardBoxOpening = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                .padding()
            }

            keycapDisplay
                .padding()
        }
        .fullScreenCover(isPresented: $showCardboardBoxOpening) {
            CardboardBoxOpeningView(onCollect: handleCollectibleWon)
        }
    }

    private var keycapDisplay: some View {
        HStack(spacing: 8) {
            Image("keycap")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)

            Text("\(player.currentKeycaps)")
                .font(.headline)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.gray.opacity(0.2))
        )
    }

    private func handleCollectibleWon(_ collectible: AnyCollectible?) {
        if let collectible = collectible {
            let ownedCollectible = OwnedCollectible(
                collectibleId: collectible.id,
                unlockedAt: Date()
            )
            modelContext.insert(ownedCollectible)
            try? modelContext.save()
        }
        showCardboardBoxOpening = false
    }
}

#Preview {
    HomeView()
        .previewDataContainer { context in
            let player = Player.instance(with: context)
            player.currentKeycaps = 150
            player.totalKeycapsEarned = 500
            player.totalKeystrokes = 12500
            player.firstActiveDate = Calendar.current.date(
                byAdding: .day,
                value: -30,
                to: Date()
            )
            player.lastActiveDate = Date()
        }
}
