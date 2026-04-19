import Foundation

struct OnboardingData: Codable, Equatable {
    var primaryGoal: String
    var experienceLevel: String
    var timeAvailability: String
    var selectedPlan: PlanTier
    
    init(
        primaryGoal: String = "",
        experienceLevel: String = "",
        timeAvailability: String = "",
        selectedPlan: PlanTier = .free
    ) {
        self.primaryGoal = primaryGoal
        self.experienceLevel = experienceLevel
        self.timeAvailability = timeAvailability
        self.selectedPlan = selectedPlan
    }
}