import SwiftUI

struct ProgressTabView: View {
    @EnvironmentObject var appState: AppState
    
    private var stats: UserStats {
        appState.currentUser.stats
    }
    
    var body: some View {
        ZStack {
            Color.driveBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: DriveSpacing.xl) {
                    streakSection
                    
                    pointsSection
                    
                    levelSection
                    
                    badgesSection
                }
                .padding(DriveSpacing.base)
            }
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Streak Section
    
    private var streakSection: some View {
        VStack(alignment: .leading, spacing: DriveSpacing.md) {
            Text("Streak")
                .font(.driveTitle3)
                .foregroundColor(.driveTextPrimary)
            
            HStack(spacing: DriveSpacing.base) {
                streakCard(
                    title: "Current",
                    value: "\(stats.currentStreak)",
                    icon: "flame.fill",
                    color: Color.driveWarning
                )
                
                streakCard(
                    title: "Longest",
                    value: "\(stats.longestStreak)",
                    icon: "trophy.fill",
                    color: Color.drivePurple
                )
            }
        }
    }
    
    private func streakCard(title: String, value: String, icon: String, color: Color) -> some View {
        HStack(spacing: DriveSpacing.base) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: DriveSpacing.xxs) {
                Text(value)
                    .font(.driveTitle1)
                    .foregroundColor(.driveTextPrimary)
                
                Text(title)
                    .font(.driveCaption)
                    .foregroundColor(.driveTextSecondary)
            }
            
            Spacer()
        }
        .padding(DriveSpacing.base)
        .glassMorphism(
            backgroundOpacity: 0.04,
            borderOpacity: 0.1,
            cornerRadius: DriveRadius.lg
        )
    }
    
    // MARK: - Points Section
    
    private var pointsSection: some View {
        VStack(alignment: .leading, spacing: DriveSpacing.md) {
            Text("Points")
                .font(.driveTitle3)
                .foregroundColor(.driveTextPrimary)
            
            HStack(spacing: DriveSpacing.base) {
                pointsCard(
                    title: "Total Points",
                    value: "\(stats.totalPoints)",
                    icon: "star.fill",
                    color: Color.driveWarning
                )
                
                pointsCard(
                    title: "Tasks Done",
                    value: "\(stats.totalTasksCompleted)",
                    icon: "checkmark.circle.fill",
                    color: Color.driveSuccess
                )
            }
        }
    }
    
    private func pointsCard(title: String, value: String, icon: String, color: Color) -> some View {
        HStack(spacing: DriveSpacing.base) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: DriveSpacing.xxs) {
                Text(value)
                    .font(.driveTitle1)
                    .foregroundColor(.driveTextPrimary)
                
                Text(title)
                    .font(.driveCaption)
                    .foregroundColor(.driveTextSecondary)
            }
            
            Spacer()
        }
        .padding(DriveSpacing.base)
        .glassMorphism(
            backgroundOpacity: 0.04,
            borderOpacity: 0.1,
            cornerRadius: DriveRadius.lg
        )
    }
    
    // MARK: - Level Section
    
    private var levelSection: some View {
        VStack(alignment: .leading, spacing: DriveSpacing.md) {
            Text("Level")
                .font(.driveTitle3)
                .foregroundColor(.driveTextPrimary)
            
            VStack(spacing: DriveSpacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: DriveSpacing.xxs) {
                        HStack {
                            Text("Level \(stats.level)")
                                .font(.driveTitle2)
                                .foregroundColor(.driveTextPrimary)
                            
                            Text(stats.levelTitle)
                                .font(.driveCaption)
                                .foregroundColor(Color.drivePurple)
                                .padding(.horizontal, DriveSpacing.sm)
                                .padding(.vertical, DriveSpacing.xxs)
                                .background(
                                    Capsule()
                                        .fill(Color.drivePurple.opacity(0.15))
                                )
                        }
                        
                        Text("\(stats.xp) / \(stats.xpToNextLevel) XP")
                            .font(.driveSubheadline)
                            .foregroundColor(.driveTextSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(Color.drivePurple)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: DriveRadius.pill)
                            .fill(Color.driveSurfaceElevated)
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: DriveRadius.pill)
                            .fill(Color.drivePrimary)
                            .frame(width: geometry.size.width * stats.progressToNextLevel, height: 8)
                    }
                }
                .frame(height: 8)
            }
            .padding(DriveSpacing.base)
            .glassMorphism(
                backgroundOpacity: 0.04,
                borderOpacity: 0.1,
                cornerRadius: DriveRadius.lg
            )
        }
    }
    
    // MARK: - Badges Section
    
    private var badgesSection: some View {
        VStack(alignment: .leading, spacing: DriveSpacing.md) {
            HStack {
                Text("Badges")
                    .font(.driveTitle3)
                    .foregroundColor(.driveTextPrimary)
                
                Spacer()
                
                Text("\(stats.badges.count) earned")
                    .font(.driveCaption)
                    .foregroundColor(.driveTextSecondary)
            }
            
            if stats.badges.isEmpty {
                emptyBadgesView
            } else {
                badgesGrid
            }
        }
    }
    
    private var emptyBadgesView: some View {
        VStack(spacing: DriveSpacing.base) {
            Image(systemName: "medal")
                .font(.system(size: 40))
                .foregroundColor(.driveTextTertiary)
            
            Text("No badges yet")
                .font(.driveSubheadline)
                .foregroundColor(.driveTextSecondary)
            
            Text("Complete tasks to earn badges!")
                .font(.driveCaption)
                .foregroundColor(.driveTextTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(DriveSpacing.xl)
        .glassMorphism(
            backgroundOpacity: 0.03,
            borderOpacity: 0.1,
            cornerRadius: DriveRadius.lg
        )
    }
    
    private var badgesGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: DriveSpacing.base) {
            ForEach(stats.badges) { badge in
                BadgeView(badge: badge)
            }
        }
    }
}

// MARK: - Badge View

struct BadgeView: View {
    let badge: Badge
    
    var body: some View {
        VStack(spacing: DriveSpacing.xs) {
            ZStack {
                Circle()
                    .fill(Color.drivePrimary.opacity(0.15))
                    .frame(width: 56, height: 56)
                
                Image(systemName: badge.icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color.drivePurple)
            }
            
            Text(badge.name)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.driveTextPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .padding(DriveSpacing.sm)
        .frame(maxWidth: .infinity)
        .glassMorphism(
            backgroundOpacity: 0.04,
            borderOpacity: 0.1,
            cornerRadius: DriveRadius.md
        )
        .help(badge.description)
    }
}

#Preview {
    NavigationStack {
        ProgressTabView()
            .environmentObject(AppState.shared)
    }
}
