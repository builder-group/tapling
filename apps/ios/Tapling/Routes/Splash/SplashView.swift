//
//  SplashView.swift
//  Tapling
//
//  Created by Benno on 10.12.25.
//

import SwiftUI

struct SplashView: View {
    var scale: CGFloat = 0.75

    @State private var leftHand: HandPosition = .up
    @State private var rightHand: HandPosition = .down
    @State private var timer: Timer?
    @State private var randomFur: Fur = .default
    @State private var randomHat: Hat?
    @State private var randomFace: Face = .default

    private var taplingSize: CGFloat {
        TaplingConfig.baseSize * scale
    }

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
                    width: taplingSize,
                    height: taplingSize
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
        randomFur = Fur.all.filter { !$0.isHidden }.randomElement() ?? .default
        randomHat =
            Bool.random()
            ? Hat.all.filter { !$0.isHidden }.randomElement() : nil
        randomFace =
            Face.all.filter { !$0.isHidden }.randomElement() ?? .default
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
