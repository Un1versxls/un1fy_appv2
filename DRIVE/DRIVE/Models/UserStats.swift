import Foundation

struct UserStats: Codable, Equatable {
    var currentStreak: Int
    var longestStreak: Int
    var totalPoints: Int
    var totalTasksCompleted: Int
    var level: Int
    var xp: Int
    var badges: [Badge]
    
    init(
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        totalPoints: Int = 0,
        totalTasksCompleted: Int = 0,
        level: Int = 1,
        xp: Int = 0,
        badges: [Badge] = []
    ) {
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.totalPoints = totalPoints
        self.totalTasksCompleted = totalTasksCompleted
        self.level = level
        self.xp = xp
        self.badges = badges
    }
    
    var xpToNextLevel: Int { level * 1000 }
    
    var progressToNextLevel: Double {
        guard xpToNextLevel > 0 else { return 0 }
        return min(Double(xp) / Double(xpToNextLevel), 1.0)
    }
    
    var levelTitle: String {
        switch level {
        case 1...5: return "Beginner"
        case 6...15: return "Intermediate"
        case 16...30: return "Advanced"
        default: return "Master"
        }
    }
}
