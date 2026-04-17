import SwiftUI

struct TasksTabView: View {
    @EnvironmentObject var appState: AppState
    let onTaskTap: (DailyTask) -> Void
    
    @State private var isRefreshing = false
    
    var body: some View {
        ZStack {
            Color.driveBackground
                .ignoresSafeArea()
            
            if appState.todayTasks.isEmpty {
                emptyStateView
            } else {
                tasksListView
            }
        }
        .navigationTitle("Today's Tasks")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: DriveSpacing.xl) {
            Image(systemName: "checkmark.seal")
                .font(.system(size: 64))
                .foregroundColor(.driveTextTertiary)
            
            VStack(spacing: DriveSpacing.sm) {
                Text("No Tasks Yet")
                    .font(.driveTitle2)
                    .foregroundColor(.driveTextPrimary)
                
                Text("Select your niches to generate daily tasks")
                    .font(.driveSubheadline)
                    .foregroundColor(.driveTextSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if appState.currentUser.selectedNicheIds.isEmpty {
                NavigationLink(destination: NicheSelectionView()) {
                    GradientButton("Choose Niches", icon: "arrow.right") {}
                }
                .padding(.horizontal, DriveSpacing.xxxl)
            }
        }
        .padding(DriveSpacing.xl)
    }
    
    // MARK: - Tasks List
    
    private var tasksListView: some View {
        ScrollView {
            VStack(spacing: DriveSpacing.base) {
                taskSummaryHeader
                
                LazyVStack(spacing: DriveSpacing.base) {
                    ForEach(appState.todayTasks) { task in
                        TaskCardView(
                            task: task,
                            onTap: { onTaskTap(task) }
                        )
                    }
                }
                .padding(.horizontal, DriveSpacing.base)
            }
            .padding(.vertical, DriveSpacing.base)
        }
        .refreshable {
            await refreshTasks()
        }
    }
    
    // MARK: - Task Summary Header
    
    private var taskSummaryHeader: some View {
        HStack(spacing: DriveSpacing.lg) {
            StatCard(
                title: "To Do",
                value: "\(appState.pendingTasks.count)",
                icon: "clock.fill",
                color: Color.driveWarning
            )
            
            StatCard(
                title: "Done",
                value: "\(appState.completedTasks.count)",
                icon: "checkmark.circle.fill",
                color: Color.driveSuccess
            )
            
            StatCard(
                title: "Points",
                value: "\(appState.currentUser.stats.totalPoints)",
                icon: "star.fill",
                color: Color.drivePurple
            )
        }
        .padding(.horizontal, DriveSpacing.base)
    }
    
    // MARK: - Refresh
    
    private func refreshTasks() async {
        isRefreshing = true
        appState.generateDailyTasks()
        try? await Task.sleep(nanoseconds: 500_000_000)
        isRefreshing = false
    }
}

// MARK: - Task Card View

struct TaskCardView: View {
    let task: DailyTask
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: DriveSpacing.base) {
                taskIcon
                
                VStack(alignment: .leading, spacing: DriveSpacing.xs) {
                    HStack {
                        Text(task.title)
                            .font(.driveHeadline)
                            .foregroundColor(task.status == .completed ? .driveTextTertiary : .driveTextPrimary)
                            .strikethrough(task.status == .completed, color: Color.driveTextTertiary)
                        
                        Spacer()
                        
                        if task.status == .completed {
                            completedBadge
                        } else {
                            pointsBadge
                        }
                    }
                    
                    Text(task.description ?? "")
                        .font(.driveSubheadline)
                        .foregroundColor(.driveTextSecondary)
                        .lineLimit(2)
                    
                    HStack(spacing: DriveSpacing.md) {
                        timeLabel
                        
                        nicheLabel
                    }
                }
            }
            .padding(DriveSpacing.base)
            .glassMorphism(
                backgroundOpacity: task.status == .completed ? 0.02 : 0.04,
                borderOpacity: task.status == .completed ? 0.05 : 0.12,
                cornerRadius: DriveRadius.lg
            )
            .opacity(task.status == .skipped ? 0.5 : 1.0)
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            withAnimation(DriveAnimations.fast) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    private var taskIcon: some View {
        ZStack {
            Circle()
                .fill(
                    task.status == .completed ?
                    LinearGradient(colors: [.driveSuccess, .driveCyan], startPoint: .top, endPoint: .bottom) :
                    LinearGradient(colors: [.drivePurple, .driveBlue], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: 48, height: 48)
            
            if task.status == .completed {
                Image(systemName: "checkmark")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            } else {
                Image(systemName: taskIconName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
    }
    
    private var taskIconName: String {
        switch task.category {
        case .quick:
            return "bolt.fill"
        case .engagement:
            return "bubble.left.and.bubble.right.fill"
        case .creation:
            return "wand.and.stars"
        case .research:
            return "magnifyingglass"
        case .admin:
            return "doc.text.fill"
        }
    }
    
    private var completedBadge: some View {
        HStack(spacing: DriveSpacing.xxs) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 12))
            Text("Done")
                .font(.driveCaption)
        }
        .foregroundColor(.driveSuccess)
        .padding(.horizontal, DriveSpacing.sm)
        .padding(.vertical, DriveSpacing.xxs)
        .background(
            Capsule()
                .fill(Color.driveSuccess.opacity(0.15))
        )
    }
    
    private var pointsBadge: some View {
        HStack(spacing: DriveSpacing.xxs) {
            Image(systemName: "star.fill")
                .font(.system(size: 10))
            Text(task.pointsLabel)
                .font(.driveCaption)
        }
        .foregroundColor(.driveWarning)
        .padding(.horizontal, DriveSpacing.sm)
        .padding(.vertical, DriveSpacing.xxs)
        .background(
            Capsule()
                .fill(Color.driveWarning.opacity(0.15))
        )
    }
    
    private var timeLabel: some View {
        HStack(spacing: DriveSpacing.xxs) {
            Image(systemName: "clock")
                .font(.system(size: 12))
            Text(task.timeLabel)
                .font(.driveCaption)
        }
        .foregroundColor(.driveTextTertiary)
    }
    
    private var nicheLabel: some View {
        HStack(spacing: DriveSpacing.xxs) {
            Image(systemName: "folder.fill")
                .font(.system(size: 12))
            Text(task.niche)
                .font(.driveCaption)
        }
        .foregroundColor(.driveTextTertiary)
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: DriveSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(value)
                .font(.driveTitle2)
                .foregroundColor(.driveTextPrimary)
            
            Text(title)
                .font(.driveCaption)
                .foregroundColor(.driveTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(DriveSpacing.base)
        .glassMorphism(
            backgroundOpacity: 0.04,
            borderOpacity: 0.1,
            cornerRadius: DriveRadius.md
        )
    }
}

#Preview {
    NavigationStack {
        TasksTabView(onTaskTap: { _ in })
            .environmentObject(AppState.shared)
    }
}
