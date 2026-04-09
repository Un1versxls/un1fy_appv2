import SwiftUI

struct GoalQuestionsView: View {
    let questionNumber: Int
    let totalQuestions: Int
    let question: String
    let options: [String]
    @Binding var selectedOption: String
    let onNext: () -> Void
    let onBack: () -> Void
    
    @State private var animateIn = false
    @State private var selectedIndex: Int? = nil
    
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
                }
                
                ProgressDots(current: questionNumber, total: totalQuestions)
                    .opacity(animateIn ? 1 : 0)
                
                VStack(spacing: DriveSpacing.lg) {
                    Text("Question \(questionNumber)")
                        .font(.driveSubheadline)
                        .foregroundStyle(Color.driveTextTertiary)
                    
                    Text(question)
                        .font(.driveTitle2)
                        .foregroundStyle(Color.driveTextPrimary)
                        .multilineTextAlignment(.center)
                }
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 20)
            }
            
            Spacer()
            
            VStack(spacing: DriveSpacing.md) {
                ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                    OptionButton(
                        title: option,
                        isSelected: selectedIndex == index,
                        delay: Double(index) * 0.1
                    ) {
                        withAnimation(DriveAnimations.fast) {
                            selectedIndex = index
                            selectedOption = option
                        }
                    }
                }
            }
            .padding(.horizontal, DriveSpacing.xl)
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : 30)
            
            Spacer()
            
            GradientButton(
                "Continue",
                icon: "arrow.right",
                isEnabled: selectedIndex != nil,
                action: onNext
            )
            .padding(.horizontal, DriveSpacing.xl)
            .padding(.bottom, DriveSpacing.huge)
        }
        .padding(.horizontal, DriveSpacing.base)
        .onAppear {
            withAnimation(DriveAnimations.standard) {
                animateIn = true
            }
            if let index = options.firstIndex(of: selectedOption) {
                selectedIndex = index
            }
        }
    }
}

struct ProgressDots: View {
    let current: Int
    let total: Int
    
    var body: some View {
        HStack(spacing: DriveSpacing.sm) {
            ForEach(1...total, id: \.self) { index in
                Circle()
                    .fill(index <= current ? LinearGradient.drivePrimary : Color.driveSurfaceElevated)
                    .frame(width: 8, height: 8)
                    .overlay(
                        Circle()
                            .strokeBorder(
                                index <= current ? Color.clear : Color.driveGlassBorder,
                                lineWidth: 1
                            )
                    )
            }
        }
    }
}

struct OptionButton: View {
    let title: String
    let isSelected: Bool
    let delay: Double
    let action: () -> Void
    
    @State private var isHovering = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.driveBody)
                    .foregroundStyle(isSelected ? .white : Color.driveTextSecondary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.drivePrimary)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, DriveSpacing.lg)
            .padding(.vertical, DriveSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DriveRadius.lg)
                    .fill(isSelected ? LinearGradient.drivePrimary : Color.driveGlassBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DriveRadius.lg)
                    .strokeBorder(
                        isSelected ? Color.clear : LinearGradient(
                            colors: [Color.driveGlassBorder, Color.driveGlassBorderLight],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .glow(
                color: .drivePurple,
                radius: isHovering || isSelected ? 15 : 0,
                intensity: isSelected ? 0.4 : 0.2
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

#Preview {
    GoalQuestionsView(
        questionNumber: 1,
        totalQuestions: 4,
        question: "What's your primary goal?",
        options: ["Earn extra income", "Build skills", "Grow my business", "Stay productive"],
        selectedOption: .constant(""),
        onNext: {},
        onBack: {}
    )
    .background(Color.driveBackground)
}
