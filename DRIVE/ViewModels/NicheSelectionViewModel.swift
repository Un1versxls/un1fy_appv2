import Foundation
import SwiftUI

@MainActor
class NicheSelectionViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedNiches: Set<UUID> = []
    @Published var showingValidationError = false
    @Published var isLoading = false
    
    // MARK: - Constants
    let maxSelections = 3
    let minSelections = 1
    
    // MARK: - Dependencies
    private let appState: AppState
    
    // MARK: - Initialization
    init(appState: AppState) {
        self.appState = appState
    }
    
    // MARK: - Public Methods
    func toggleSelection(_ niche: Niche) {
        withAnimation(DriveAnimations.standard) {
            if selectedNiches.contains(niche.id) {
                selectedNiches.remove(niche.id)
            } else if selectedNiches.count < maxSelections {
                selectedNiches.insert(niche.id)
            }
        }
    }
    
    func saveSelections() {
        guard selectedNiches.count >= minSelections && selectedNiches.count <= maxSelections else {
            showingValidationError = true
            return
        }
        
        isLoading = true
        // Simulate some async work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            
            let niches = Niche.allNiches.filter { self.selectedNiches.contains($0.id) }
            self.appState.selectNiches(niches)
            self.appState.completeOnboarding()
            self.isLoading = false
        }
    }
    
    func clearAll() {
        withAnimation(DriveAnimations.standard) {
            selectedNiches.removeAll()
        }
    }
    
    // MARK: - Helper Methods
    var selectionCount: Int {
        selectedNiches.count
    }
    
    var canContinue: Bool {
        selectedNiches.count >= minSelections && selectedNiches.count <= maxSelections
    }
    
    var progressText: String {
        "\(selectedNiches.count)/\(maxSelections) selected"
    }
    
    var validationMessage: String {
        "Please select at least \(minSelections) and up to \(maxSelections) niches to continue."
    }
}