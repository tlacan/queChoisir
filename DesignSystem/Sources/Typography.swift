import SwiftUI

public extension Font {
    static let queChoisir = QueChoisirTypography()
}

public struct QueChoisirTypography: Sendable {
    
    // MARK: - Display (with Dynamic Type support)
    public let displayLarge = Font.custom("", size: 57, relativeTo: .largeTitle).weight(.regular)
    public let displayMedium = Font.custom("", size: 45, relativeTo: .largeTitle).weight(.regular)
    public let displaySmall = Font.custom("", size: 36, relativeTo: .largeTitle).weight(.regular)
    
    // MARK: - Headline (with Dynamic Type support)
    public let headlineLarge = Font.custom("", size: 32, relativeTo: .title).weight(.regular)
    public let headlineMedium = Font.custom("", size: 28, relativeTo: .title2).weight(.regular)
    public let headlineSmall = Font.custom("", size: 24, relativeTo: .title3).weight(.regular)
    
    // MARK: - Title (with Dynamic Type support)
    public let titleLarge = Font.custom("", size: 22, relativeTo: .headline).weight(.regular)
    public let titleMedium = Font.custom("", size: 16, relativeTo: .headline).weight(.medium)
    public let titleSmall = Font.custom("", size: 14, relativeTo: .subheadline).weight(.medium)
    
    // MARK: - Label (with Dynamic Type support)
    public let labelLarge = Font.custom("", size: 14, relativeTo: .footnote).weight(.medium)
    public let labelMedium = Font.custom("", size: 12, relativeTo: .caption).weight(.medium)
    public let labelSmall = Font.custom("", size: 11, relativeTo: .caption2).weight(.medium)
    
    // MARK: - Body (with Dynamic Type support)
    public let bodyLarge = Font.custom("", size: 16, relativeTo: .body).weight(.regular)
    public let bodyMedium = Font.custom("", size: 14, relativeTo: .callout).weight(.regular)
    public let bodySmall = Font.custom("", size: 12, relativeTo: .footnote).weight(.regular)
    
    // MARK: - Score Typography (with Dynamic Type support)
    public let scoreTitle = Font.custom("", size: 24, relativeTo: .title2).weight(.bold).monospacedDigit()
    public let scoreSubtitle = Font.custom("", size: 12, relativeTo: .caption).weight(.medium)
    
    // MARK: - Product Typography (with Dynamic Type support)
    public let productTitle = Font.custom("", size: 18, relativeTo: .headline).weight(.semibold)
    public let productPrice = Font.custom("", size: 16, relativeTo: .subheadline).weight(.medium).monospacedDigit()
    public let productDescription = Font.custom("", size: 14, relativeTo: .body).weight(.regular)
    
    // MARK: - System Fonts with Dynamic Type
    public let largeTitle = Font.largeTitle
    public let title = Font.title
    public let title2 = Font.title2
    public let title3 = Font.title3
    public let headline = Font.headline
    public let body = Font.body
    public let callout = Font.callout
    public let subheadline = Font.subheadline
    public let footnote = Font.footnote
    public let caption = Font.caption
    public let caption2 = Font.caption2
    
    internal init() {}
}

// MARK: - Text Styles
public extension Text {
    func queChoisirStyle(_ style: QueChoisirTextStyle) -> some View {
        self.modifier(QueChoisirTextModifier(style: style))
    }
}

public enum QueChoisirTextStyle: Sendable {
    case displayLarge
    case displayMedium
    case displaySmall
    case headlineLarge
    case headlineMedium
    case headlineSmall
    case titleLarge
    case titleMedium
    case titleSmall
    case labelLarge
    case labelMedium
    case labelSmall
    case bodyLarge
    case bodyMedium
    case bodySmall
    case scoreTitle
    case scoreSubtitle
    case productTitle
    case productPrice
    case productDescription
}

private struct QueChoisirTextModifier: ViewModifier {
    let style: QueChoisirTextStyle
    
    func body(content: Content) -> some View {
        content
            .font(fontForStyle(style))
            .foregroundColor(colorForStyle(style))
    }
    
    private func fontForStyle(_ style: QueChoisirTextStyle) -> Font {
        switch style {
        case .displayLarge: return .queChoisir.displayLarge
        case .displayMedium: return .queChoisir.displayMedium
        case .displaySmall: return .queChoisir.displaySmall
        case .headlineLarge: return .queChoisir.headlineLarge
        case .headlineMedium: return .queChoisir.headlineMedium
        case .headlineSmall: return .queChoisir.headlineSmall
        case .titleLarge: return .queChoisir.titleLarge
        case .titleMedium: return .queChoisir.titleMedium
        case .titleSmall: return .queChoisir.titleSmall
        case .labelLarge: return .queChoisir.labelLarge
        case .labelMedium: return .queChoisir.labelMedium
        case .labelSmall: return .queChoisir.labelSmall
        case .bodyLarge: return .queChoisir.bodyLarge
        case .bodyMedium: return .queChoisir.bodyMedium
        case .bodySmall: return .queChoisir.bodySmall
        case .scoreTitle: return .queChoisir.scoreTitle
        case .scoreSubtitle: return .queChoisir.scoreSubtitle
        case .productTitle: return .queChoisir.productTitle
        case .productPrice: return .queChoisir.productPrice
        case .productDescription: return .queChoisir.productDescription
        }
    }
    
    private func colorForStyle(_ style: QueChoisirTextStyle) -> Color {
        switch style {
        case .displayLarge, .displayMedium, .displaySmall,
             .headlineLarge, .headlineMedium, .headlineSmall,
             .titleLarge, .titleMedium, .titleSmall,
             .bodyLarge, .bodyMedium, .bodySmall,
             .scoreTitle, .productTitle, .productPrice:
            return .queChoisir.text
        case .labelLarge, .labelMedium, .labelSmall,
             .scoreSubtitle, .productDescription:
            return .queChoisir.secondaryText
        }
    }
}