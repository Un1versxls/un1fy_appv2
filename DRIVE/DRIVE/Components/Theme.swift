//
//  Theme.swift
//  DRIVE
//
//  Created by Kilo on 07/04/2026.
//

import SwiftUI

// MARK: - Color Theme
@available(iOS 15.0, *)
public enum Theme {
    // MARK: - Color Palette
    public enum Colors {
        // Primary Colors
        public static let primaryLight = Color(red: 0.38, green: 0.25, blue: 0.93)
        public static let primaryDark = Color(red: 0.57, green: 0.46, blue: 0.97)
        public static let primaryGradient = [primaryLight, primaryDark]
        
        // Secondary Colors
        public static let accent = Color(red: 0.99, green: 0.41, blue: 0.07)
        public static let accentLight = Color(red: 1.0, green: 0.68, blue: 0.32)
        
        // Neutral Colors
        public static let background = Color(UIColor.systemBackground)
        public static let secondaryBackground = Color(UIColor.secondarySystemBackground)
        public static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
        
        public static let textPrimary = Color(UIColor.label)
        public static let textSecondary = Color(UIColor.secondaryLabel)
        public static let textTertiary = Color(UIColor.tertiaryLabel)
        
        public static let border = Color(UIColor.separator)
        
        // Semantic Colors
        public static let success = Color(red: 0.20, green: 0.78, blue: 0.35)
        public static let warning = Color(red: 0.95, green: 0.74, blue: 0.0)
        public static let error = Color(red: 0.91, green: 0.26, blue: 0.22)
        public static let info = Color(red: 0.0, green: 0.48, blue: 1.0)
        
        // Shades
        public static let gray100 = Color(white: 0.95)
        public static let gray200 = Color(white: 0.90)
        public static let gray300 = Color(white: 0.82)
        public static let gray400 = Color(white: 0.70)
        public static let gray500 = Color(white: 0.55)
        public static let gray600 = Color(white: 0.40)
        public static let gray700 = Color(white: 0.27)
        public static let gray800 = Color(white: 0.17)
        public static let gray900 = Color(white: 0.08)
    }
    
    // MARK: - Typography
    public enum Typography {
        // Display
        public static let largeTitle = Font.system(size: 34, weight: .bold, design: .default)
        public static let title1 = Font.system(size: 28, weight: .bold, design: .default)
        public static let title2 = Font.system(size: 22, weight: .semibold, design: .default)
        public static let title3 = Font.system(size: 20, weight: .semibold, design: .default)
        
        // Body
        public static let headline = Font.system(size: 17, weight: .semibold, design: .default)
        public static let body = Font.system(size: 17, weight: .regular, design: .default)
        public static let callout = Font.system(size: 16, weight: .regular, design: .default)
        public static let subheadline = Font.system(size: 15, weight: .medium, design: .default)
        
        // Caption
        public static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        public static let caption1 = Font.system(size: 12, weight: .regular, design: .default)
        public static let caption2 = Font.system(size: 11, weight: .medium, design: .default)
    }
    
    // MARK: - Spacing
    public enum Spacing {
        public static let xxSmall: CGFloat = 4
        public static let xSmall: CGFloat = 8
        public static let small: CGFloat = 12
        public static let medium: CGFloat = 16
        public static let large: CGFloat = 20
        public static let xLarge: CGFloat = 24
        public static let xxLarge: CGFloat = 32
        public static let xxxLarge: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    public enum CornerRadius {
        public static let small: CGFloat = 6
        public static let medium: CGFloat = 10
        public static let large: CGFloat = 16
        public static let extraLarge: CGFloat = 24
        public static let full: CGFloat = .infinity
    }
    
    // MARK: - Animation
    public enum Animation {
        public static let fast = SwiftUI.Animation.easeOut(duration: 0.15)
        public static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        public static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
        public static let bounce = SwiftUI.Animation.interpolatingSpring(stiffness: 300, damping: 15)
    }
}

// MARK: - View Modifiers
@available(iOS 15.0, *)
public extension View {
    func cardStyle() -> some View {
        self
            .background(Theme.Colors.secondaryBackground)
            .cornerRadius(Theme.CornerRadius.large)
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
    
    func standardPadding() -> some View {
        self.padding(Theme.Spacing.medium)
    }
    
    func fullWidth() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func centered() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
