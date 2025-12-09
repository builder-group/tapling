//
//  CollectibleActionButtons.swift
//  Tapling
//
//  Created by Benno on 09.12.25.
//

import SwiftUI

struct CollectibleInfoUseActionButtons: View {
    let cardSize: CGFloat
    let onInfo: () -> Void
    let onUse: () -> Void

    var body: some View {
        VStack(spacing: 4) {
            Button(action: onInfo) {
                Text("Info")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(8)
            }

            Button(action: onUse) {
                Text("Use")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(
                        LinearGradient(
                            colors: [Color.orange, Color.orange.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
        .frame(width: cardSize)
    }
}

struct CollectibleInfoRemoveActionButtons: View {
    let cardSize: CGFloat
    let onInfo: () -> Void
    let onRemove: () -> Void
    let canRemove: Bool

    var body: some View {
        VStack(spacing: 4) {
            Button(action: onInfo) {
                Text("Info")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(8)
            }

            Button(action: onRemove) {
                Text("Remove")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(
                        LinearGradient(
                            colors: canRemove
                                ? [Color.red, Color.red.opacity(0.8)]
                                : [Color.gray, Color.gray.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(8)
            }
            .disabled(!canRemove)
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
        .frame(width: cardSize)
    }
}
