import SwiftUI

@main
struct DRIVEApp: App {
    @StateObject private var appState: AppState
    
    init() {
        let storedState = StorageManager.shared.loadAppState() ?? AppState()
        AppState.shared = storedState
        _appState = StateObject(wrappedValue: storedState)
    }
    
    var body: some Scene {
        WindowGroup {
            if appState.hasCompletedOnboarding {
                MainDashboardView()
                    .environmentObject(appState)
            } else {
                OnboardingFlowView()
                    .environmentObject(appState)
            }
        }
    }
}
