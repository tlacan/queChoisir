import SwiftUI

// MARK: - Button Styles
public struct QueChoisirButtonStyle: ButtonStyle {
    let variant: ButtonVariant
    let size: ButtonSize

    public init(variant: ButtonVariant = .primary, size: ButtonSize = .medium) {
        self.variant = variant
        self.size = size
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(fontForSize(size))
            .foregroundColor(foregroundColor(for: variant, isPressed: configuration.isPressed))
            .padding(paddingForSize(size))
            .background(backgroundColor(for: variant, isPressed: configuration.isPressed))
            .cornerRadius(cornerRadiusForSize(size))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .dynamicTypeSize(...DynamicTypeSize.accessibility3) // Limit max size for buttons
    }

    private func fontForSize(_ size: ButtonSize) -> Font {
        switch size {
        case .small: .queChoisir.labelMedium
        case .medium: .queChoisir.labelLarge
        case .large: .queChoisir.titleMedium
        }
    }

    private func paddingForSize(_ size: ButtonSize) -> EdgeInsets {
        // Use @ScaledMetric equivalent values for accessibility
        switch size {
        case .small: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        case .medium: EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
        case .large: EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
        }
    }

    private func cornerRadiusForSize(_ size: ButtonSize) -> CGFloat {
        switch size {
        case .small: 8
        case .medium: 10
        case .large: 12
        }
    }

    private func backgroundColor(for variant: ButtonVariant, isPressed: Bool) -> Color {
        let baseColor: Color =
            switch variant {
            case .primary: .queChoisir.buttonPrimary
            case .secondary: .queChoisir.buttonSecondary
            case .destructive: .queChoisir.buttonDestructive
            case .ghost: .clear
            }
        return isPressed ? baseColor.opacity(0.8) : baseColor
    }

    private func foregroundColor(for variant: ButtonVariant, isPressed: Bool) -> Color {
        switch variant {
        case .primary, .destructive: .white
        case .secondary: .queChoisir.text
        case .ghost: .queChoisir.primary
        }
    }
}

public enum ButtonVariant: Sendable {
    case primary
    case secondary
    case destructive
    case ghost
}

public enum ButtonSize: Sendable {
    case small
    case medium
    case large
}

// MARK: - Button Extensions
public extension Button {
    @MainActor
    func queChoisirStyle(
        variant: ButtonVariant = .primary,
        size: ButtonSize = .medium
    ) -> some View {
        self.buttonStyle(QueChoisirButtonStyle(variant: variant, size: size))
    }
}

// MARK: - Predefined Buttons with Accessibility Support
public struct QueChoisirButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let variant: ButtonVariant
    let size: ButtonSize
    let isDisabled: Bool
    let accessibilityLabel: String?
    let accessibilityHint: String?

    @ScaledMetric private var minHeight: CGFloat
    @ScaledMetric private var iconSize: CGFloat

    public init(
        _ title: String,
        icon: String? = nil,
        variant: ButtonVariant = .primary,
        size: ButtonSize = .medium,
        isDisabled: Bool = false,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.variant = variant
        self.size = size
        self.isDisabled = isDisabled
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.action = action

        // Set minimum height based on button size for accessibility (44pt minimum)
        let baseHeight: CGFloat =
            switch size {
            case .small: 44 // Always meet 44pt minimum for accessibility
            case .medium: 48
            case .large: 56
            }
        self._minHeight = ScaledMetric(wrappedValue: baseHeight)

        // Set icon size with dynamic scaling
        let baseIconSize: CGFloat =
            switch size {
            case .small: 16
            case .medium: 18
            case .large: 20
            }
        self._iconSize = ScaledMetric(wrappedValue: baseIconSize)
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: iconSize, weight: .medium))
                        .accessibilityHidden(true) // Hide icon from accessibility, text provides context
                }

                Text(title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8) // Allow slight scaling for long text
            }
        }
        .queChoisirStyle(variant: variant, size: size)
        .frame(minHeight: minHeight)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1.0)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel ?? title)
        .accessibilityHint(accessibilityHint ?? defaultAccessibilityHint)
        .accessibilityAddTraits(accessibilityTraits)
    }

    private var defaultAccessibilityHint: String {
        switch variant {
        case .primary: "Double tap to perform primary action"
        case .secondary: "Double tap to perform secondary action"
        case .destructive: "Double tap to perform destructive action"
        case .ghost: "Double tap to activate"
        }
    }

    private var accessibilityTraits: AccessibilityTraits {
        var traits: AccessibilityTraits = .isButton

        switch variant {
        case .destructive:
            _ = traits.insert(.allowsDirectInteraction)
        default:
            break
        }

        return traits
    }
}

// MARK: - Icon-Only Button with Accessibility Support
public struct QueChoisirIconButton: View {
    let icon: String
    let action: () -> Void
    let variant: ButtonVariant
    let size: ButtonSize
    let isDisabled: Bool
    let accessibilityLabel: String
    let accessibilityHint: String?

    @ScaledMetric private var iconSize: CGFloat
    @ScaledMetric private var minTapTarget: CGFloat = 44 // Always meet 44pt minimum

    public init(
        icon: String,
        variant: ButtonVariant = .primary,
        size: ButtonSize = .medium,
        isDisabled: Bool = false,
        accessibilityLabel: String,
        accessibilityHint: String? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.variant = variant
        self.size = size
        self.isDisabled = isDisabled
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.action = action

        // Set icon size based on button size with dynamic scaling
        let baseIconSize: CGFloat =
            switch size {
            case .small: 18
            case .medium: 20
            case .large: 24
            }
        self._iconSize = ScaledMetric(wrappedValue: baseIconSize)
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: iconSize, weight: .medium))
                .frame(minWidth: minTapTarget, minHeight: minTapTarget)
                .contentShape(Rectangle()) // Ensure entire frame is tappable
        }
        .queChoisirStyle(variant: variant, size: size)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1.0)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint ?? "Double tap to activate")
        .accessibility(addTraits: .isButton)
        //.accessibilityTraits(isDisabled ? [.button, .notEnabled] : .button)
        // Add role description for screen readers
        .accessibilityAddTraits(.allowsDirectInteraction)
    }
}

// MARK: - Floating Action Button with Accessibility
public struct QueChoisirFloatingActionButton: View {
    let icon: String
    let action: () -> Void
    let isDisabled: Bool
    let accessibilityLabel: String
    let accessibilityHint: String?

    @ScaledMetric private var size: CGFloat = 56
    @ScaledMetric private var iconSize: CGFloat = 24

    public init(
        icon: String,
        isDisabled: Bool = false,
        accessibilityLabel: String,
        accessibilityHint: String? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.isDisabled = isDisabled
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: iconSize, weight: .medium))
                .foregroundColor(.white)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(Color.queChoisir.primary)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                )
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1.0)
        .scaleEffect(isDisabled ? 0.9 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isDisabled)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint ?? "Double tap to perform floating action")
        .accessibility(addTraits: .isButton)
        //.accessibilityTraits(isDisabled ? [.button, .notEnabled] : .button)
        // Add role description for screen readers
        .accessibilityAddTraits(.allowsDirectInteraction)
    }
}
