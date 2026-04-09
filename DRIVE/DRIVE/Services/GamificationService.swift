import Foundation

enum GamificationService {
    static func calculatePoints(basePoints: Int, multiplier: Double) -> Int {
        return Int(Double(basePoints) * multiplier)
    }
    
    static func generateDailyGoal() -> DailyGoal {
        let tasks = Int.random(in: 3...5)
        let points = tasks * Int.random(in: 15...25)
        return DailyGoal(
            targetTasks: tasks,
            targetPoints: points,
            bonusPoints: Int.random(in: 10...30)
        )
    }
    
    static func generateWeeklyGoal(stats: UserStats) -> WeeklyGoal {
        let targetTasks = stats.totalTasksCompleted + Int.random(in: 15...25)
        let targetPoints = stats.totalPoints + Int.random(in: 200...500)
        return WeeklyGoal(
            targetTasks: targetTasks,
            targetPoints: targetPoints,
            bonusMultiplier: 1.5
        )
    }
    
    static func checkAchievements(stats: UserStats) -> [Achievement] {
        var achievements: [Achievement] = []
        
        if stats.currentStreak >= 7 {
            achievements.append(Achievement(
                id: UUID(),
                name: "Week Warrior",
                icon: "calendar.badge.fire",
                description: "Maintain a 7-day streak"
            ))
        }
        
        if stats.currentStreak >= 30 {
            achievements.append(Achievement(
                id: UUID(),
                name: "Unstoppable",
                icon: "sparkles",
                description: "Maintain a 30-day streak"
            ))
        }
        
        if stats.totalTasksCompleted >= 100 {
            achievements.append(Achievement(
                id: UUID(),
                name: "Centurion",
                icon: "crown.fill",
                description: "Complete 100 tasks"
            ))
        }
        
        return achievements
    }
    
    static func getStreakMilestone(_ streak: Int) -> StreakMilestone? {
        switch streak {
        case 7: return StreakMilestone.weeks
        case 14: return StreakMilestone.twoWeeks
        case 21: return StreakMilestone.threeWeeks
        case 30: return StreakMilestone.month
        case 60: return StreakMilestone.twoMonths
        case 90: return StreakMilestone.quarter
        case 180: return StreakMilestone.halfYear
        case 365: return StreakMilestone.year
        default: return nil
        }
    }
}

struct DailyGoal: Codable {
    let targetTasks: Int
    let targetPoints: Int
    let bonusPoints: Int
    
    var progress: Double {
        return 0.0
    }
}

struct WeeklyGoal: Codable {
    let targetTasks: Int
    let targetPoints: Int
    let bonusMultiplier: Double
}

struct Achievement: Identifiable, Codable {
    let id: UUID
    let name: String
    let icon: String
    let description: String
}

enum StreakMilestone: String {
    case weeks = "1 Week Champion"
    case twoWeeks = "2 Week Champion"
    case threeWeeks = "3 Week Champion"
    case month = "Monthly Master"
    case twoMonths = "2 Month Master"
    case quarter = "Quarterly Champion"
    case halfYear = "Half Year Hero"
    case year = "Year Legend"
}