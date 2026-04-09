import Foundation

struct UserProfile: Codable, Identifiable, Equatable {
    let id: UUID
    var xp: Int
    var streakCount: Int
    var level: Int
    var selectedNiches: [Niche]
    var dailyGoalMinutes: Int
    var joinDate: Date
    var lastActiveDate: Date?
    var name: String
    var totalTasksCompleted: Int
    var currentPlan: PlanTier
    var settings: UserSettings
    var badges: [Badge]
    
    init(
        id: UUID = UUID(),
        xp: Int = 0,
        streakCount: Int = 0,
        level: Int = 1,
        selectedNiches: [Niche] = [],
        dailyGoalMinutes: Int = 30,
        joinDate: Date = Date(),
        lastActiveDate: Date? = nil,
        name: String = "User",
        totalTasksCompleted: Int = 0,
        currentPlan: PlanTier = .free,
        settings: UserSettings = UserSettings(),
        badges: [Badge] = []
    ) {
        self.id = id
        self.xp = xp
        self.streakCount = streakCount
        self.level = level
        self.selectedNiches = selectedNiches
        self.dailyGoalMinutes = dailyGoalMinutes
        self.joinDate = joinDate
        self.lastActiveDate = lastActiveDate
        self.name = name
        self.totalTasksCompleted = totalTasksCompleted
        self.currentPlan = currentPlan
        self.settings = settings
        self.badges = badges
    }
    
    var xpForNextLevel: Int { level * 1000 }
    var currentLevelProgress: Double { Double(xp) / Double(xpForNextLevel) }
    
    var displayName: String { name }
    
    var selectedNicheIds: [UUID] {
        selectedNiches.map { $0.id }
    }
    
    var stats: UserStats {
        UserStats(
            currentStreak: streakCount,
            longestStreak: streakCount,
            totalPoints: xp,
            totalTasksCompleted: totalTasksCompleted,
            level: level,
            xp: xp,
            badges: badges
        )
    }
    
    mutating func addXP(_ amount: Int) {
        xp += amount
        while xp >= xpForNextLevel {
            xp -= xpForNextLevel
            level += 1
        }
    }
    
    static let `default` = UserProfile()
    
    enum CodingKeys: String, CodingKey {
        case id, xp, streakCount, level, selectedNiches, dailyGoalMinutes, joinDate, lastActiveDate
        case name, totalTasksCompleted, currentPlan, settings, badges
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        xp = try container.decodeIfPresent(Int.self, forKey: .xp) ?? 0
        streakCount = try container.decodeIfPresent(Int.self, forKey: .streakCount) ?? 0
        level = try container.decodeIfPresent(Int.self, forKey: .level) ?? 1
        selectedNiches = try container.decodeIfPresent([Niche].self, forKey: .selectedNiches) ?? []
        dailyGoalMinutes = try container.decodeIfPresent(Int.self, forKey: .dailyGoalMinutes) ?? 30
        joinDate = try container.decodeIfPresent(Date.self, forKey: .joinDate) ?? Date()
        lastActiveDate = try container.decodeIfPresent(Date.self, forKey: .lastActiveDate)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "User"
        totalTasksCompleted = try container.decodeIfPresent(Int.self, forKey: .totalTasksCompleted) ?? 0
        let planString = try container.decodeIfPresent(String.self, forKey: .currentPlan)
        currentPlan = planString.flatMap { PlanTier(rawValue: $0) } ?? .free
        settings = (try? container.decodeIfPresent(UserSettings.self, forKey: .settings)) ?? UserSettings()
        badges = try container.decodeIfPresent([Badge].self, forKey: .badges) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(xp, forKey: .xp)
        try container.encode(streakCount, forKey: .streakCount)
        try container.encode(level, forKey: .level)
        try container.encode(selectedNiches, forKey: .selectedNiches)
        try container.encode(dailyGoalMinutes, forKey: .dailyGoalMinutes)
        try container.encode(joinDate, forKey: .joinDate)
        try container.encodeIfPresent(lastActiveDate, forKey: .lastActiveDate)
        try container.encode(name, forKey: .name)
        try container.encode(totalTasksCompleted, forKey: .totalTasksCompleted)
        try container.encode(currentPlan.rawValue, forKey: .currentPlan)
        try container.encode(settings, forKey: .settings)
        try container.encode(badges, forKey: .badges)
    }
}