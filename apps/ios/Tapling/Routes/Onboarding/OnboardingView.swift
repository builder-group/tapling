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
    @State private var currentStep = 0

    private enum OnboardingStep: Int, CaseIterable {
        case welcome = 0
        case enableKeyboard = 1
        case selectKeyboard = 2
        case fullAccess = 3
        case cardbox = 4
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
                OnboardingCardboxView(onNext: completeOnboarding)
            case .none:
                EmptyView()
            }
        }
    }

    // MARK: - Actions

    private func nextStep() {
        withAnimation {
            currentStep += 1
        }
    }

    private func completeOnboarding() {
        player.onboardingCompletedAt = Date()
        try? modelContext.save()
    }
}

#Preview {
    OnboardingView()
        .previewDataContainer()
}
