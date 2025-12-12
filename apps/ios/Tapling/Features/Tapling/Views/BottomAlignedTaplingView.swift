//
//  BottomAlignedTaplingView.swift
//  Tapling
//
//  Created by Benno on 11.12.25.
//

import SwiftUI

struct BottomAlignedTaplingView: View {
    let tapling: Tapling
    var scale: CGFloat = 1.0

    private var taplingSize: CGFloat {
        TaplingConfig.baseSize * scale
    }

    private var bottomOffset: CGFloat {
        TaplingConfig.baseBodyBottomOffset
            * (taplingSize / TaplingConfig.baseSize)
    }

    // MARK: - UI

    var body: some View {
        TaplingView(tapling: tapling)
            .frame(width: taplingSize, height: taplingSize)
            .offset(y: bottomOffset)
            .frame(
                width: taplingSize,
                height: taplingSize - bottomOffset,
                alignment: .bottom
            )
            .allowsHitTesting(false)
    }
}

#Preview {
    VStack(spacing: 0) {
        BottomAlignedTaplingView(
            tapling: Tapling(
                fur: .default,
                hat: Hat.get("hat_lil-duck"),
                face: Face.get("face_cute")!,
                leftHand: .up,
                rightHand: .down
            ),
            scale: 1.0
        )
        .zIndex(1)
        .background(Color.green)
        Rectangle()
            .fill(Color.red)
            .frame(height: 20)
            .frame(maxWidth: .infinity)
    }
}
