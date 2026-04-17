import SwiftUI

struct OnboardingCompletionView: View {
    let data: OnboardingData
    let onComplete: () -> Void
    
    @State private var animateIn = false
    @State private var showConfetti = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: DriveSpacing.xl) {
                ZStack {
                    if showConfetti {
                        ConfettiView()
                    }
                    
                    Circle()
                        .fill(LinearGradient.drivePrimary)
                        .frame(width: 100, height: 100)
                        .blur(radius: 30)
                        .opacity(animateIn ? 0.6 : 0)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundStyle(Color.driveSuccess)
                        .glow(color: Color.driveSuccess, radius: 25, intensity: animateIn ? 0.6 : 0.3)
                }
                .scaleEffect(animateIn ? 1.0 : 0.5)
                
                VStack(spacing: DriveSpacing.md) {
                    Text("You're All Set!")
                        .font(.driveTitle1)
                        .foregroundStyle(Color.driveTextPrimary)
                        .gradientText(.drivePrimary)
                    
                    Text("Your plan has been activated")
                        .font(.driveBody)
                        .foregroundStyle(Color.driveTextSecondary)
                }
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 20)
                
                VStack(spacing: DriveSpacing.sm) {
                    SummaryItem(
                        icon: "target",
                        title: "Goal",
                        value: data.primaryGoal.isEmpty ? "Not specified" : data.primaryGoal,
                        delay: 0.1
                    )
                    SummaryItem(
                        icon: "chart.bar",
                        title: "Experience",
                        value: data.experienceLevel.isEmpty ? "Not specified" : data.experienceLevel,
                        delay: 0.2
                    )
                    SummaryItem(
                        icon: "clock",
                        title: "Time Available",
                        value: data.timeAvailability.isEmpty ? "Not specified" : data.timeAvailability,
                        delay: 0.3
                    )
                    SummaryItem(
                        icon: "crown.fill",
                        title: "Plan",
                        value: data.selectedPlan.rawValue.capitalized,
                        valueColor: .drivePink,
                        delay: 0.4
                    )
                }
                .padding(.top, DriveSpacing.lg)
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 30)
            }
            
            Spacer()
            
            VStack(spacing: DriveSpacing.lg) {
                Text("Welcome to DRIVE!")
                    .font(.driveHeadline)
                    .foregroundStyle(Color.driveTextPrimary)
                
                GradientButton("Start Your Journey", icon: "flame.fill", action: onComplete)
            }
            .padding(.horizontal, DriveSpacing.xl)
            .padding(.bottom, DriveSpacing.huge)
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : 20)
        }
        .padding(.horizontal, DriveSpacing.base)
        .onAppear {
            withAnimation(DriveAnimations.standard) {
                animateIn = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(DriveAnimations.bounce) {
                    showConfetti = true
                }
            }
        }
    }
}

struct SummaryItem: View {
    let icon: String
    let title: String
    let value: String
    var valueColor: Color = .driveTextSecondary
    let delay: Double
    
    @State private var animateIn = false
    
    var body: some View {
        HStack(spacing: DriveSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.drivePrimary)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(Color.driveGlassBackground)
                )
                .overlay(
                    Circle()
                        .strokeBorder(Color.driveGlassBorder, lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.driveCaption)
                    .foregroundStyle(Color.driveTextTertiary)
                
                Text(value)
                    .font(.driveBody)
                    .foregroundStyle(valueColor)
            }
            
            Spacer()
        }
        .padding(.horizontal, DriveSpacing.md)
        .opacity(animateIn ? 1 : 0)
        .offset(x: animateIn ? 0 : -20)
        .onAppear {
            withAnimation(DriveAnimations.standard.delay(delay)) {
                animateIn = true
            }
        }
    }
}

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
        }
        .onAppear {
            createParticles()
        }
    }
    
    private func createParticles() {
        let colors: [Color] = [.drivePurple, .drivePink, .driveCyan, .driveBlue, .driveSuccess]
        
        for _ in 0..<30 {
            let particle = ConfettiParticle(
                id: UUID(),
                position: CGPoint(x: CGFloat.random(in: 100...300), y: CGFloat.random(in: 200...400)),
                color: colors.randomElement()!,
                size: CGFloat.random(in: 4...10),
                opacity: Double.random(in: 0.5...1.0)
            )
            particles.append(particle)
            
            withAnimation(DriveAnimations.slow.delay(Double.random(in: 0...0.3))) {
                if let index = particles.firstIndex(where: { $0.id == particle.id }) {
                    particles[index].position.y += CGFloat.random(in: -150...(-50))
                    particles[index].position.x += CGFloat.random(in: -50...50)
                    particles[index].opacity = 0
                }
            }
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id: UUID
    var position: CGPoint
    let color: Color
    let size: CGFloat
    var opacity: Double
}

#Preview {
    OnboardingCompletionView(
        data: OnboardingData(
            primaryGoal: "Earn extra income",
            experienceLevel: "Intermediate",
            timeAvailability: "1 hour",
            selectedPlan: .pro
        ),
        onComplete: {}
    )
    .background(Color.driveBackground)
}
