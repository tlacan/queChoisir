import SwiftUI

public extension Color {
  static let queChoisir = QueChoisirColors()
}

public struct QueChoisirColors: Sendable {
    
    // MARK: - Brand Colors
    public let primary = Color(red: 0.0, green: 0.5, blue: 1.0) // Blue
    public let secondary = Color(red: 0.2, green: 0.8, blue: 0.4) // Green
    public let accent = Color(red: 1.0, green: 0.6, blue: 0.0) // Orange
    
    // MARK: - Semantic Colors
    public let success = Color.green
    public let warning = Color.orange
    public let error = Color.red
    public let info = Color.blue
    
    // MARK: - Neutral Colors
    public let background = Color(.systemBackground)
    public let secondaryBackground = Color(.secondarySystemBackground)
    public let tertiaryBackground = Color(.tertiarySystemBackground)
    
    public let text = Color(.label)
    public let secondaryText = Color(.secondaryLabel)
    public let tertiaryText = Color(.tertiaryLabel)
    
    public let separator = Color(.separator)
    
    // MARK: - Score Colors
    public func scoreColor(for score: Int) -> Color {
        switch score {
        case 80...100:
            return success
        case 60...79:
            return warning
        case 40...59:
            return accent
        default:
            return error
        }
    }
    
    // MARK: - Component Colors
    public let cardBackground = Color(.secondarySystemBackground)
    public let cardBorder = Color(.separator)
    
    public let buttonPrimary = Color(red: 0.0, green: 0.5, blue: 1.0)
    public let buttonSecondary = Color(.systemGray3)
    public let buttonDestructive = Color.red
    
    internal init() {}
}
