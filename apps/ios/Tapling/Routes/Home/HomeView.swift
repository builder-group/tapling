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
    @State private var selectedCardId: String?
    @State private var selectedCollectibleForDetail: AnyCollectible?

    private let maxHeaderHeight: CGFloat = 100
    private let minHeaderHeight: CGFloat = 50
    private let scrollThreshold: CGFloat = 80

    private var headerHeight: CGFloat {
        let progress = min(max(scrollOffset / scrollThreshold, 0), 1)
        return maxHeaderHeight - (maxHeaderHeight - minHeaderHeight) * progress
    }

    private var canAffordChest: Bool {
        player.currentKeycaps >= GameConfig.cardboardBoxCost
    }

    // MARK: - UI

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HomeHeaderView(
                    headerHeight: headerHeight,
                    taplingScale: 1.5
                )
                .background(Color.green)
                .overlay(alignment: .topLeading) {
                    HStack(spacing: 12) {
                        keycapDisplay
                        chestButton
                    }
                    .padding(.top, 8)
                    .padding(.leading, 16)
                }
                .zIndex(10)

                if #available(iOS 18.0, *) {
                    scrollViewModern
                } else {
                    scrollViewLegacy
                }
            }
            .fullScreenCover(isPresented: $showCardboardBoxOpening) {
                CardboardBoxOpeningView(onCollect: handleCollectibleWon)
            }
            .navigationDestination(item: $selectedCollectibleForDetail) {
                (collectible: AnyCollectible) in
                CollectibleDetailView(
                    collectible: collectible,
                    isUnlocked: true,
                    count: collectibleDetailCount(for: collectible),
                    firstUnlockedDate: collectibleDetailFirstUnlockedDate(
                        for: collectible
                    )
                )
            }
        }
    }

    @available(iOS 18.0, *)
    private var scrollViewModern: some View {
        ScrollView {
            contentView
            footerContent
        }
        .ignoresSafeArea(edges: .bottom)
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
                footerContent
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .coordinateSpace(name: "scrollView")
    }

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 20) {
            EquippedView(
                selectedCardId: $selectedCardId,
                onShowDetail: { collectible in
                    selectedCollectibleForDetail = collectible
                }
            )
            .zIndex(2)
            CardCollectionView(
                selectedCardId: $selectedCardId,
                onShowDetail: { collectible in
                    selectedCollectibleForDetail = collectible
                }
            )
            .zIndex(1)
            HomeStatsView()
            HomeCommunityView()
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            // Only deselect if tapping on empty space (not on a card)
            if selectedCardId != nil {
                selectedCardId = nil
            }
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

    private var chestButton: some View {
        Button {
            openChest()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "shippingbox.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                Text("\(GameConfig.cardboardBoxCost)")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        canAffordChest
                            ? Color.orange.opacity(0.8)
                            : Color.gray.opacity(0.4)
                    )
            )
        }
        .disabled(!canAffordChest)
    }

    private var footerContent: some View {
        VStack {
            Spacer()
            HomeFooterView()
        }
        // Workaround: Footer pushed down to full screen height to hide header scaling bug.
        // Our custom scaling header interferes with iOS rubber band scrolling when content
        // is too short to be scrollable. This ensures content is always scrollable.
        .frame(height: UIScreen.main.bounds.height)
    }

    // MARK: - Actions

    private func openChest() {
        guard canAffordChest else { return }

        player.currentKeycaps -= GameConfig.cardboardBoxCost
        try? modelContext.save()
        showCardboardBoxOpening = true
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

    private func collectibleDetailCount(for collectible: AnyCollectible) -> Int
    {
        let collectibleId = collectible.id
        let descriptor = FetchDescriptor<OwnedCollectible>(
            predicate: #Predicate {
                $0.collectibleId == collectibleId && $0.unlockedAt != nil
            }
        )
        return (try? modelContext.fetch(descriptor).count) ?? 0
    }

    private func collectibleDetailFirstUnlockedDate(
        for collectible: AnyCollectible
    ) -> Date? {
        let collectibleId = collectible.id
        let descriptor = FetchDescriptor<OwnedCollectible>(
            predicate: #Predicate {
                $0.collectibleId == collectibleId && $0.unlockedAt != nil
            },
            sortBy: [SortDescriptor(\.unlockedAt)]
        )
        return try? modelContext.fetch(descriptor).first?.unlockedAt
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
