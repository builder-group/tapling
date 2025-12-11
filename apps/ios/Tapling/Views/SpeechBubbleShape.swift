//
//  SpeechBubbleShape.swift
//  Tapling
//
//  Created by Benno on 11.12.25.
//
// Based on: https://stackoverflow.com/questions/68883032/swiftui-how-to-combine-two-shapes-to-create-a-speech-bubble-with-strokes

import SwiftUI

struct SpeechBubble: Shape {
    private let radius: CGFloat
    private let tailSize: CGFloat

    init(radius: CGFloat = 10) {
        self.radius = radius
        tailSize = 20
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY - radius))
            path.addLine(
                to: CGPoint(x: rect.minX, y: rect.maxY - rect.height / 2)
            )
            path.addCurve(
                to: CGPoint(
                    x: rect.minX,
                    y: rect.maxY - rect.height / 2 - tailSize
                ),
                control1: CGPoint(
                    x: rect.minX - tailSize,
                    y: rect.maxY - rect.height / 2
                ),
                control2: CGPoint(
                    x: rect.minX,
                    y: rect.maxY - rect.height / 2 - tailSize / 2
                )
            )
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                radius: radius,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 270),
                clockwise: false
            )
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                radius: radius,
                startAngle: Angle(degrees: 270),
                endAngle: Angle(degrees: 0),
                clockwise: false
            )
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 90),
                clockwise: false
            )
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: Angle(degrees: 90),
                endAngle: Angle(degrees: 180),
                clockwise: false
            )
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        SpeechBubble()
            .stroke(Color.gray, lineWidth: 3)
            .frame(width: 300, height: 80)
    }
    .padding()
}
