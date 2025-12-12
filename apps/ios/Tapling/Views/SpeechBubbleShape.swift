//
//  SpeechBubbleShape.swift
//  Tapling
//
//  Created by Benno on 11.12.25.
//
// Based on: https://stackoverflow.com/questions/68883032/swiftui-how-to-combine-two-shapes-to-create-a-speech-bubble-with-strokes

import SwiftUI

struct SpeechBubble: Shape {
    enum TailPosition {
        case left
        case right
        case top
        case bottom
    }

    private let radius: CGFloat
    private let tailSize: CGFloat
    private let tailPosition: TailPosition

    init(radius: CGFloat = 10, tailPosition: TailPosition = .left) {
        self.radius = radius
        self.tailSize = 20
        self.tailPosition = tailPosition
    }

    func path(in rect: CGRect) -> Path {
        switch tailPosition {
        case .left:
            return leftTailPath(in: rect)
        case .right:
            return rightTailPath(in: rect)
        case .top:
            return topTailPath(in: rect)
        case .bottom:
            return bottomTailPath(in: rect)
        }
    }

    private func leftTailPath(in rect: CGRect) -> Path {
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

    private func rightTailPath(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY + radius))
            path.addLine(
                to: CGPoint(x: rect.maxX, y: rect.minY + rect.height / 2)
            )
            path.addCurve(
                to: CGPoint(
                    x: rect.maxX,
                    y: rect.minY + rect.height / 2 + tailSize
                ),
                control1: CGPoint(
                    x: rect.maxX + tailSize,
                    y: rect.minY + rect.height / 2
                ),
                control2: CGPoint(
                    x: rect.maxX,
                    y: rect.minY + rect.height / 2 + tailSize / 2
                )
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
        }
    }

    private func topTailPath(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
            path.addLine(
                to: CGPoint(x: rect.minX + rect.width / 2, y: rect.minY)
            )
            path.addCurve(
                to: CGPoint(
                    x: rect.minX + rect.width / 2 - tailSize,
                    y: rect.minY
                ),
                control1: CGPoint(
                    x: rect.minX + rect.width / 2,
                    y: rect.minY - tailSize
                ),
                control2: CGPoint(
                    x: rect.minX + rect.width / 2 - tailSize / 2,
                    y: rect.minY
                )
            )
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                radius: radius,
                startAngle: Angle(degrees: 270),
                endAngle: Angle(degrees: 180),
                clockwise: true
            )
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 90),
                clockwise: true
            )
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: Angle(degrees: 90),
                endAngle: Angle(degrees: 0),
                clockwise: true
            )
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                radius: radius,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 270),
                clockwise: true
            )
        }
    }

    private func bottomTailPath(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
            path.addLine(
                to: CGPoint(x: rect.minX + rect.width / 2, y: rect.maxY)
            )
            path.addCurve(
                to: CGPoint(
                    x: rect.minX + rect.width / 2 + tailSize,
                    y: rect.maxY
                ),
                control1: CGPoint(
                    x: rect.minX + rect.width / 2,
                    y: rect.maxY + tailSize
                ),
                control2: CGPoint(
                    x: rect.minX + rect.width / 2 + tailSize / 2,
                    y: rect.maxY
                )
            )
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: Angle(degrees: 90),
                endAngle: Angle(degrees: 0),
                clockwise: true
            )
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                radius: radius,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 270),
                clockwise: true
            )
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                radius: radius,
                startAngle: Angle(degrees: 270),
                endAngle: Angle(degrees: 180),
                clockwise: true
            )
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 90),
                clockwise: true
            )
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        SpeechBubble(tailPosition: .left)
            .stroke(Color.gray, lineWidth: 3)
            .frame(width: 100, height: 80)

        SpeechBubble(tailPosition: .right)
            .stroke(Color.gray, lineWidth: 3)
            .frame(width: 200, height: 80)

        SpeechBubble(tailPosition: .top)
            .stroke(Color.gray, lineWidth: 3)
            .frame(width: 300, height: 80)

        SpeechBubble(tailPosition: .bottom)
            .stroke(Color.gray, lineWidth: 3)
            .frame(width: 70, height: 40)
    }
    .padding()
}
