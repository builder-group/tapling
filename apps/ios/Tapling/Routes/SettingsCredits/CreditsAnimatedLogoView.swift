//
//  CreditsAnimatedLogoView.swift
//  Tapling
//
//  Created by Benno on 05.12.25.
//

import SwiftUI

struct CreditsAnimatedLogoView: View {
    @State private var leftHandUp = true
    @State private var rotationDegrees: Double = 0

    private enum Animation {
        static let tapInterval = 0.6
        static let tapDuration = 0.3
        static let loveBorderDuration = 3.0
        static let glowOpacity = 0.15
        static let glowRadius = 12.0
    }

    private enum Layout {
        static let size: CGFloat = 120
        static let cornerRadius: CGFloat = 28
        static let borderWidth: CGFloat = 3
    }

    private var currentTapling: Tapling {
        Tapling(
            fur: .default,
            hat: Hat.get("hat_heart"),
            face: .default,
            leftHand: leftHandUp ? .up : .down,
            rightHand: leftHandUp ? .down : .up
        )
    }

    // MARK: - UI

    var body: some View {
        ZStack {
            TaplingView(tapling: currentTapling)
                .frame(width: Layout.size, height: Layout.size)
                .animation(
                    .easeInOut(duration: Animation.tapDuration),
                    value: leftHandUp
                )
                .background(logoBackground)
                .overlay(loveBorder)

            heartRisingView
        }
        .onAppear {
            startAnimations()
        }
    }

    private var heartRisingView: some View {
        HeartRisingView(
            spawnSize: CGSize(width: 10, height: 10),
            targetSize: CGSize(width: 80, height: 40),
            riseDistance: 70,
            riseDuration: 4.0,
            spawnInterval: 0.8...1.5,
            maxHearts: 4,
            heartSize: 10,
            // debug: true
        )
        .offset(x: -Layout.size / 5, y: -Layout.size / 10)
        .allowsHitTesting(false)
    }

    private var logoBackground: some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
            .fill(.white)
            .shadow(
                color: .red.opacity(Animation.glowOpacity),
                radius: Animation.glowRadius,
                y: 0
            )
            .shadow(
                color: .pink.opacity(Animation.glowOpacity),
                radius: Animation.glowRadius,
                y: 0
            )
            .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }

    private var loveBorder: some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
            .strokeBorder(
                AngularGradient(
                    colors: [
                        .red, .pink, .red, .pink,
                        .red,
                    ],
                    center: .center,
                    startAngle: .degrees(rotationDegrees),
                    endAngle: .degrees(rotationDegrees + 360)
                ),
                lineWidth: Layout.borderWidth
            )
    }

    // MARK: - Actions

    private func startAnimations() {
        startTappingAnimation()
        startLoveBorderAnimation()
    }

    private func startTappingAnimation() {
        Timer.scheduledTimer(
            withTimeInterval: Animation.tapInterval,
            repeats: true
        ) { _ in
            leftHandUp.toggle()
        }
    }

    private func startLoveBorderAnimation() {
        withAnimation(
            .linear(duration: Animation.loveBorderDuration).repeatForever(
                autoreverses: false
            )
        ) {
            rotationDegrees = 360
        }
    }
}

#Preview {
    CreditsAnimatedLogoView()
        .padding()
}
