import SwiftUI

struct WelcomeView: View {
    let onNext: () -> Void
    
    @State private var showContent = false
    @State private var animateIcons = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: DriveSpacing.xl) {
                ZStack {
                    Circle()
                        .fill(LinearGradient.driveGlow)
                        .frame(width: 120, height: 120)
                        .blur(radius: 40)
                        .opacity(animateIcons ? 0.6 : 0.3)
                    
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundStyle(.white)
                        .glow(color: Color.drivePurple, radius: 20, intensity: animateIcons ? 0.7 : 0.4)
                }
                .scaleEffect(animateIcons ? 1.05 : 1.0)
                
                VStack(spacing: DriveSpacing.md) {
                    Text("Welcome to")
                        .font(.driveTitle3)
                        .foregroundStyle(Color.driveTextSecondary)
                    
                    Text("DRIVE")
                        .font(.driveLargeTitle)
                        .gradientText(Color.driveVibrant)
                        .glow(color: Color.drivePurple, radius: 15, intensity: 0.5)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                
                Text("Your daily companion for building skills,\nearning rewards, and achieving your goals")
                    .font(.driveBody)
                    .foregroundStyle(Color.driveTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DriveSpacing.xxl)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
            }
            
            Spacer()
            
            VStack(spacing: DriveSpacing.lg) {
                HStack(spacing: DriveSpacing.md) {
                    FeatureIcon(icon: "star.fill", color: Color.drivePink, delay: 0.1)
                    FeatureIcon(icon: "bolt.fill", color: Color.drivePurple, delay: 0.2)
                    FeatureIcon(icon: "crown.fill", color: Color.driveCyan, delay: 0.3)
                }
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.8)
                
                GradientButton("Get Started", icon: "arrow.right", action: onNext)
                    .padding(.horizontal, DriveSpacing.xl)
            }
            .padding(.bottom, DriveSpacing.huge)
        }
        .padding(.horizontal, DriveSpacing.base)
        .onAppear {
            withAnimation(DriveAnimations.slow) {
                animateIcons = true
            }
            withAnimation(DriveAnimations.standard.delay(0.2)) {
                showContent = true
            }
        }
    }
}

struct FeatureIcon: View {
    let icon: String
    let color: Color
    let delay: Double
    
    @State private var isAnimating = false
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 24, weight: .semibold))
            .foregroundStyle(color)
            .frame(width: 56, height: 56)
            .background(
                Circle()
                    .fill(Color.driveGlassBackground)
            )
            .overlay(
                Circle()
                    .strokeBorder(color.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .onAppear {
                withAnimation(DriveAnimations.pulse.delay(delay)) {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    WelcomeView(onNext: {})
        .background(Color.driveBackground)
}
