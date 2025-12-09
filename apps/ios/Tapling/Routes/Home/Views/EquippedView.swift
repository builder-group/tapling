//
//  EquippedView.swift
//  Tapling
//
//  Created by Benno on 09.12.25.
//

import SwiftData
import SwiftUI

struct EquippedView: View {
    @QuerySingleton private var keyboardTapling: KeyboardTapling

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerSection
            traitsRow
        }
        .padding(.horizontal, 16)
    }

    private var headerSection: some View {
        Text("Equipped")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(.primary)
    }

    private var traitsRow: some View {
        HStack(spacing: 12) {
            VStack(spacing: 8) {
                EquippedCollectibleCardView(
                    collectible: .fur(keyboardTapling.equippedFur)
                )
                .frame(maxWidth: .infinity)

                Text("Fur")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
            }

            VStack(spacing: 8) {
                EquippedCollectibleCardView(
                    collectible: .face(keyboardTapling.equippedFace)
                )
                .frame(maxWidth: .infinity)

                Text("Face")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
            }

            VStack(spacing: 8) {
                EquippedCollectibleCardView(
                    collectible: keyboardTapling.equippedHat.map { .hat($0) }
                )
                .frame(maxWidth: .infinity)

                Text("Hat")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        keyboardTapling.equippedHat == nil
                            ? .secondary : .primary
                    )
            }
        }
    }
}

#Preview {
    EquippedView()
        .previewDataContainer()
}
