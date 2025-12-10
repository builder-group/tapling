//
//  SplashView.swift
//  Tapling
//
//  Created by Benno on 10.12.25.
//

import SwiftUI

struct SplashView: View {
    @State private var leftHand: HandPosition = .up
    @State private var rightHand: HandPosition = .down
    @State private var timer: Timer?
    @State private var randomFur: Fur = .default
    @State private var randomHat: Hat?
    @State private var randomFace: Face = .default

    private var currentTapling: Tapling {
        Tapling(
            fur: randomFur,
            hat: randomHat,
            face: randomFace,
            leftHand: leftHand,
            rightHand: rightHand
        )
    }

    // MARK: - UI

    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            TaplingView(tapling: currentTapling)
                .frame(
                    width: TaplingConfig.baseSize,
                    height: TaplingConfig.baseSize
                )
        }
        .onAppear {
            randomizeAccessories()
            startTappingAnimation()
        }
        .onDisappear {
            stopTappingAnimation()
        }
    }

    // MARK: - Actions

    private func randomizeAccessories() {
        randomFur = Fur.all.randomElement() ?? .default
        randomHat = Bool.random() ? Hat.all.randomElement() : nil
        randomFace = Face.all.randomElement() ?? .default
    }

    private func startTappingAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) {
            _ in
            toggleHands()
        }
    }

    private func stopTappingAnimation() {
        timer?.invalidate()
        timer = nil
    }

    private func toggleHands() {
        leftHand = leftHand == .down ? .up : .down
        rightHand = rightHand == .down ? .up : .down
    }
}

#Preview {
    SplashView()
}
