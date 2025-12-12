//
//  CardboardBoxOpeningView.swift
//  Tapling
//
//  Created by Benno on 08.12.25.
//

import SwiftUI

struct CardboardBoxOpeningView: View {
    @Environment(\.dismiss) private var dismiss

    let initialRarity: Rarity
    let upgradeChances: UpgradeChances
    let onCollect: (AnyCollectible?) -> Void

    @State private var currentRarity: Rarity
    @State private var tapCount: Int = 0
    @State private var isAnimating: Bool = false
    @State private var wonCollectible: AnyCollectible?
    @State private var particlesTrigger: Int = 0
    @State private var glowIntensity: CGFloat = 0
    @State private var shakeOffset: CGFloat = 0
    @State private var handPokeOffset: CGFloat = 0
    @State private var handPokeOpacity: Double = 0
    @State private var handPokeRotation: Double = 0
    @State private var screenWidth: CGFloat?

    private let maxTaps = 4
    private let maxStars = 4
    private let starSpacing: CGFloat = 65.0
    private let starArchHeight: CGFloat = 40.0
    private let starSize: CGFloat = 36.0

    private let boxWidth: CGFloat = 180
    private var boxRightEdge: CGFloat {
        boxWidth / 2
    }

    private let handPokeWidth: CGFloat = 345
    private let handPokeHeight: CGFloat = 60
    private let handPokeRotationAngle: Double = -25
    private var handPokeIntoBox: CGFloat {
        -(boxWidth / 3)
    }

    struct UpgradeChances {
        let toRare: Double
        let toEpic: Double
        let toLegendary: Double

        static let `default` = UpgradeChances(
            toRare: GameConfig.upgradeChanceToRare,
            toEpic: GameConfig.upgradeChanceToEpic,
            toLegendary: GameConfig.upgradeChanceToLegendary
        )
    }

    init(
        initialRarity: Rarity = .common,
        upgradeChances: UpgradeChances = .default,
        onCollect: @escaping (AnyCollectible?) -> Void
    ) {
        self.initialRarity = initialRarity
        self.upgradeChances = upgradeChances
        self.onCollect = onCollect
        _currentRarity = State(initialValue: initialRarity)
    }

    private var starCount: Int {
        switch currentRarity {
        case .common: return 1
        case .rare: return 2
        case .epic: return 3
        case .legendary: return 4
        }
    }

    private var isComplete: Bool {
        tapCount >= maxTaps
    }

    private var shouldShowStars: Bool {
        !isComplete || (isComplete && wonCollectible == nil)
    }

    private var bloatScale: CGFloat {
        let progress = CGFloat(tapCount) / CGFloat(maxTaps)
        let baseInflation = 1.0 + (progress * 0.15)

        if tapCount == maxTaps {
            return baseInflation * 1.3
        }

        return baseInflation
    }

    private var boxRotation: Double {
        if tapCount == maxTaps {
            return 0
        }
        return isAnimating ? Double.random(in: -8...8) : 0
    }

    private var previewTapling: Tapling? {
        guard let collectible = wonCollectible else { return nil }
        return createTaplingFromCollectible(collectible)
    }

    // MARK: - UI

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundGlow

                VStack(spacing: 0) {
                    Spacer()

                    mainContentArea

                    if !isComplete {
                        progressSection
                            .transition(.opacity.combined(with: .scale))
                    }

                    Spacer()

                    if wonCollectible != nil {
                        resultSection
                            .transition(
                                .move(edge: .bottom).combined(with: .opacity)
                            )
                            .padding(.bottom, 40)
                            .padding(.top, 20)
                    }
                }
                .padding(.horizontal, 32)

                if shouldShowStars {
                    starsSection
                        .offset(y: -150)
                        .transition(.opacity.combined(with: .scale))
                }

                if particlesTrigger > 0 {
                    ParticleEmitterView(
                        color: currentRarity.color,
                        trigger: particlesTrigger
                    )
                }

                if !isComplete {
                    pokingHandView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                guard !isComplete else { return }
                handleTap()
            }
            .onAppear {
                screenWidth = geometry.size.width
            }
            .onChange(of: geometry.size.width) { _, newWidth in
                screenWidth = newWidth
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    private var backgroundGlow: some View {
        RadialGradient(
            colors: [
                currentRarity.color.opacity(glowIntensity * 0.3),
                Color.clear,
            ],
            center: .center,
            startRadius: 50,
            endRadius: 300
        )
        .animation(.easeInOut(duration: 0.6), value: glowIntensity)
    }

    private var mainContentArea: some View {
        ZStack {
            if isComplete, let tapling = previewTapling,
                let collectible = wonCollectible
            {
                wonItemSection(tapling: tapling, collectible: collectible)
                    .transition(
                        .asymmetric(
                            insertion: .scale(scale: 0.5).combined(
                                with: .opacity
                            ),
                            removal: .opacity
                        )
                    )
            } else {
                cardboardBoxSection
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(height: isComplete ? 360 : 300)
        .animation(
            .spring(response: 0.5, dampingFraction: 0.7),
            value: isComplete
        )
    }

    private var starsSection: some View {
        ZStack {
            ForEach(0..<maxStars, id: \.self) { index in
                if index < starCount {
                    starView(at: index)
                }
            }
        }
        .frame(width: 300, height: 120)
    }

    private func starView(at index: Int) -> some View {
        let centerOffset = CGFloat(starCount - 1) * starSpacing / 2.0
        let x = CGFloat(index) * starSpacing - centerOffset

        let normalizedPosition =
            starCount > 1
            ? CGFloat(index) / CGFloat(starCount - 1)
            : 0.5
        let archProgress = (normalizedPosition - 0.5) * 2.0

        var y = -(1.0 - archProgress * archProgress) * starArchHeight
        if starCount == 2 {
            y -= starArchHeight * 0.8
        }

        return Image(systemName: "star.fill")
            .foregroundStyle(
                LinearGradient(
                    colors: [Color.yellow, Color.orange],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .font(.system(size: starSize))
            .shadow(color: .yellow.opacity(0.8), radius: 10)
            .offset(x: x, y: y)
            .animation(
                .spring(response: 0.5, dampingFraction: 0.7),
                value: starCount
            )
            .modifier(PopInModifier(index: index, visibleCount: starCount))
    }

    private var cardboardBoxSection: some View {
        Image("cardboard-box")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: boxWidth)
            .scaleEffect(bloatScale)
            .rotationEffect(.degrees(boxRotation))
            .offset(x: shakeOffset)
            .shadow(
                color: currentRarity.color.opacity(0.4 + (glowIntensity * 0.4)),
                radius: 12 + (glowIntensity * 25),
                x: 0,
                y: 5
            )
            .animation(
                .spring(response: 0.5, dampingFraction: 0.6),
                value: bloatScale
            )
            .animation(
                .spring(response: 0.3, dampingFraction: 0.5),
                value: boxRotation
            )
    }

    private var pokingHandView: some View {
        Image("fur_white_poke")
            .resizable()
            .scaledToFit()
            .frame(width: handPokeWidth, height: handPokeHeight)
            .opacity(handPokeOpacity)
            .offset(x: handPokeOffset)
            .rotationEffect(.degrees(handPokeRotation))
            .blendMode(.normal)
    }

    private func wonItemSection(tapling: Tapling, collectible: AnyCollectible)
        -> some View
    {
        VStack(spacing: 24) {
            itemShowcase(tapling: tapling, collectible: collectible)
            itemInfo(collectible: collectible)
        }
    }

    private func itemShowcase(tapling: Tapling, collectible: AnyCollectible)
        -> some View
    {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            collectible.rarity.color.opacity(0.3),
                            collectible.rarity.color.opacity(0.1),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 240)

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            collectible.rarity.color,
                            collectible.rarity.color.opacity(0.5),
                            collectible.rarity.color,
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 4
                )
                .frame(height: 240)
                .shadow(
                    color: collectible.rarity.color.opacity(0.8),
                    radius: 15
                )

            TaplingView(tapling: tapling)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(32)
                .scaleEffect(1.1)
        }
        .padding(.horizontal, 24)
    }

    private func itemInfo(collectible: AnyCollectible) -> some View {
        VStack(spacing: 8) {
            Text(collectible.name)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            collectible.rarity.color,
                            collectible.rarity.color.opacity(0.7),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .multilineTextAlignment(.center)

            Text(collectible.rarity.rawValue.capitalized)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(collectible.rarity.color.opacity(0.8))
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(collectible.rarity.color.opacity(0.2))
                )
        }
    }

    private var progressSection: some View {
        HStack(spacing: 20) {
            ForEach(0..<maxTaps, id: \.self) { index in
                Circle()
                    .fill(
                        index < tapCount
                            ? currentRarity.color
                            : Color.gray.opacity(0.25)
                    )
                    .frame(width: 12, height: 12)
                    .shadow(
                        color: index < tapCount
                            ? currentRarity.color.opacity(0.6)
                            : .clear,
                        radius: 6
                    )
                    .scaleEffect(index < tapCount ? 1.3 : 1.0)
                    .animation(
                        .spring(response: 0.4, dampingFraction: 0.6)
                            .delay(Double(index) * 0.05),
                        value: tapCount
                    )
            }
        }
    }

    private var resultSection: some View {
        Button {
            onCollect(wonCollectible)
            dismiss()
        } label: {
            Text("Collect!")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [
                            currentRarity.color,
                            currentRarity.color.opacity(0.8),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: currentRarity.color.opacity(0.5), radius: 10)
        }
        .padding(.horizontal, 32)
    }

    // MARK: - Actions

    private func handleTap() {
        let impact = UIImpactFeedbackGenerator(
            style: tapCount == maxTaps - 1 ? .heavy : .medium
        )
        impact.impactOccurred()

        animateShake()
        animateHandPoke()
        isAnimating = true
        tapCount += 1

        withAnimation(.easeOut(duration: 0.3)) {
            glowIntensity = CGFloat(tapCount) / CGFloat(maxTaps)
        }

        if tapCount <= maxTaps {
            tryUpgradeRarity()
        }

        if isComplete {
            triggerCompletion()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isAnimating = false
            }
        }
    }

    private func animateHandPoke() {
        guard let screenWidth = screenWidth else { return }

        let offScreenStart = screenWidth / 2 + handPokeWidth / 2
        let leftTipTarget = boxRightEdge + handPokeIntoBox
        let pokePosition = leftTipTarget + handPokeWidth / 2

        handPokeOffset = offScreenStart
        handPokeOpacity = 0
        handPokeRotation = 0

        withAnimation(.easeOut(duration: 0.15)) {
            handPokeOffset = pokePosition
            handPokeRotation = handPokeRotationAngle
            handPokeOpacity = 0.7
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeIn(duration: 0.12)) {
                handPokeOffset = offScreenStart
                handPokeRotation = 0
                handPokeOpacity = 0
            }
        }
    }

    private func animateShake() {
        withAnimation(.spring(response: 0.2, dampingFraction: 0.3)) {
            shakeOffset = 10
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.3)) {
                shakeOffset = -10
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                shakeOffset = 0
            }
        }
    }

    private func triggerCompletion() {
        particlesTrigger += 1

        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            generateReward()
        }
    }

    private func tryUpgradeRarity() {
        guard currentRarity != .legendary else { return }

        let upgradeChance: Double
        switch currentRarity {
        case .common:
            upgradeChance = upgradeChances.toRare
        case .rare:
            upgradeChance = upgradeChances.toEpic
        case .epic:
            upgradeChance = upgradeChances.toLegendary
        case .legendary:
            return
        }

        if Double.random(in: 0...1) < upgradeChance {
            upgradeToNextRarity()
        }
    }

    private func upgradeToNextRarity() {
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()

        switch currentRarity {
        case .common:
            currentRarity = .rare
        case .rare:
            currentRarity = .epic
        case .epic:
            currentRarity = .legendary
        case .legendary:
            break
        }
    }

    private func generateReward() {
        let registry = CollectibleRegistry.shared
        let allCollectibles = registry.allCollectibles
        let collectiblesOfRarity = allCollectibles.filter {
            $0.rarity == currentRarity
        }
        wonCollectible =
            collectiblesOfRarity.isEmpty
            ? allCollectibles.randomElement()
            : collectiblesOfRarity.randomElement()
    }

    private func createTaplingFromCollectible(_ collectible: AnyCollectible)
        -> Tapling
    {
        switch collectible {
        case .hat(let hat):
            return Tapling(
                fur: .default,
                hat: hat,
                face: .default,
                leftHand: .down,
                rightHand: .down
            )
        case .face(let face):
            return Tapling(
                fur: .default,
                hat: nil,
                face: face,
                leftHand: .down,
                rightHand: .down
            )
        case .fur(let fur):
            return Tapling(
                fur: fur,
                hat: nil,
                face: .default,
                leftHand: .down,
                rightHand: .down
            )
        }
    }
}

struct PopInModifier: ViewModifier {
    let index: Int
    let visibleCount: Int

    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1.0 : 0.2)
            .onAppear {
                if index < visibleCount {
                    withAnimation(
                        .spring(response: 0.3, dampingFraction: 0.5)
                    ) {
                        isVisible = true
                    }
                }
            }
            .onChange(of: visibleCount) { oldCount, newCount in
                if index < newCount && index >= oldCount && !isVisible {
                    withAnimation(
                        .spring(response: 0.15, dampingFraction: 0.3)
                    ) {
                        isVisible = true
                    }
                }
            }
    }
}

struct ParticleEmitterView: View {
    let color: Color
    let trigger: Int

    @State private var particles: [Particle] = []

    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var scale: CGFloat
        var opacity: Double
    }

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                    .scaleEffect(particle.scale)
                    .opacity(particle.opacity)
                    .offset(x: particle.x, y: particle.y)
                    .blur(radius: 2)
            }
        }
        .onAppear {
            emitParticles()
        }
        .onChange(of: trigger) { _, _ in
            emitParticles()
        }
    }

    private func emitParticles() {
        particles.removeAll()

        for _ in 0..<30 {
            let angle = Double.random(in: 0...(2 * .pi))
            let distance = CGFloat.random(in: 100...200)
            let particle = Particle(
                x: cos(angle) * distance,
                y: sin(angle) * distance,
                scale: Double.random(in: 0.5...1.5),
                opacity: 1.0
            )
            particles.append(particle)
        }

        withAnimation(.easeOut(duration: 1.2)) {
            particles = particles.map { particle in
                var p = particle
                p.opacity = 0
                p.y += 100
                return p
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            particles.removeAll()
        }
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var resetKey = 0

    var body: some View {
        CardboardBoxOpeningView(
            initialRarity: .common,
            upgradeChances: CardboardBoxOpeningView.UpgradeChances(
                toRare: 1.0,
                toEpic: 1.0,
                toLegendary: 1.0
            ),
            onCollect: { _ in
                resetKey += 1
            }
        )
        .id(resetKey)
    }
}
