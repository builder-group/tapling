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
