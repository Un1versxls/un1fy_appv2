//
//  PlanCard.swift
//  DRIVE
//
//  Created by Kilo on 07/04/2026.
//

import SwiftUI

@available(iOS 15.0, *)
public struct PlanCard: View {
    public let title: String
    public let subtitle: String
    public let price: String
    public let features: [String]
    public let isRecommended: Bool
    public let isSelected: Bool
    public let action: () -> Void
    
    public init(
        title: String,
        subtitle: String,
        price: String,
        features: [String],
        isRecommended: Bool = false,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.features = features
        self.isRecommended = isRecommended
        self.isSelected = isSelected
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: Theme.Spacing.xxSmall) {
                        Text(title)
                            .font(Theme.Typography.title3)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        Text(subtitle)
                            .font(Theme.Typography.footnote)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text(price)
                        .font(Theme.Typography.title2)
                        .foregroundColor(Theme.Colors.primaryLight)
                }
                
                // Recommended Badge
                if isRecommended {
                    Text("RECOMMENDED")
                        .font(Theme.Typography.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, Theme.Spacing.xSmall)
                        .padding(.vertical, 4)
                        .background(
                            LinearGradient(
                                colors: Theme.Colors.primaryGradient,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(Theme.CornerRadius.small)
                }
                
                // Features list
                VStack(alignment: .leading, spacing: Theme.Spacing.xSmall) {
                    ForEach(features, id: \.self) { feature in
                        HStack(spacing: Theme.Spacing.xSmall) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Theme.Colors.success)
                                .font(.system(size: 14))
                            
                            Text(feature)
                                .font(Theme.Typography.callout)
                                .foregroundColor(Theme.Colors.textPrimary)
                        }
                    }
                }
            }
            .padding(Theme.Spacing.large)
            .background(Theme.Colors.secondaryBackground)
            .cornerRadius(Theme.CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .stroke(isSelected ? Theme.Colors.primaryLight : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(Theme.Animation.standard, value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) plan, \(price). \(isRecommended ? "Recommended option" : "")")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

@available(iOS 15.0, *)
struct PlanCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.medium) {
                PlanCard(
                    title: "Basic",
                    subtitle: "For new drivers",
                    price: "$9.99/mo",
                    features: ["10 practice lessons", "Progress tracking", "Community support"],
                    action: {}
                )
                
                PlanCard(
                    title: "Pro",
                    subtitle: "Complete training",
                    price: "$19.99/mo",
                    features: ["Unlimited lessons", "Personal coach", "Simulation exams", "Priority support"],
                    isRecommended: true,
                    isSelected: true,
                    action: {}
                )
                
                PlanCard(
                    title: "Premium",
                    subtitle: "Ultimate experience",
                    price: "$29.99/mo",
                    features: ["Everything in Pro", "1-on-1 instructor calls", "Advanced analytics", "Offline access"],
                    action: {}
                )
            }
            .padding()
        }
        .previewDisplayName("Plans Light")
        
        ScrollView {
            VStack(spacing: Theme.Spacing.medium) {
                PlanCard(
                    title: "Pro Plan",
                    subtitle: "Complete training",
                    price: "$19.99/mo",
                    features: ["Unlimited lessons", "Personal coach", "Simulation exams"],
                    isRecommended: true,
                    action: {}
                )
            }
            .padding()
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
        .previewDisplayName("Plans Dark")
    }
}
