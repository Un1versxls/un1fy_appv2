import SwiftUI

struct MainDashboardView: View {
    @StateObject private var viewModel: MainDashboardViewModel
    @State private var selectedTask: DailyTask?
    @State private var showTaskDetail = false
    
    init() {
        let appState = AppState.shared
        _viewModel = StateObject(wrappedValue: MainDashboardViewModel(appState: appState))
    }
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            TasksTabView(
                onTaskTap: { task in
                    selectedTask = task
                    showTaskDetail = true
                }
            )
            .tabItem {
                Label("Tasks", systemImage: "checklist")
            }
            .tag(0)
            
            ProgressTabView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }
                .tag(1)
            
            ProfileTabView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
        .tint(.drivePurple)
        .sheet(isPresented: $showTaskDetail) {
            if let task = selectedTask {
                TaskDetailSheet(task: task) { completedTask in
                    viewModel.completeSelectedTask()
                } onSkip: { skippedTask in
                    viewModel.skipSelectedTask()
                }
            }
        }
    }
}

// MARK: - Tab Bar Customization

extension MainDashboardView {
    private var tabBarAppearance: UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.driveSurface)
        return appearance
    }
}

#Preview {
    MainDashboardView()
        .environmentObject(AppState.shared)
}
