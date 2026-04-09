//
//  TaskCard.swift
//  DRIVE
//
//  Created by Kilo on 07/04/2026.
//

import SwiftUI

@available(iOS 15.0, *)
public struct TaskCard: View {
    public let title: String
    public let description: String
    public let iconName: String
    public let isCompleted: Bool
    public let progress: Double
    public let action: () -> Void
    
    public init(
        title: String,
        description: String,
        iconName: String,
        isCompleted: Bool = false,
        progress: Double = 0.0,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.description = description
        self.iconName = iconName
        self.isCompleted = isCompleted
        self.progress = progress
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.medium) {
                // Icon
                ZStack {
                    Circle()
                        .fill(isCompleted ? Theme.Colors.success : Theme.Colors.gray200)
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isCompleted ? .white : Theme.Colors.gray700)
                }
                
                // Content
                VStack(alignment: .leading, spacing: Theme.Spacing.xxSmall) {
                    Text(title)
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .strikethrough(isCompleted)
                    
                    Text(description)
                        .font(Theme.Typography.footnote)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .lineLimit(2)
                    
                    if progress > 0 && !isCompleted {
                        ProgressView(value: progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: Theme.Colors.primaryLight))
                            .padding(.top, 2)
                    }
                }
                
                Spacer()
                
                // Completion indicator
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isCompleted ? Theme.Colors.success : Theme.Colors.textTertiary)
            }
            .padding(Theme.Spacing.medium)
            .background(Theme.Colors.secondaryBackground)
            .cornerRadius(Theme.CornerRadius.large)
            .opacity(isCompleted ? 0.7 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(isCompleted ? "completed" : "incomplete")")
        .accessibilityHint("Double tap to view task")
    }
}

@available(iOS 15.0, *)
struct TaskCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Theme.Spacing.medium) {
            TaskCard(
                title: "Morning Drive Session",
                description: "Complete 30 minutes of focused practice",
                iconName: "sun.max.fill",
                action: {}
            )
            
            TaskCard(
                title: "Night Navigation Challenge",
                description: "Master highway exit maneuvers",
                iconName: "moon.stars.fill",
                progress: 0.65,
                action: {}
            )
            
            TaskCard(
                title: "Emergency Stop Drill",
                description: "Perfect braking technique",
                iconName: "exclamationmark.shield.fill",
                isCompleted: true,
                action: {}
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
        
        VStack(spacing: Theme.Spacing.medium) {
            TaskCard(
                title: "Completed Task Example",
                description: "This task is marked finished",
                iconName: "checkmark",
                isCompleted: true,
                action: {}
            )
        }
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
}
