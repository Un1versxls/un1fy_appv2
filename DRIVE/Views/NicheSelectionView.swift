import SwiftUI

struct NicheSelectionView: View {
    @StateObject private var viewModel: NicheSelectionViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: NicheSelectionViewModel(appState: AppState.shared))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.driveBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DriveSpacing.xl) {
                        headerSection
                        
                        selectionCounter
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: DriveSpacing.base),
                            GridItem(.flexible(), spacing: DriveSpacing.base)
                        ], spacing: DriveSpacing.base) {
                            ForEach(Niche.allNiches) { niche in
                                NicheCard(
                                    niche: niche,
                                    isSelected: viewModel.selectedNiches.contains(niche.id),
                                    onTap: { viewModel.toggleSelection(niche) }
                                )
                            }
                        }
                        .padding(.horizontal, DriveSpacing.base)
                        
                        continueButton
                    }
                    .padding(.vertical, DriveSpacing.xl)
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Selection Required", isPresented: $viewModel.showingValidationError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please select at least \(viewModel.minSelections) and up to \(viewModel.maxSelections) niches to continue.")
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: DriveSpacing.sm) {
            Text("Choose Your Path")
                .font(.driveLargeTitle)
                .foregroundColor(.driveTextPrimary)
                .multilineTextAlignment(.center)
            
            Text("Select 1-3 niches that match your goals")
                .font(.driveSubheadline)
                .foregroundColor(.driveTextSecondary)
        }
        .padding(.horizontal, DriveSpacing.base)
    }
    
    // MARK: - Selection Counter
    
    private var selectionCounter: some View {
        HStack {
            Text("\(viewModel.selectionCount)/\(viewModel.maxSelections) selected")
                .font(.driveCallout)
                .foregroundColor(.driveTextSecondary)
            
            Spacer()
            
            if viewModel.selectionCount > 0 {
                Button("Clear All") {
                    viewModel.clearAll()
                }
                .font(.driveCallout)
                .foregroundColor(Color.drivePurple)
            }
        }
        .padding(.horizontal, DriveSpacing.base)
    }
    
    // MARK: - Continue Button
    
    private var continueButton: some View {
        VStack(spacing: DriveSpacing.base) {
            GradientButton(
                "Continue",
                icon: "arrow.right",
                isEnabled: viewModel.canContinue
            ) {
                viewModel.saveSelections()
            }
            .padding(.horizontal, DriveSpacing.base)
            
            if !viewModel.canContinue {
                Text("Select at least \(viewModel.minSelections) niche to continue")
                    .font(.driveCaption)
                    .foregroundColor(.driveTextTertiary)
            }
        }
        .padding(.top, DriveSpacing.base)
    }
}

// MARK: - Niche Card

struct NicheCard: View {
    let niche: Niche
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: DriveSpacing.md) {
                iconSection
                contentSection
            }
            .padding(DriveSpacing.base)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassMorphism(
                backgroundOpacity: isSelected ? 0.08 : 0.04,
                borderOpacity: isSelected ? 0.25 : 0.1,
                cornerRadius: DriveRadius.lg
            )
            .overlay(
                RoundedRectangle(cornerRadius: DriveRadius.lg)
                    .strokeBorder(
                        isSelected ? Color(hex: niche.color) : Color.clear,
                        lineWidth: 2
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            withAnimation(DriveAnimations.fast) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    private var iconSection: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color(hex: niche.color).opacity(0.2))
                    .frame(width: 48, height: 48)
                
                Image(systemName: niche.icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Color(hex: niche.color))
            }
            
            Spacer()
            
            if isSelected {
                ZStack {
                    Circle()
                        .fill(Color.drivePrimary)
                        .frame(width: 24, height: 24)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: DriveSpacing.xs) {
            Text(niche.name)
                .font(.driveHeadline)
                .foregroundColor(.driveTextPrimary)
                .lineLimit(1)
            
            difficultyBadge
            
            Text(niche.description)
                .font(.driveCaption)
                .foregroundColor(.driveTextSecondary)
                .lineLimit(2)
        }
    }
    
    private var difficultyBadge: some View {
        Text(niche.difficulty.rawValue)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, DriveSpacing.sm)
            .padding(.vertical, DriveSpacing.xxs)
            .background(
                Capsule()
                    .fill(difficultyColor)
            )
    }
    
    private var difficultyColor: Color {
        switch niche.difficulty {
        case .beginner:
            return .driveSuccess
        case .intermediate:
            return .driveWarning
        case .advanced:
            return .driveError
        }
    }
}

// MARK: - Preview

#Preview {
    NicheSelectionView()
        .environmentObject(AppState.shared)
}
