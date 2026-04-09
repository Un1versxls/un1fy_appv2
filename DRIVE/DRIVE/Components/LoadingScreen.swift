//
//  LoadingScreen.swift
//  DRIVE
//
//  Created by Kilo on 07/04/2026.
//

import SwiftUI

@available(iOS 15.0, *)
public struct LoadingScreen: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.0
    @State private var progress: Double = 0.0
    @State private var rotationDegrees: Double = 0.0
    
    public var loadingMessage: String = "Preparing your experience..."
    
    public init(loadingMessage: String = "Preparing your experience...") {
        self.loadingMessage = loadingMessage
    }
    
    public var body: some View {
        ZStack {
            Theme.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: Theme.Spacing.xLarge) {
                // Logo Animation
                ZStack {
                    Circle()
                        .trim(from: 0.0, to: 0.75)
                        .stroke(
                            LinearGradient(
                                colors: Theme.Colors.primaryGradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .rotationEffect(.degrees(rotationDegrees))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "steeringwheel")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                        .foregroundStyle(
                            LinearGradient(
                                colors: Theme.Colors.primaryGradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                }
                
                // Loading Text
                Text(loadingMessage)
                    .font(Theme.Typography.subheadline)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                
                // Progress Indicator
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: Theme.Colors.primaryLight))
                    .frame(width: 180)
            }
            .padding(Theme.Spacing.xxLarge)
        }
        .accessibilityLabel("Loading screen")
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Logo fade and scale
        withAnimation(Theme.Animation.slow) {
            logoOpacity = 1.0
            logoScale = 1.0
        }
        
        // Continuous rotation animation
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationDegrees = 360.0
        }
        
        // Progress simulation
        simulateProgress()
    }
    
    private func simulateProgress() {
        // Simulate loading progress over ~3 seconds
        Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { timer in
            withAnimation {
                progress += 0.025
                if progress >= 1.0 {
                    timer.invalidate()
                }
            }
        }
    }
}

@available(iOS 15.0, *)
struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadingScreen()
            LoadingScreen()
                .preferredColorScheme(.dark)
        }
    }
}
