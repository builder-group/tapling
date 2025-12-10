//
//  ContentView.swift
//  Tapling
//
//  Created by Benno on 02.12.25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @QuerySingleton private var player: Player
    @State private var showSplash = true

    // MARK: - UI

    var body: some View {
        Group {
            if showSplash {
                SplashView()
                    .onAppear {
                        Task {
                            try? await Task.sleep(nanoseconds: 1_000_000_000)
                            showSplash = false
                        }
                    }
            } else if player.onboardingCompletedAt == nil {
                OnboardingView()
            } else {
                mainTabView
            }
        }
    }

    private var mainTabView: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            CollectibleView()
                .tabItem {
                    Label("Collection", systemImage: "square.grid.2x2.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .previewDataContainer()
}
