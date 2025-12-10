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
        VStack(spacing: 6) {
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                onInfo()
            }) {
                Text("Info")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .controlSize(.small)

            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                onUse()
            }) {
                Text("Use")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .controlSize(.small)
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .frame(width: cardSize)
    }
}

struct CollectibleInfoRemoveActionButtons: View {
    let cardSize: CGFloat
    let onInfo: () -> Void
    let onRemove: () -> Void
    let canRemove: Bool

    var body: some View {
        VStack(spacing: 6) {
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                onInfo()
            }) {
                Text("Info")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .controlSize(.small)

            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                onRemove()
            }) {
                Text("Remove")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .tint(canRemove ? .red : .gray)
            .controlSize(.small)
            .disabled(!canRemove)
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .frame(width: cardSize)
    }
}
