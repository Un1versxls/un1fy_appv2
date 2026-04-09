import Foundation
import SwiftUI

@MainActor
class MainDashboardViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedTask: DailyTask?
    @Published var showTaskDetail = false
    @Published var isLoading = false
    
    // MARK: - Dependencies
    private let appState: AppState
    
    // MARK: - Initialization
    init(appState: AppState) {
        self.appState = appState
    }
    
    // MARK: - Public Methods
    func selectTask(_ task: DailyTask) {
        selectedTask = task
        showTaskDetail = true
    }
    
    func completeSelectedTask() {
        guard let task = selectedTask else { return }
        appState.completeTask(task)
        selectedTask = nil
        showTaskDetail = false
    }
    
    func skipSelectedTask() {
        guard let task = selectedTask else { return }
        appState.skipTask(task)
        selectedTask = nil
        showTaskDetail = false
    }
    
    func generateTodayTasks() {
        appState.generateDailyTasks()
    }
    
    var todayTasks: [DailyTask] {
        appState.todayTasks
    }
    
    var pendingTasks: [DailyTask] {
        appState.pendingTasks
    }
    
    var completedTasks: [DailyTask] {
        appState.completedTasks
    }
    
    var selectedTab: Int {
        get { appState.selectedTab }
        set { appState.selectedTab = newValue }
    }
}