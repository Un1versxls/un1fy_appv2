import Foundation

struct OnboardingData: Codable, Equatable {
    var primaryGoal: String = ""
    var experienceLevel: String = ""
    var timeAvailability: String = ""
    var selectedNiche: String = ""
    var selectedPlan: PlanTier = .free
    
    static var empty: OnboardingData {
        OnboardingData()
    }
}