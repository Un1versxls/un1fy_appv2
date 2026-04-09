import Foundation
import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentStep: OnboardingStep = .welcome
    @Published var onboardingData = OnboardingData()
    @Published var animateTransition = false
    @Published var isLoading = false
    
    // MARK: - Dependencies
    private let appState: AppState
    
    // MARK: - Initialization
    init(appState: AppState) {
        self.appState = appState
    }
    
    // MARK: - Public Methods
    func nextStep() {
        withAnimation(DriveAnimations.standard) {
            animateTransition = true
            if let nextStep = OnboardingStep(rawValue: currentStep.rawValue + 1) {
                currentStep = nextStep
            }
        }
    }
    
    func previousStep() {
        withAnimation(DriveAnimations.standard) {
            animateTransition = false
            if let prevStep = OnboardingStep(rawValue: currentStep.rawValue - 1) {
                currentStep = prevStep
            }
        }
    }
    
    func completeOnboarding() {
        isLoading = true
        // Simulate some async work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.appState.upgradePlan(to: self.onboardingData.selectedPlan)
            self.appState.completeOnboarding()
            self.isLoading = false
        }
    }
    
    // MARK: - Helper Methods
    func shouldShow(step: OnboardingStep) -> Bool {
        return step.rawValue <= currentStep.rawValue
    }
    
    var progress: Double {
        Double(currentStep.rawValue) / Double(OnboardingStep.allCases.count - 1)
    }
    
    var currentQuestion: Int {
        switch currentStep {
        case .goalQuestion1: return 1
        case .goalQuestion2: return 2
        case .goalQuestion3: return 3
        case .goalQuestion4: return 4
        default: return 0
        }
    }
    
    var totalQuestions: Int { 4 }
}