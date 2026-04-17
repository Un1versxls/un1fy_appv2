import SwiftUI

struct ProfileTabView: View {
    @StateObject private var viewModel: ProfileViewModel
    @EnvironmentObject var appState: AppState
    
    @State private var showEditName = false
    @State private var newName = ""
    
    init() {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(appState: AppState.shared))
    }
    
    private var profile: UserProfile {
        appState.currentUser
    }
    
    var body: some View {
        ZStack {
            Color.driveBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: DriveSpacing.xl) {
                    profileHeader
                    
                    statsOverview
                    
                    selectedNiches
                    
                    settingsSection
                    
                    logoutButton
                }
                .padding(DriveSpacing.base)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
        .alert("Edit Name", isPresented: $showEditName) {
            TextField("Name", text: $newName)
            Button("Save") {
                viewModel.saveName()
            }
            Button("Cancel", role: .cancel) {
                viewModel.cancelEditing()
            }
        }
    }
    
    // MARK: - Profile Header
    
    private var profileHeader: some View {
        VStack(spacing: DriveSpacing.base) {
            ZStack {
                Circle()
                    .fill(Color.drivePrimary)
                    .frame(width: 80, height: 80)
                
                Text(profile.displayName.prefix(1).uppercased())
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }
            .glow(color: Color.drivePurple, radius: 10, intensity: 0.3)
            
            VStack(spacing: DriveSpacing.xxs) {
                HStack {
                    Text(profile.displayName.isEmpty ? "Set your name" : profile.displayName)
                        .font(.driveTitle2)
                        .foregroundColor(Color.driveTextPrimary)
                    
                    Button {
                        newName = profile.displayName
                        showEditName = true
                    } label: {
                        Image(systemName: "pencil")
                            .font(.system(size: 14))
                            .foregroundColor(.drivePurple)
                    }
                }
                
                Text("Level \(profile.stats.level) \(profile.stats.levelTitle)")
                    .font(.driveSubheadline)
                    .foregroundColor(.driveTextSecondary)
            }
            
            planBadge
        }
        .padding(DriveSpacing.base)
        .frame(maxWidth: .infinity)
        .glassMorphism(
            backgroundOpacity: 0.04,
            borderOpacity: 0.1,
            cornerRadius: DriveRadius.xl
        )
    }
    
    private var planBadge: some View {
        HStack(spacing: DriveSpacing.xs) {
            Image(systemName: planIcon)
                .font(.system(size: 12))
            Text(profile.currentPlan.rawValue.capitalized)
                .font(.system(size: 12, weight: .semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, DriveSpacing.md)
        .padding(.vertical, DriveSpacing.xs)
        .background(
            Capsule()
                .fill(planColor)
        )
    }
    
    private var planColor: Color {
        switch profile.currentPlan {
        case .free:
            return .driveTextTertiary
        case .pro:
            return .drivePurple
        case .elite:
            return .driveWarning
        }
    }
    
    private var planIcon: String {
        switch profile.currentPlan {
        case .free:
            return "star"
        case .pro:
            return "crown.fill"
        case .elite:
            return "bolt.fill"
        }
    }
    
    // MARK: - Stats Overview
    
    private var statsOverview: some View {
        HStack(spacing: DriveSpacing.base) {
            statItem(value: "\(profile.stats.totalPoints)", label: "Points", icon: "star.fill", color: Color.driveWarning)
            statItem(value: "\(profile.stats.totalTasksCompleted)", label: "Tasks", icon: "checkmark.circle.fill", color: Color.driveSuccess)
            statItem(value: "\(profile.stats.currentStreak)", label: "Streak", icon: "flame.fill", color: Color.driveError)
        }
    }
    
    private func statItem(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: DriveSpacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
            
            Text(value)
                .font(.driveTitle3)
                .foregroundColor(.driveTextPrimary)
            
            Text(label)
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
    
    // MARK: - Selected Niches
    
    private var selectedNiches: some View {
        VStack(alignment: .leading, spacing: DriveSpacing.md) {
            HStack {
                Text("Selected Niches")
                    .font(.driveTitle3)
                    .foregroundColor(.driveTextPrimary)
                
                Spacer()
                
                NavigationLink(destination: NicheSelectionView()) {
                    Text("Change")
                        .font(.driveCaption)
                        .foregroundColor(.drivePurple)
                }
            }
            
            if profile.selectedNicheIds.isEmpty {
                Text("No niches selected")
                    .font(.driveSubheadline)
                    .foregroundColor(.driveTextTertiary)
                    .padding(DriveSpacing.base)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DriveSpacing.sm) {
                        ForEach(profile.selectedNiches) { niche in
                            nicheChip(niche)
                        }
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
    
    private func nicheChip(_ niche: Niche) -> some View {
        HStack(spacing: DriveSpacing.xs) {
            Image(systemName: niche.icon)
                .font(.system(size: 12))
            Text(niche.name)
                .font(.driveCaption)
        }
        .foregroundColor(Color(hex: niche.color))
        .padding(.horizontal, DriveSpacing.md)
        .padding(.vertical, DriveSpacing.sm)
        .background(
            Capsule()
                .fill(Color(hex: niche.color).opacity(0.15))
        )
    }
    
    // MARK: - Settings Section
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: DriveSpacing.md) {
            Text("Settings")
                .font(.driveTitle3)
                .foregroundColor(.driveTextPrimary)
            
            VStack(spacing: DriveSpacing.none) {
                settingsRow(icon: "bell.fill", title: "Notifications", trailing: profile.settings.dailyReminderEnabled ? "On" : "Off")
                
                Divider()
                    .background(Color.driveGlassBorder)
                
                settingsRow(icon: "speaker.wave.2.fill", title: "Sound", trailing: profile.settings.soundEnabled ? "On" : "Off")
                
                Divider()
                    .background(Color.driveGlassBorder)
                
                settingsRow(icon: "hand.tap.fill", title: "Haptics", trailing: profile.settings.hapticEnabled ? "On" : "Off")
            }
            .glassMorphism(
                backgroundOpacity: 0.04,
                borderOpacity: 0.1,
                cornerRadius: DriveRadius.lg
            )
        }
    }
    
    private func settingsRow(icon: String, title: String, trailing: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.drivePurple)
                .frame(width: 24)
            
            Text(title)
                .font(.driveBody)
                .foregroundColor(.driveTextPrimary)
            
            Spacer()
            
            Text(trailing)
                .font(.driveSubheadline)
                .foregroundColor(.driveTextSecondary)
        }
        .padding(DriveSpacing.base)
    }
    
    // MARK: - Logout Button
    
    private var logoutButton: some View {
        VStack(spacing: DriveSpacing.base) {
            GradientOutlineButton("Reset Progress") {
                appState.resetProgress()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileTabView()
            .environmentObject(AppState.shared)
    }
}
