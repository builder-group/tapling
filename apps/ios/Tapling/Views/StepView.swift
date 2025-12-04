//
//  StepView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftUI

/// A reusable numbered step view for onboarding and guides.
struct StepView: View {
    let number: Int
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            numberBadge

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var numberBadge: some View {
        Text("\(number)")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .frame(width: 32, height: 32)
            .background(Circle().fill(.blue))
    }
}

#Preview {
    VStack(spacing: 16) {
        StepView(
            number: 1,
            title: "First Step",
            description: "This is a description of the first step to complete."
        )

        StepView(
            number: 2,
            title: "Second Step",
            description: "This is a description of the second step to complete."
        )
    }
    .padding()
}
