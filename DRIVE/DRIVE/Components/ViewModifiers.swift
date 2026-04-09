//
//  ViewModifiers.swift
//  DRIVE
//
//  Created by Kilo on 07/04/2026.
//

import SwiftUI

// MARK: - Pressable Button Style
@available(iOS 15.0, *)
public struct PressableButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(Theme.Animation.fast, value: configuration.isPressed)
    }
}

// MARK: - Card Shadow Modifier
@available(iOS 15.0, *)
public struct CardShadow: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 6)
            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Hidden Accessibility Label
@available(iOS 15.0, *)
public struct AccessibleHidden: ViewModifier {
    private let label: String
    
    public init(label: String) {
        self.label = label
    }
    
    public func body(content: Content) -> some View {
        content
            .accessibilityLabel(label)
            .accessibility(hidden: false)
    }
}

// MARK: - Haptic Feedback on Tap
@available(iOS 15.0, *)
public struct HapticTap: ViewModifier {
    private let style: UIImpactFeedbackGenerator.FeedbackStyle
    
    public init(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        self.style = style
    }
    
    public func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIImpactFeedbackGenerator(style: style).impactOccurred()
            }
    }
}

// MARK: - View Extension Helpers
@available(iOS 15.0, *)
public extension View {
    func cardShadow() -> some View {
        self.modifier(CardShadow())
    }
    
    func pressableStyle() -> some View {
        self.buttonStyle(PressableButtonStyle())
    }
    
    func hapticOnTap(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) -> some View {
        self.modifier(HapticTap(style: style))
    }
    
    func hiddenAccessibility(label: String) -> some View {
        self.modifier(AccessibleHidden(label: label))
    }
    
    func animateForever(using animation: Animation = Theme.Animation.standard, autoreverses: Bool = true, _ action: @escaping () -> Void) -> some View {
        self.onAppear {
            withAnimation(animation.repeatForever(autoreverses: autoreverses)) {
                action()
            }
        }
    }
}
