//
//  HeartRisingView.swift
//  Tapling
//
//  Created by Benno on 05.12.25.
//

import SwiftUI

struct HeartRisingView: View {
    let spawnSize: CGSize
    let targetSize: CGSize
    let curveAmplitude: CGFloat
    let riseDistance: CGFloat
    let riseDuration: Double
    let spawnInterval: ClosedRange<Double>
    let maxHearts: Int
    let heartSize: CGFloat
    let debug: Bool

    @State private var hearts: [HeartData] = []
    @State private var nextId = 0

    init(
        spawnSize: CGSize = CGSize(width: 40, height: 40),
        targetSize: CGSize = CGSize(width: 20, height: 20),
        curveAmplitude: CGFloat = 30,
        riseDistance: CGFloat = 150,
        riseDuration: Double = 4.0,
        spawnInterval: ClosedRange<Double> = 1.0...2.0,
        maxHearts: Int = 5,
        heartSize: CGFloat = 14,
        debug: Bool = false
    ) {
        self.spawnSize = spawnSize
        self.targetSize = targetSize
        self.curveAmplitude = curveAmplitude
        self.riseDistance = riseDistance
        self.riseDuration = riseDuration
        self.spawnInterval = spawnInterval
        self.maxHearts = maxHearts
        self.heartSize = heartSize
        self.debug = debug
    }

    // MARK: - UI

    var body: some View {
        ZStack {
            if debug {
                debugOverlay
            }

            ForEach(hearts) { heart in
                RisingHeartView(
                    spawnOffset: heart.spawnOffset,
                    targetOffset: heart.targetOffset,
                    curveDirection: heart.curveDirection,
                    curveAmplitude: curveAmplitude,
                    riseDistance: riseDistance,
                    riseDuration: riseDuration,
                    heartSize: heartSize
                )
            }
        }
        .onAppear(perform: startSpawning)
    }

    private var debugOverlay: some View {
        ZStack {
            targetEllipse
            spawnEllipse
            curvePath
        }
    }

    private var targetEllipse: some View {
        Ellipse()
            .stroke(.purple, lineWidth: 2)
            .frame(width: targetSize.width, height: targetSize.height)
            .offset(y: -riseDistance)
    }

    private var spawnEllipse: some View {
        Ellipse()
            .stroke(.blue, lineWidth: 2)
            .frame(width: spawnSize.width, height: spawnSize.height)
    }

    private var curvePath: some View {
        CurvePathShape(
            curveAmplitude: curveAmplitude,
            riseDistance: riseDistance
        )
        .stroke(.green, style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
    }

    // MARK: - Actions

    private func startSpawning() {
        scheduleNextSpawn()
    }

    private func scheduleNextSpawn() {
        let delay = Double.random(in: spawnInterval)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            spawnHeart()
            scheduleNextSpawn()
        }
    }

    private func spawnHeart() {
        if hearts.count >= maxHearts {
            hearts.removeFirst()
        }

        let spawnOffset = randomPointInEllipse(
            width: spawnSize.width,
            height: spawnSize.height
        )
        let targetOffset = randomPointInEllipse(
            width: targetSize.width,
            height: targetSize.height
        )

        let heart = HeartData(
            id: nextId,
            spawnOffset: spawnOffset,
            targetOffset: targetOffset,
            curveDirection: Bool.random() ? 1.0 : -1.0
        )
        nextId += 1
        hearts.append(heart)

        removeHeartAfterAnimation(heartId: heart.id)
    }

    private func removeHeartAfterAnimation(heartId: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + riseDuration) {
            hearts.removeAll { $0.id == heartId }
        }
    }

    private func randomPointInEllipse(width: CGFloat, height: CGFloat)
        -> CGPoint
    {
        let a = width / 2
        let b = height / 2

        var x: CGFloat
        var y: CGFloat
        repeat {
            x = CGFloat.random(in: -a...a)
            y = CGFloat.random(in: -b...b)
        } while (x * x) / (a * a) + (y * y) / (b * b) > 1.0

        return CGPoint(x: x, y: y)
    }
}

// MARK: - Heart Data

private struct HeartData: Identifiable {
    let id: Int
    let spawnOffset: CGPoint
    let targetOffset: CGPoint
    let curveDirection: Double
}

// MARK: - Rising Heart View

private struct RisingHeartView: View {
    let spawnOffset: CGPoint
    let targetOffset: CGPoint
    let curveDirection: Double
    let curveAmplitude: CGFloat
    let riseDistance: CGFloat
    let riseDuration: Double
    let heartSize: CGFloat

    @State private var progress: Double = 0

    // MARK: - UI

    var body: some View {
        ZStack {
            heartGlow
            heart
        }
        .scaleEffect(0.5 + progress * 0.5)
        .opacity(1.0 - pow(progress, 2))
        .offset(x: currentOffset.x, y: currentOffset.y)
        .onAppear(perform: startAnimation)
    }

    private var heartGlow: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: heartSize * 1.3))
            .foregroundStyle(.pink.opacity(0.4))
            .blur(radius: 2)
    }

    private var heart: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: heartSize))
            .foregroundStyle(.red)
    }

    private var currentOffset: CGPoint {
        let baseX = spawnOffset.x * (1 - progress) + targetOffset.x * progress
        let baseY = spawnOffset.y * (1 - progress) + targetOffset.y * progress
        let curveX = sin(progress * .pi) * curveAmplitude * curveDirection
        let x = baseX + curveX
        let y = baseY - riseDistance * progress
        return CGPoint(x: x, y: y)
    }

    // MARK: - Actions

    private func startAnimation() {
        withAnimation(.easeOut(duration: riseDuration)) {
            progress = 1.0
        }
    }
}

// MARK: - Curve Path Shape

private struct CurvePathShape: Shape {
    let curveAmplitude: CGFloat
    let riseDistance: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let steps = 50
        let centerX = rect.midX
        let startY = rect.midY
        let endY = rect.midY - riseDistance
        let curveDirection: Double = 1.0

        for i in 0...steps {
            let progress = Double(i) / Double(steps)
            let y = startY + (endY - startY) * CGFloat(progress)
            let x =
                centerX + sin(progress * .pi) * curveAmplitude * curveDirection

            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path
    }
}

#Preview {
    VStack(spacing: 40) {
        HeartRisingView(
            spawnSize: CGSize(width: 20, height: 15),
            targetSize: CGSize(width: 60, height: 40),
            curveAmplitude: 40,
            riseDistance: 120,
            riseDuration: 3.0,
            spawnInterval: 0.8...1.5,
            maxHearts: 5,
            heartSize: 14,
            debug: true
        )
        .frame(height: 200)

        HeartRisingView(
            spawnSize: CGSize(width: 15, height: 12),
            targetSize: CGSize(width: 50, height: 35),
            curveAmplitude: 25,
            riseDistance: 100,
            riseDuration: 2.5,
            spawnInterval: 0.5...1.0,
            maxHearts: 8,
            heartSize: 12
        )
        .frame(height: 150)
    }
    .padding()
}
