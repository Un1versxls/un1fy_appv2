import SwiftUI

struct TaskDetailSheet: View {
    let task: DailyTask
    let onComplete: (DailyTask) -> Void
    let onSkip: (DailyTask) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var isTimerRunning = false
    @State private var timerSeconds: Int = 0
    @State private var selectedTask: DailyTask
    @State private var showSkipConfirmation = false
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(task: DailyTask, onComplete: @escaping (DailyTask) -> Void, onSkip: @escaping (DailyTask) -> Void) {
        self.task = task
        self.onComplete = onComplete
        self.onSkip = onSkip
        self._selectedTask = State(initialValue: task)
    }
    
    var body: some View {
        ZStack {
            Color.driveBackground
                .ignoresSafeArea()
            
            VStack(spacing: DriveSpacing.xl) {
                headerSection
                
                taskContent
                
                if isTimerRunning || timerSeconds > 0 {
                    timerSection
                }
                
                Spacer()
                
                actionButtons
            }
            .padding(DriveSpacing.base)
        }
        .onReceive(timer) { _ in
            if isTimerRunning {
                timerSeconds += 1
            }
        }
        .alert("Skip Task?", isPresented: $showSkipConfirmation) {
            Button("Skip", role: .destructive) {
                onSkip(selectedTask)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to skip this task? You won't receive points.")
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.driveTextSecondary)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color.driveSurfaceElevated)
                    )
            }
            
            Spacer()
            
            Text("Task Details")
                .font(.driveHeadline)
                .foregroundColor(.driveTextPrimary)
            
            Spacer()
            
            Color.clear
                .frame(width: 32, height: 32)
        }
    }
    
    // MARK: - Task Content
    
    private var taskContent: some View {
        VStack(spacing: DriveSpacing.lg) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.drivePurple, .driveBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.white)
            }
            .glow(color: Color.drivePurple, radius: 15, intensity: 0.4)
            
            VStack(spacing: DriveSpacing.sm) {
                Text(selectedTask.title)
                    .font(.driveTitle2)
                    .foregroundColor(.driveTextPrimary)
                    .multilineTextAlignment(.center)
                
                Text(selectedTask.description ?? "")
                    .font(.driveSubheadline)
                    .foregroundColor(.driveTextSecondary)
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: DriveSpacing.xl) {
                infoChip(icon: "star.fill", value: selectedTask.pointsLabel, color: Color.driveWarning)
                infoChip(icon: "clock", value: selectedTask.timeLabel, color: Color.driveCyan)
                infoChip(icon: "folder.fill", value: selectedTask.niche, color: .drivePurple)
            }
        }
        .padding(DriveSpacing.base)
        .glassMorphism(
            backgroundOpacity: 0.04,
            borderOpacity: 0.1,
            cornerRadius: DriveRadius.xl
        )
    }
    
    private var categoryIcon: String {
        switch selectedTask.category {
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
    
    private func infoChip(icon: String, value: String, color: Color) -> some View {
        VStack(spacing: DriveSpacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
            
            Text(value)
                .font(.driveSubheadline)
                .foregroundColor(.driveTextPrimary)
        }
    }
    
    // MARK: - Timer Section
    
    private var timerSection: some View {
        VStack(spacing: DriveSpacing.md) {
            Text(formatTime(timerSeconds))
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .foregroundColor(.driveTextPrimary)
                .gradientText(isTimerRunning ? LinearGradient.drivePrimary : LinearGradient(colors: [.driveTextSecondary, .driveTextTertiary], startPoint: .leading, endPoint: .trailing))
            
            HStack(spacing: DriveSpacing.base) {
                if !isTimerRunning {
                    Button {
                        withAnimation(DriveAnimations.standard) {
                            isTimerRunning = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start Timer")
                        }
                        .font(.driveHeadline)
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: DriveRadius.lg)
                                .fill(Color.drivePrimary)
                        )
                    }
                } else {
                    Button {
                        withAnimation(DriveAnimations.standard) {
                            isTimerRunning = false
                        }
                    } label: {
                        HStack {
                            Image(systemName: "pause.fill")
                            Text("Pause")
                        }
                        .font(.driveHeadline)
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: DriveRadius.lg)
                                .fill(Color.driveWarning)
                        )
                    }
                }
                
                if timerSeconds > 0 {
                    Button {
                        withAnimation(DriveAnimations.standard) {
                            timerSeconds = 0
                            isTimerRunning = false
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset")
                        }
                        .font(.driveHeadline)
                        .foregroundColor(.driveTextSecondary)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: DriveRadius.lg)
                                .fill(Color.driveSurfaceElevated)
                        )
                    }
                }
            }
        }
        .padding(DriveSpacing.base)
        .glassMorphism(
            backgroundOpacity: 0.04,
            borderOpacity: 0.1,
            cornerRadius: DriveRadius.lg
        )
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    // MARK: - Action Buttons
    
    private var actionButtons: some View {
        VStack(spacing: DriveSpacing.base) {
            GradientButton(
                title: "Complete Task",
                style: .primary
            ) {
                onComplete(selectedTask)
                dismiss()
            }
            
            GradientOutlineButton("Skip Task") {
                showSkipConfirmation = true
            }
        }
    }
}

#Preview {
    TaskDetailSheet(
        task: DailyTask(
            title: "Schedule 3 posts for tomorrow",
            description: "Use your scheduling tool to queue posts for peak engagement times",
            targetDate: Date(),
            xpReward: 15,
            category: .quick
        ),
        onComplete: { _ in },
        onSkip: { _ in }
    )
}
