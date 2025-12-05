//
//  TaplingView.swift
//  Tapling
//
//  Created by Benno on 02.12.25.
//

import SwiftUI

struct TaplingView: View {
    let tapling: Tapling

    var body: some View {
        ZStack {
            // Fur base layer
            Image(tapling.fur.baseAssetName())
                .resizable()
                .scaledToFit()

            // Fur left hand layer
            Image(tapling.fur.leftHandAssetName(tapling.leftHand))
                .resizable()
                .scaledToFit()

            // Face layer
            Image(tapling.face.assetName())
                .resizable()
                .scaledToFit()

            // Hat layer
            if let hat = tapling.hat {
                Image(hat.assetName())
                    .resizable()
                    .scaledToFit()
            }

            // Fur right hand layer
            Image(tapling.fur.rightHandAssetName(tapling.rightHand))
                .resizable()
                .scaledToFit()
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    TaplingView(
        tapling: Tapling(
            fur: .default,
            hat: Hat.get("hat_lil-duck"),
            face: Face.get("face_pilot")!,
            leftHand: .up,
            rightHand: .down
        )
    )
    .frame(
        width: TaplingConfig.baseSize,
        height: TaplingConfig.baseSize
    )
    .padding()
}
