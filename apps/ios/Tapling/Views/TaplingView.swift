//
//  TaplingView.swift
//  Tapling
//
//  Created by Benno on 02.12.25.
//

import SwiftUI

/// View that displays a Tapling character with layered parts.
struct TaplingView: View {
    let tapling: Tapling
    let config = TaplingConfig.shared

    var body: some View {
        ZStack {
            // Fur base layer
            Image(config.furBaseName(fur: tapling.fur))
                .resizable()
                .scaledToFit()

            // Fur left hand layer
            Image(config.furLeftHandName(fur: tapling.fur, hand: tapling.leftHand))
                .resizable()
                .scaledToFit()

            // Face layer
            Image(config.faceName(face: tapling.face))
                .resizable()
                .scaledToFit()

            // Hat layer
            if let hat = tapling.hat {
                Image(config.hatName(hat: hat))
                    .resizable()
                    .scaledToFit()
            }

            // Fur right hand layer
            Image(config.furRightHandName(fur: tapling.fur, hand: tapling.rightHand))
                .resizable()
                .scaledToFit()
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    TaplingView(
        tapling: Tapling(
            fur: TaplingConfig.Fur.white,
            hat: TaplingConfig.Hat.lilDuck,
            face: TaplingConfig.Face.cute,
            leftHand: TaplingConfig.Hand.up,
            rightHand: TaplingConfig.Hand.down
        )
    )
    .frame(width: TaplingConfig.shared.baseSize, height: TaplingConfig.shared.baseSize)
    .padding()
}

