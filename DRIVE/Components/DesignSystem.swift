import SwiftUI

// MARK: - Spacing Constants
enum DriveSpacing {
    static let xxs: CGFloat  = 2
    static let xs: CGFloat   = 4
    static let sm: CGFloat   = 8
    static let md: CGFloat   = 12
    static let base: CGFloat = 16
    static let lg: CGFloat   = 20
    static let xl: CGFloat   = 24
    static let xxl: CGFloat  = 32
    static let xxxl: CGFloat = 48
    static let huge: CGFloat  = 64
    static let none: CGFloat  = 0
}

// MARK: - Corner Radius Constants
enum DriveRadius {
    static let xs: CGFloat   = 4
    static let sm: CGFloat   = 8
    static let md: CGFloat   = 12
    static let lg: CGFloat   = 16
    static let xl: CGFloat   = 24
    static let pill: CGFloat = 100
}

// MARK: - Animation Constants
enum DriveAnimations {
    static let fast     = Animation.easeOut(duration: 0.15)
    static let standard = Animation.easeInOut(duration: 0.3)
    static let slow     = Animation.easeInOut(duration: 0.5)
    static let bounce   = Animation.interpolatingSpring(stiffness: 300, damping: 15)
    static let pulse    = Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)
}

// MARK: - Color Extensions
extension Color {
    // Primary
    static let drivePrimary        = Color(red: 0.38, green: 0.25, blue: 0.93)
    static let drivePrimaryDark    = Color(red: 0.57, green: 0.46, blue: 0.97)

    // Accent
    static let drivePurple         = Color(red: 0.57, green: 0.46, blue: 0.97)
    static let driveBlue           = Color(red: 0.0,  green: 0.48, blue: 1.0)
    static let driveCyan           = Color(red: 0.20, green: 0.80, blue: 0.95)

    // Semantic
    static let driveSuccess        = Color(red: 0.20, green: 0.78, blue: 0.35)
    static let driveWarning        = Color(red: 0.95, green: 0.74, blue: 0.0)
    static let driveError          = Color(red: 0.91, green: 0.26, blue: 0.22)
    static let driveInfo           = Color(red: 0.0,  green: 0.48, blue: 1.0)

    // Pink accent
    static let drivePink           = Color(red: 0.96, green: 0.36, blue: 0.58)

    // Backgrounds
    static let driveBackground      = Color(UIColor.systemBackground)
    static let driveSurface         = Color(UIColor.secondarySystemBackground)
    static let driveSurfaceElevated = Color(UIColor.tertiarySystemBackground)
    static let driveGlassBorder     = Color.white.opacity(0.12)
    static let driveGlassBackground = Color.white.opacity(0.08)

    // Text
    static let driveTextPrimary    = Color(UIColor.label)
    static let driveTextSecondary  = Color(UIColor.secondaryLabel)
    static let driveTextTertiary   = Color(UIColor.tertiaryLabel)

    // Hex initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red:     Double(r) / 255,
            green:   Double(g) / 255,
            blue:    Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - LinearGradient Extensions
extension LinearGradient {
    /// Purple → blue gradient used throughout the Drive design.
    static let drivePrimary = LinearGradient(
        colors: [Color.drivePrimary, Color.drivePurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Soft glow gradient (used as background bloom).
    static let driveGlow = LinearGradient(
        colors: [Color.drivePurple.opacity(0.6), Color.driveBlue.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// A fully-transparent gradient used as a no-op fill.
    static let clear = LinearGradient(
        colors: [Color.clear, Color.clear],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - ShapeStyle Convenience
// Provide `.drivePrimary` and `.drivePurple` as ShapeStyle shortcuts so views
// can write `.fill(.drivePrimary)` without specifying `Color.` or `LinearGradient.`.
extension ShapeStyle where Self == Color {
    static var drivePrimary: Color { .drivePrimary }
    static var drivePurple:  Color { .drivePurple  }
    static var drivePink:    Color { .drivePink    }
}

// MARK: - Font Extensions
extension Font {
    static let driveLargeTitle  = Font.system(size: 34, weight: .bold)
    static let driveTitle1      = Font.system(size: 28, weight: .bold)
    static let driveTitle2      = Font.system(size: 22, weight: .semibold)
    static let driveTitle3      = Font.system(size: 20, weight: .semibold)
    static let driveHeadline    = Font.system(size: 17, weight: .semibold)
    static let driveBody        = Font.system(size: 17, weight: .regular)
    static let driveCallout     = Font.system(size: 16, weight: .regular)
    static let driveSubheadline = Font.system(size: 15, weight: .medium)
    static let driveFootnote    = Font.system(size: 13, weight: .regular)
    static let driveCaption     = Font.system(size: 12, weight: .regular)
    static let driveCaption2    = Font.system(size: 11, weight: .medium)
}

// MARK: - GlassMorphism Modifier
struct GlassMorphismModifier: ViewModifier {
    let backgroundOpacity: Double
    let borderOpacity: Double
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white.opacity(backgroundOpacity))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(Color.white.opacity(borderOpacity), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}

extension View {
    func glassMorphism(
        backgroundOpacity: Double = 0.04,
        borderOpacity: Double    = 0.12,
        cornerRadius: CGFloat    = DriveRadius.lg
    ) -> some View {
        modifier(GlassMorphismModifier(
            backgroundOpacity: backgroundOpacity,
            borderOpacity: borderOpacity,
            cornerRadius: cornerRadius
        ))
    }
}

// MARK: - GradientText Modifier
/// Overlays a gradient as the foreground colour of any view (typically `Text`).
struct GradientTextModifier: ViewModifier {
    let gradient: LinearGradient

    func body(content: Content) -> some View {
        content
            .overlay(
                gradient
                    .mask(content)
            )
    }
}

extension View {
    /// Apply a `LinearGradient` as the text/foreground fill.
    func gradientText(_ gradient: LinearGradient) -> some View {
        modifier(GradientTextModifier(gradient: gradient))
    }
}

// MARK: - Glow Modifier
struct GlowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    let intensity: Double

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(intensity), radius: radius)
            .shadow(color: color.opacity(intensity * 0.5), radius: radius * 0.5)
    }
}

extension View {
    func glow(color: Color, radius: CGFloat = 8, intensity: Double = 0.5) -> some View {
        modifier(GlowModifier(color: color, radius: radius, intensity: intensity))
    }
}

// MARK: - GradientOutlineButton
struct GradientOutlineButton: View {
    let title: String
    let action: () -> Void

    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.driveHeadline)
                .foregroundColor(.drivePrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .overlay(
                    RoundedRectangle(cornerRadius: DriveRadius.md)
                        .strokeBorder(Color.drivePrimary, lineWidth: 1.5)
                )
        }
    }
}
