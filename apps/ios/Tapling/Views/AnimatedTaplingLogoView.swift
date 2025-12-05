//
//  AnimatedTaplingLogoView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftUI

struct AnimatedTaplingLogoView: View {
    @State private var leftHandUp = true
    @State private var rotationDegrees: Double = 0

    private enum Animation {
        static let tapInterval = 0.6
        static let tapDuration = 0.3
        static let rainbowDuration = 3.0
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
            fur: .white,
            hat: .lilDuck,
            face: .cute,
            leftHand: leftHandUp ? .up : .down,
            rightHand: leftHandUp ? .down : .up
        )
    }

    // MARK: - UI

    var body: some View {
        TaplingView(tapling: currentTapling)
            .frame(width: Layout.size, height: Layout.size)
            .animation(
                .easeInOut(duration: Animation.tapDuration),
                value: leftHandUp
            )
            .background(logoBackground)
            .overlay(rainbowBorder)
            .onAppear {
                startAnimations()
            }
    }

    private var logoBackground: some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
            .fill(.white)
            .shadow(
                color: .blue.opacity(Animation.glowOpacity),
                radius: Animation.glowRadius,
                y: 0
            )
            .shadow(
                color: .purple.opacity(Animation.glowOpacity),
                radius: Animation.glowRadius,
                y: 0
            )
            .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }

    private var rainbowBorder: some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
            .strokeBorder(
                AngularGradient(
                    colors: [
                        .blue, .cyan, .green, .yellow, .orange, .red, .purple,
                        .blue,
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
        startRainbowAnimation()
    }

    private func startTappingAnimation() {
        Timer.scheduledTimer(
            withTimeInterval: Animation.tapInterval,
            repeats: true
        ) { _ in
            leftHandUp.toggle()
        }
    }

    private func startRainbowAnimation() {
        withAnimation(
            .linear(duration: Animation.rainbowDuration).repeatForever(
                autoreverses: false
            )
        ) {
            rotationDegrees = 360
        }
    }
}

#Preview {
    AnimatedTaplingLogoView()
        .padding()
}
