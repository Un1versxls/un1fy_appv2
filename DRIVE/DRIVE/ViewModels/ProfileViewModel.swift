import Foundation
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var showEditName = false
    @Published var newName = ""
    @Published var isLoading = false
    
    // MARK: - Dependencies
    private let appState: AppState
    
    // MARK: - Initialization
    init(appState: AppState) {
        self.appState = appState
    }
    
    // MARK: - Computed Properties
    private var profile: UserProfile {
        appState.currentUser
    }
    
    // MARK: - Public Methods
    func startEditingName() {
        newName = profile.displayName
        showEditName = true
    }
    
    func saveName() {
        guard !newName.isEmpty else { return }
        appState.updateProfileName(newName)
        showEditName = false
        newName = ""
    }
    
    func cancelEditing() {
        showEditName = false
        newName = ""
    }
    
    func resetProgress() {
        appState.resetProgress()
    }
    
    // MARK: - Helper Methods
    var planBadgeInfo: (icon: String, color: Color) {
        switch profile.currentPlan {
        case .free:
            return ("star", Color.driveTextTertiary)
        case .pro:
            return ("crown.fill", Color.drivePurple)
        case .elite:
            return ("bolt.fill", Color.driveWarning)
        }
    }
    
    var levelProgress: Double {
        profile.currentLevelProgress
    }
    
    var stats: UserStats {
        profile.stats
    }
}