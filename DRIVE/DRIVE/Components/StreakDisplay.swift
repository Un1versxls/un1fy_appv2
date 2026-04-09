//
//  StreakDisplay.swift
//  DRIVE
//
//  Created by Kilo on 07/04/2026.
//

import SwiftUI

@available(iOS 15.0, *)
public struct StreakDisplay: View {
    public let currentStreak: Int
    public let bestStreak: Int
    public let isActiveToday: Bool
    
    @State private var animateFire: Bool = false
    
    public init(currentStreak: Int, bestStreak: Int, isActiveToday: Bool = true) {
        self.currentStreak = currentStreak
        self.bestStreak = bestStreak
        self.isActiveToday = isActiveToday
    }
    
    public var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            HStack(spacing: Theme.Spacing.medium) {
                // Fire Icon Animation
                Image(systemName: "flame.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Theme.Colors.accent, Theme.Colors.accentLight],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .scaleEffect(animateFire ? 1.1 : 0.9)
                    .offset(y: animateFire ? -2 : 2)
                    .opacity(animateFire ? 1.0 : 0.85)
                
                VStack(alignment: .leading, spacing: Theme.Spacing.xxSmall) {
                    Text("\(currentStreak)")
                        .font(Theme.Typography.largeTitle)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text("Day Streak")
                        .font(Theme.Typography.subheadline)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: Theme.Spacing.xxSmall) {
                    Text("Best")
                        .font(Theme.Typography.caption1)
                        .foregroundColor(Theme.Colors.textTertiary)
                    
                    Text("\(bestStreak) days")
                        .font(Theme.Typography.title3)
                        .foregroundColor(Theme.Colors.textPrimary)
                }
            }
            
            // Activity indicator dots
            HStack(spacing: Theme.Spacing.xSmall) {
                ForEach(0..<7) { day in
                    Circle()
                        .fill(day < (currentStreak % 7) ? Theme.Colors.accent : Theme.Colors.gray300)
                        .frame(width: 8, height: 8)
                        .scaleEffect(day == (currentStreak % 7 - 1) && isActiveToday ? 1.3 : 1.0)
                }
            }
        }
        .padding(Theme.Spacing.medium)
        .background(Theme.Colors.secondaryBackground)
        .cornerRadius(Theme.CornerRadius.large)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever()) {
                animateFire = true
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Current streak \(currentStreak) days, best streak \(bestStreak) days")
    }
}

@available(iOS 15.0, *)
struct StreakDisplay_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StreakDisplay(currentStreak: 12, bestStreak: 18, isActiveToday: true)
                .padding()
                .previewLayout(.sizeThatFits)
            
            StreakDisplay(currentStreak: 5, bestStreak: 7)
                .padding()
                .background(Color.black)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
