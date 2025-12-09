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
    @State private var scrollOffset: CGFloat = 0

    private let maxHeaderHeight: CGFloat = 100
    private let minHeaderHeight: CGFloat = 50
    private let scrollThreshold: CGFloat = 80

    private var headerHeight: CGFloat {
        let progress = min(max(scrollOffset / scrollThreshold, 0), 1)
        return maxHeaderHeight - (maxHeaderHeight - minHeaderHeight) * progress
    }

    // MARK: - UI

    var body: some View {
        VStack(spacing: 0) {
            HomeHeaderView(
                headerHeight: headerHeight,
                taplingScale: 1.5
            )
            .background(Color.green)
            .overlay(alignment: .topLeading) {
                keycapDisplay
                    .padding(.top, 8)
                    .padding(.leading, 16)
            }

            if #available(iOS 18.0, *) {
                scrollViewModern
            } else {
                scrollViewLegacy
            }
        }
        .fullScreenCover(isPresented: $showCardboardBoxOpening) {
            CardboardBoxOpeningView(onCollect: handleCollectibleWon)
        }
    }

    @available(iOS 18.0, *)
    private var scrollViewModern: some View {
        ScrollView {
            contentView
        }
        .onScrollGeometryChange(for: CGFloat.self) { geometry in
            geometry.contentOffset.y
        } action: { _, newValue in
            scrollOffset = max(newValue, 0)
        }
    }

    @available(iOS 13.0, *)
    private var scrollViewLegacy: some View {
        ScrollView {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    let offset = geometry.frame(in: .named("scrollView")).minY
                    Color.clear
                        .onChange(of: offset) { _, newValue in
                            scrollOffset = max(-newValue, 0)
                        }
                }
                .frame(height: 0)

                contentView
            }
        }
        .coordinateSpace(name: "scrollView")
    }

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 20) {
            EquippedView()
            CardCollectionView()
        }
        .padding()
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

    // MARK: - Actions

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

            let registry = CollectibleRegistry.shared
            for collectible in registry.allCollectibles {
                let ownedCollectible = OwnedCollectible(
                    collectibleId: collectible.id,
                    unlockedAt: Date(),
                    player: player
                )
                context.insert(ownedCollectible)
            }
        }
}
