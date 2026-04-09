import Foundation
import SwiftUI

@MainActor
class TaskViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedTask: DailyTask?
    @Published var showTaskDetail = false
    @Published var isTimerRunning = false
    @Published var timerSeconds: Int = 0
    @Published var showSkipConfirmation = false
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
        // Reset timer when selecting a new task
        timerSeconds = 0
        isTimerRunning = false
    }
    
    func completeSelectedTask() {
        guard let task = selectedTask else { return }
        appState.completeTask(task)
        selectedTask = nil
        showTaskDetail = false
        resetTimer()
    }
    
    func skipSelectedTask() {
        guard let task = selectedTask else { return }
        appState.skipTask(task)
        selectedTask = nil
        showTaskDetail = false
        resetTimer()
    }
    
    func toggleTimer() {
        isTimerRunning.toggle()
    }
    
    func resetTimer() {
        timerSeconds = 0
        isTimerRunning = false
    }
    
    func generateTodayTasks() {
        appState.generateDailyTasks()
    }
    
    // MARK: - Computed Properties
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
    
    // MARK: - Timer Methods
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func startTimerUpdates() {
        // Timer is set up as a published property, updates handled by SwiftUI
    }
    
    func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    var timeLabel: String {
        formatTime(timerSeconds)
    }
}