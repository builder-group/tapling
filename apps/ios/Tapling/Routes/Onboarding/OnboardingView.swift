//
//  OnboardingView.swift
//  Tapling
//
//  Created by Benno on 10.12.25.
//

import SwiftData
import SwiftUI

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @QuerySingleton private var player: Player

    let isCancelable: Bool
    let onComplete: (() -> Void)?

    init(isCancelable: Bool = false, onComplete: (() -> Void)? = nil) {
        self.isCancelable = isCancelable
        self.onComplete = onComplete
    }

    private enum OnboardingStep: Int, CaseIterable {
        case welcome = 0
        case enableKeyboard = 1
        case selectKeyboard = 2
        case fullAccess = 3
        case cardbox = 4
    }

    private var currentStep: Int {
        player.onboardingStep ?? 0
    }

    // MARK: - UI

    var body: some View {
        Group {
            switch OnboardingStep(rawValue: currentStep) {
            case .welcome:
                OnboardingWelcomeView(onNext: nextStep)
            case .enableKeyboard:
                OnboardingEnableKeyboardView(onNext: nextStep)
            case .selectKeyboard:
                OnboardingSelectKeyboardView(onNext: nextStep)
            case .fullAccess:
                OnboardingFullAccessView(onNext: nextStep)
            case .cardbox:
                OnboardingCardboxView(
                    isCancelable: isCancelable,
                    onNext: completeOnboarding
                )
            case .none:
                EmptyView()
            }
        }
        .onAppear {
            if player.onboardingStep == nil {
                player.onboardingStep = 0
                try? modelContext.save()
            }
        }
    }

    // MARK: - Actions

    private func nextStep() {
        withAnimation {
            player.onboardingStep = (player.onboardingStep ?? 0) + 1
            try? modelContext.save()
        }
    }

    private func completeOnboarding() {
        if !isCancelable {
            player.onboardingCompletedAt = Date()
        }
        player.onboardingStep = nil
        try? modelContext.save()

        onComplete?()
    }
}

#Preview {
    OnboardingView()
        .previewDataContainer()
}
