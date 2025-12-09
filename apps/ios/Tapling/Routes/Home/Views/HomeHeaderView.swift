//
//  HomeHeaderView.swift
//  Tapling
//
//  Created by Benno on 09.12.25.
//

import SwiftData
import SwiftUI

struct HomeHeaderView: View {
    var headerHeight: CGFloat = 200
    var taplingScale: CGFloat = 1.0

    @QuerySingleton private var keyboardTapling: KeyboardTapling

    @State private var leftHand: HandPosition = .up
    @State private var rightHand: HandPosition = .down

    private var baseScale: CGFloat {
        let baseVisibleHeight =
            TaplingConfig.baseSize
            - TaplingConfig.baseBodyBottomOffset
        return headerHeight / baseVisibleHeight
    }

    private var taplingSize: CGFloat {
        TaplingConfig.baseSize * baseScale * taplingScale
    }

    private var taplingBottomOffset: CGFloat {
        TaplingConfig.baseBodyBottomOffset
            * (taplingSize / TaplingConfig.baseSize)
    }

    private var currentTapling: Tapling {
        Tapling(
            fur: keyboardTapling.equippedFur,
            hat: keyboardTapling.equippedHat,
            face: keyboardTapling.equippedFace,
            leftHand: leftHand,
            rightHand: rightHand
        )
    }

    // MARK: - UI

    var body: some View {
        Color.blue
            .frame(maxWidth: .infinity)
            .frame(height: headerHeight)
            .background(alignment: .top) {
                Color.blue
                    .ignoresSafeArea(.container, edges: .top)
            }
            .overlay(alignment: .bottomTrailing) {
                taplingOverlay
            }
            .onTapGesture {
                toggleHands()
            }
    }

    private var taplingOverlay: some View {
        TaplingView(tapling: currentTapling)
            .frame(width: taplingSize, height: taplingSize)
            .offset(y: taplingBottomOffset)
            .allowsHitTesting(false)
    }

    // MARK: - Actions

    private func toggleHands() {
        leftHand = leftHand == .down ? .up : .down
        rightHand = rightHand == .down ? .up : .down
    }
}

#Preview {
    VStack(spacing: 0) {
        HomeHeaderView(headerHeight: 100, taplingScale: 1.5)
            .previewDataContainer()
        ScrollView {
            Text("Scroll View!")
        }
    }
}
