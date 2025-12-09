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
        VStack(spacing: 0) {
            HomeHeaderView(headerHeight: 100, taplingScale: 1.5)
                .background(Color.green)
                .overlay(alignment: .topLeading) {
                    keycapDisplay
                        .padding(.top, 8)
                        .padding(.leading, 16)
                }
            ScrollView {
                Text("Test")
            }

            //            ScrollView {
            //                VStack(alignment: .leading, spacing: 20) {
            //                    Button("Open Cardbox") {
            //                        var transaction = Transaction()
            //                        transaction.disablesAnimations = true
            //                        withTransaction(transaction) {
            //                            showCardboardBoxOpening = true
            //                        }
            //                    }
            //                    .buttonStyle(.borderedProminent)
            //                    .padding()
            //                }
            //                .padding()
            //            }.background(Color.red)
        }
        .fullScreenCover(isPresented: $showCardboardBoxOpening) {
            CardboardBoxOpeningView(onCollect: handleCollectibleWon)
        }
    }

    private var keycapDisplay: some View {
        HStack(spacing: 6) {
            Image("keycap")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)

            Text("\(player.currentKeycaps)")
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.black.opacity(0.4))
        )
    }

    private func handleCollectibleWon(_ collectible: AnyCollectible?) {
        if let collectible = collectible {
            let ownedCollectible = OwnedCollectible(
                collectibleId: collectible.id,
                unlockedAt: Date(),
                player: player
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
