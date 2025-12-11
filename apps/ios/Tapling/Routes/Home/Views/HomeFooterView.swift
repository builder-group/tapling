//
//  HomeFooterView.swift
//  Tapling
//
//  Created by Benno on 10.12.25.
//

import SwiftData
import SwiftUI

struct HomeFooterView: View {
    var taplingScale: CGFloat = 1.0

    @QuerySingleton private var keyboardTapling: KeyboardTapling

    private var currentTapling: Tapling {
        Tapling(
            fur: keyboardTapling.equippedFur,
            hat: keyboardTapling.equippedHat,
            face: keyboardTapling.equippedFace,
            leftHand: .up,
            rightHand: .up
        )
    }

    // MARK: - UI

    var body: some View {
        BottomAlignedTaplingView(tapling: currentTapling, scale: taplingScale)
            .overlay(alignment: .bottom) {
                SpeechBubble(radius: 12, tailPosition: .bottom)
                    .fill(Color.white.opacity(0.9))
                    .overlay(
                        SpeechBubble(radius: 12, tailPosition: .bottom)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    )
                    .frame(width: 120, height: 60)
                    .overlay(
                        Text("meow meow")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                    )
                    .offset(
                        x: 20,
                        y:
                            -(TaplingConfig.baseSize
                            - TaplingConfig.baseBodyBottomOffset - 60)
                            * taplingScale
                    )
            }
    }
}

#Preview {
    ScrollView {
        VStack {
            Text("Scroll content")
                .frame(height: 1000)
            HomeFooterView()
        }
        .frame(maxWidth: .infinity)
    }
    .ignoresSafeArea(edges: .bottom)
    .previewDataContainer()
}
