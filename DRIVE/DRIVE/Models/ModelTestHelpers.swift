//
//  ModelTestHelpers.swift
//  DRIVE
//
//  Created by Kilo on 07/04/2026.
//

import Foundation

// MARK: - Testable Protocol

protocol Testable {
    static var testInstance: Self { get }
    static var testCollection: [Self] { get }
}

extension Niche: Testable {
    static var testInstance: Niche { .sampleList.first! }
    static var testCollection: [Niche] { .sampleList }
}

extension UserProfile: Testable {
    static var testInstance: UserProfile {
        UserProfile(
            xp: 540,
            streakCount: 12,
            level: 3,
            selectedNiche: .testInstance,
            dailyGoalMinutes: 45
        )
    }
    
    static var testCollection: [UserProfile] {
        [testInstance, .default, UserProfile(streakCount: 30, level: 7)]
    }
}

extension DailyTask: Testable {
    static var testInstance: DailyTask {
        DailyTask(
            title: "Test Task",
            description: "Task for testing purposes",
            targetDate: Date(),
            xpReward: 25
        )
    }
    
    static var testCollection: [DailyTask] {
        generateForDate(Date(), count: 5)
    }
}

extension AppPlan: Testable {
    static var testInstance: AppPlan { .pro }
    static var testCollection: [AppPlan] { [.free, .pro] }
}

extension AppState: Testable {
    static var testInstance: AppState {
        AppState(
            hasCompletedOnboarding: true,
            isFirstLaunch: false
        )
    }
    
    static var testCollection: [AppState] { [testInstance, .default] }
}
