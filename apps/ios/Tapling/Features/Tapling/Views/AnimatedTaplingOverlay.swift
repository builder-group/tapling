//
//  AnimatedTaplingOverlay.swift
//  Tapling
//
//  Created by Benno on 11.12.25.
//

import SwiftUI

struct AnimatedTaplingOverlay<Content: View>: View {
    var tapling: Tapling? = nil
    var scale: CGFloat = 0.5
    var animationInterval: TimeInterval = 0.5
    @ViewBuilder let content: () -> Content

    @State private var leftHand: HandPosition = .up
    @State private var rightHand: HandPosition = .down
    @State private var timer: Timer?
    @State private var randomFur: Fur = .default
    @State private var randomHat: Hat?
    @State private var randomFace: Face = .default

    private var currentTapling: Tapling {
        if let tapling {
            return Tapling(
                fur: tapling.fur,
                hat: tapling.hat,
                face: tapling.face,
                leftHand: leftHand,
                rightHand: rightHand
            )
        } else {
            return Tapling(
                fur: randomFur,
                hat: randomHat,
                face: randomFace,
                leftHand: leftHand,
                rightHand: rightHand
            )
        }
    }

    // MARK: - UI

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                BottomAlignedTaplingView(
                    tapling: currentTapling,
                    scale: scale
                )
            }
            .zIndex(1)
            content()
        }
        .onAppear {
            if tapling == nil {
                randomizeAccessories()
            }
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
        timer = Timer.scheduledTimer(
            withTimeInterval: animationInterval,
            repeats: true
        ) { _ in
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
    AnimatedTaplingOverlay(scale: 0.5) {
        Button(action: {}) {
            Text("Meet your Tapling")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.blue)
                )
        }
    }
    .padding()
}
