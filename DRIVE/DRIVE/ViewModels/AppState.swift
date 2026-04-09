import Foundation
import SwiftUI

final class AppState: ObservableObject, Codable {
    @Published var hasCompletedOnboarding: Bool
    @Published var lastOpenedVersion: String?
    @Published var dataVersion: Int
    @Published var lastSyncDate: Date?
    @Published var isFirstLaunch: Bool
    
    // Core user data
    @Published var currentUser: UserProfile
    @Published var currentPlan: AppPlan
    @Published var dailyTasks: [DailyTask]
    @Published var availableNiches: [Niche]
    
    // UI state (transient)
    @Published var selectedTab: Int
    
    // Shared instance for previews and compatibility
    static var shared: AppState = AppState()
    
    private enum CodingKeys: String, CodingKey {
        case hasCompletedOnboarding, lastOpenedVersion, dataVersion, lastSyncDate, isFirstLaunch
        case currentUser, currentPlan, dailyTasks, availableNiches
    }
    
    init(
        hasCompletedOnboarding: Bool = false,
        lastOpenedVersion: String? = nil,
        dataVersion: Int = 1,
        lastSyncDate: Date? = nil,
        isFirstLaunch: Bool = true,
        currentUser: UserProfile = .default,
        currentPlan: AppPlan = .free,
        dailyTasks: [DailyTask] = [],
        availableNiches: [Niche] = Niche.allNiches,
        selectedTab: Int = 0
    ) {
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.lastOpenedVersion = lastOpenedVersion
        self.dataVersion = dataVersion
        self.lastSyncDate = lastSyncDate
        self.isFirstLaunch = isFirstLaunch
        self.currentUser = currentUser
        self.currentPlan = currentPlan
        self.dailyTasks = dailyTasks
        self.availableNiches = availableNiches
        self.selectedTab = selectedTab
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasCompletedOnboarding = try container.decodeIfPresent(Bool.self, forKey: .hasCompletedOnboarding) ?? false
        lastOpenedVersion = try container.decodeIfPresent(String.self, forKey: .lastOpenedVersion)
        dataVersion = try container.decodeIfPresent(Int.self, forKey: .dataVersion) ?? 1
        lastSyncDate = try container.decodeIfPresent(Date.self, forKey: .lastSyncDate)
        isFirstLaunch = try container.decodeIfPresent(Bool.self, forKey: .isFirstLaunch) ?? true
        currentUser = (try? container.decodeIfPresent(UserProfile.self, forKey: .currentUser)) ?? .default
        currentPlan = (try? container.decodeIfPresent(AppPlan.self, forKey: .currentPlan)) ?? .free
        dailyTasks = (try? container.decodeIfPresent([DailyTask].self, forKey: .dailyTasks)) ?? []
        availableNiches = (try? container.decodeIfPresent([Niche].self, forKey: .availableNiches)) ?? Niche.allNiches
        selectedTab = 0
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hasCompletedOnboarding, forKey: .hasCompletedOnboarding)
        try container.encodeIfPresent(lastOpenedVersion, forKey: .lastOpenedVersion)
        try container.encode(dataVersion, forKey: .dataVersion)
        try container.encodeIfPresent(lastSyncDate, forKey: .lastSyncDate)
        try container.encode(isFirstLaunch, forKey: .isFirstLaunch)
        try container.encode(currentUser, forKey: .currentUser)
        try container.encode(currentPlan, forKey: .currentPlan)
        try container.encode(dailyTasks, forKey: .dailyTasks)
        try container.encode(availableNiches, forKey: .availableNiches)
    }
    
    var todayTasks: [DailyTask] {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        return dailyTasks.filter { calendar.isDate($0.targetDate, inSameDayAs: startOfToday) }
    }
    
    var pendingTasks: [DailyTask] {
        todayTasks.filter { $0.status == .pending }
    }
    
    var completedTasks: [DailyTask] {
        todayTasks.filter { $0.status == .completed }
    }
    
    func upgradePlan(to tier: PlanTier) {
        if let plan = AppPlan.allPlans.first(where: { $0.tier == tier }) {
            currentPlan = plan
            currentUser.currentPlan = tier
            save()
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        save()
    }
    
    func selectNiches(_ niches: [Niche]) {
        currentUser.selectedNiches = niches
        save()
    }
    
    func updateProfileName(_ name: String) {
        currentUser.name = name
        save()
    }
    
    func resetProgress() {
        currentUser = .default
        dailyTasks.removeAll()
        hasCompletedOnboarding = false
        save()
    }
    
    func completeTask(_ task: DailyTask) {
        if let index = dailyTasks.firstIndex(where: { $0.id == task.id }) {
            dailyTasks[index].status = .completed
            dailyTasks[index].completedDate = Date()
            currentUser.xp += dailyTasks[index].xpReward
            currentUser.totalTasksCompleted += 1
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            if let lastActive = currentUser.lastActiveDate, !calendar.isDate(lastActive, inSameDayAs: today) {
                currentUser.streakCount += 1
            }
            currentUser.lastActiveDate = Date()
            save()
        }
    }
    
    func skipTask(_ task: DailyTask) {
        if let index = dailyTasks.firstIndex(where: { $0.id == task.id }) {
            dailyTasks[index].status = .skipped
            save()
        }
    }
    
    func generateDailyTasks() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let existingToday = todayTasks
        if existingToday.isEmpty {
            let newTasks = DailyTask.generateForDate(today, count: 3)
            dailyTasks.append(contentsOf: newTasks)
            save()
        }
    }
    
    private func save() {
        StorageManager.shared.saveAppState(self)
    }
}
