import SwiftUI

struct OnboardingFlowView: View {
    @StateObject private var viewModel: OnboardingViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(appState: AppState.shared))
    }
    
    var body: some View {
        ZStack {
            Color.driveBackground
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ZStack {
                    ForEach(Array(OnboardingStep.allCases), id: \.self) { step in
                        if viewModel.shouldShow(step: step) {
                            screenFor(step: step)
                                .transition(.asymmetric(
                                    insertion: .move(edge: viewModel.animateTransition ? .trailing : .leading),
                                    removal: .move(edge: .leading)
                                ))
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .animation(DriveAnimations.standard, value: viewModel.currentStep)
    }
    
    @ViewBuilder
    private func screenFor(step: OnboardingStep) -> some View {
        switch step {
        case .welcome:
            WelcomeView(onNext: viewModel.nextStep)
        case .goalQuestion1:
            GoalQuestionsView(
                questionNumber: 1,
                totalQuestions: 4,
                question: "What's your primary goal?",
                options: ["Earn extra income", "Build skills", "Grow my business", "Stay productive"],
                selectedOption: $viewModel.onboardingData.primaryGoal,
                onNext: viewModel.nextStep,
                onBack: viewModel.previousStep
            )
        case .goalQuestion2:
            GoalQuestionsView(
                questionNumber: 2,
                totalQuestions: 4,
                question: "What's your experience level?",
                options: ["Beginner", "Intermediate", "Advanced", "Expert"],
                selectedOption: $viewModel.onboardingData.experienceLevel,
                onNext: viewModel.nextStep,
                onBack: viewModel.previousStep
            )
        case .goalQuestion3:
            GoalQuestionsView(
                questionNumber: 3,
                totalQuestions: 4,
                question: "How much time can you commit daily?",
                options: ["15 minutes", "30 minutes", "1 hour", "2+ hours"],
                selectedOption: $viewModel.onboardingData.timeAvailability,
                onNext: viewModel.nextStep,
                onBack: viewModel.previousStep
            )
        case .goalQuestion4:
            GoalQuestionsView(
                questionNumber: 4,
                totalQuestions: 4,
                question: "What matters most to you?",
                options: ["Flexibility", "Earning potential", "Learning opportunities", "Speed to results"],
                selectedOption: Binding(
                    get: { viewModel.onboardingData.primaryGoal },
                    set: { viewModel.onboardingData.primaryGoal = $0 }
                ),
                onNext: viewModel.nextStep,
                onBack: viewModel.previousStep
            )
        case .planSelection:
            PlanSelectionView(
                selectedPlan: $viewModel.onboardingData.selectedPlan,
                onNext: viewModel.nextStep,
                onBack: viewModel.previousStep
            )
        case .completion:
            OnboardingCompletionView(
                data: viewModel.onboardingData,
                onComplete: viewModel.completeOnboarding
            )
        }
    }
}

#Preview {
    OnboardingFlowView()
}
