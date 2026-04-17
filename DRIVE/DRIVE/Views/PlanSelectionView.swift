import SwiftUI

struct PlanSelectionView: View {
    @Binding var selectedPlan: PlanTier
    let onNext: () -> Void
    let onBack: () -> Void
    
    @State private var animateIn = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: DriveSpacing.xl) {
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(Color.driveGlassBackground)
                            )
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.driveGlassBorder, lineWidth: 1)
                            )
                    }
                    
                    Spacer()
                    
                    Text("5/5")
                        .font(.driveSubheadline)
                        .foregroundStyle(Color.driveTextTertiary)
                }
                
                VStack(spacing: DriveSpacing.md) {
                    Text("Choose Your Plan")
                        .font(.driveTitle2)
                        .foregroundStyle(Color.driveTextPrimary)
                        .gradientText(.drivePrimary)
                    
                    Text("Select the plan that best fits your goals")
                        .font(.driveBody)
                        .foregroundStyle(Color.driveTextSecondary)
                }
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 20)
            }
            
            Spacer()
                .frame(height: DriveSpacing.xl)
            
            VStack(spacing: DriveSpacing.lg) {
                ForEach(Array(AppPlan.allPlans.enumerated()), id: \.element.id) { index, plan in
                    PlanSelectionCard(
                        plan: plan,
                        isSelected: selectedPlan == plan.tier,
                        delay: Double(index) * 0.15
                    ) {
                        withAnimation(DriveAnimations.fast) {
                            selectedPlan = plan.tier
                        }
                    }
                }
            }
            .padding(.horizontal, DriveSpacing.xl)
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : 30)
            
            Spacer()
            
            VStack(spacing: DriveSpacing.md) {
                if selectedPlan != .free {
                    HStack(spacing: DriveSpacing.xs) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 12, weight: .bold))
                        Text("You selected \(selectedPlan.rawValue.capitalized)")
                            .font(.driveCaption)
                    }
                    .foregroundStyle(Color.drivePink)
                }
                
                GradientButton(
                    "Continue",
                    icon: "arrow.right",
                    action: onNext
                )
            }
            .padding(.horizontal, DriveSpacing.xl)
            .padding(.bottom, DriveSpacing.huge)
        }
        .padding(.horizontal, DriveSpacing.base)
        .onAppear {
            withAnimation(DriveAnimations.standard) {
                animateIn = true
            }
        }
    }
}

struct PlanSelectionCard: View {
    let plan: AppPlan
    let isSelected: Bool
    let delay: Double
    let action: () -> Void
    
    @State private var isHovering = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: DriveSpacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: DriveSpacing.xs) {
                        HStack(spacing: DriveSpacing.sm) {
                            Text(plan.name)
                                .font(.driveHeadline)
                                .foregroundStyle(.white)
                            
                            if plan.isPopular {
                                Text("POPULAR")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(
                                        Capsule()
                                            .fill(LinearGradient.drivePrimary)
                                    )
                            }
                        }
                        
                        Text(plan.description)
                            .font(.driveCaption)
                            .foregroundStyle(Color.driveTextSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: DriveSpacing.xxs) {
                        Text(plan.priceString)
                            .font(.driveTitle3)
                            .foregroundStyle(isSelected ? .drivePrimary : .white)
                    }
                }
                
                Divider()
                    .background(Color.driveGlassBorder)
                
                HStack(spacing: DriveSpacing.lg) {
                    FeatureTag(text: plan.taskLimitText, icon: "checkmark")
                    
                    if plan.tier == .pro {
                        FeatureTag(text: "2x Points", icon: "star.fill", color: Color.drivePink)
                    } else if plan.tier == .elite {
                        FeatureTag(text: "5x Points", icon: "star.fill", color: Color.drivePink)
                    }
                    
                    Spacer()
                }
            }
            .padding(DriveSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DriveRadius.xl)
                    .fill(isSelected ? Color.driveGlassBackground : Color.driveSurface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DriveRadius.xl)
                    .strokeBorder(
                        isSelected ? LinearGradient.drivePrimary : Color.driveGlassBorder,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: DriveRadius.xl)
                    .fill(
                        isSelected ?
                        LinearGradient.drivePrimary :
                        LinearGradient.clear
                    )
                    .opacity(isHovering ? 0.1 : 0)
            )
            .glow(
                color: Color.drivePurple,
                radius: isSelected ? 20 : 0,
                intensity: isSelected ? 0.3 : 0
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(DriveAnimations.fast) {
                isHovering = hovering
            }
        }
    }
}

struct FeatureTag: View {
    let text: String
    let icon: String
    var color: Color = .driveSuccess
    
    var body: some View {
        HStack(spacing: DriveSpacing.xxs) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
            Text(text)
                .font(.driveCaption)
        }
        .foregroundStyle(color)
    }
}

#Preview {
    PlanSelectionView(
        selectedPlan: .constant(.free),
        onNext: {},
        onBack: {}
    )
    .background(Color.driveBackground)
}
