//
//  GradientButton.swift
//  DRIVE
//
//  Created by Kilo on 07/04/2026.
//

import SwiftUI

@available(iOS 15.0, *)
public struct GradientButton: View {
    public enum Style {
        case primary
        case secondary
        case outline
    }
    
    public let title: String
    public let style: Style
    public let isLoading: Bool
    public let action: () -> Void
    
    @State private var isPressed: Bool = false
    
    public init(
        title: String,
        style: Style = .primary,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isLoading = isLoading
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            withAnimation(Theme.Animation.fast) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
            action()
        }) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .scaleEffect(1.0)
                } else {
                    Text(title)
                        .font(Theme.Typography.headline)
                        .foregroundColor(foregroundColor)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(backgroundContent)
            .cornerRadius(Theme.CornerRadius.medium)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .opacity(isPressed ? 0.9 : 1.0)
            .animation(Theme.Animation.fast, value: isPressed)
        }
        .disabled(isLoading)
        .accessibilityLabel(title)
        .accessibilityHint("Button")
        .accessibilityAddTraits(.isButton)
    }
    
    @ViewBuilder
    private var backgroundContent: some View {
        switch style {
        case .primary:
            LinearGradient(
                colors: Theme.Colors.primaryGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
        case .secondary:
            Theme.Colors.secondaryBackground
            
        case .outline:
            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                .stroke(Theme.Colors.primaryLight, lineWidth: 1.5)
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary: .white
        case .secondary: Theme.Colors.textPrimary
        case .outline: Theme.Colors.primaryLight
        }
    }
}

@available(iOS 15.0, *)
struct GradientButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Theme.Spacing.medium) {
            GradientButton(title: "Primary Button", action: {})
            GradientButton(title: "Secondary Button", style: .secondary, action: {})
            GradientButton(title: "Outline Button", style: .outline, action: {})
            GradientButton(title: "Loading", isLoading: true, action: {})
        }
        .padding()
        .previewLayout(.sizeThatFits)
        
        VStack(spacing: Theme.Spacing.medium) {
            GradientButton(title: "Primary Button", action: {})
            GradientButton(title: "Secondary Button", style: .secondary, action: {})
            GradientButton(title: "Outline Button", style: .outline, action: {})
        }
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
}
