import SwiftUI

// MARK: - Spacing System with Dynamic Type Support
public extension CGFloat {
    static let queChoisir = QueChoisirSpacing()
}

public struct QueChoisirSpacing: Sendable {
    
    // MARK: - Base Spacing Scale (8pt grid system)
    public let xxxs: CGFloat = 2
    public let xxs: CGFloat = 4
    public let xs: CGFloat = 8
    public let sm: CGFloat = 12
    public let md: CGFloat = 16
    public let lg: CGFloat = 24
    public let xl: CGFloat = 32
    public let xxl: CGFloat = 48
    public let xxxl: CGFloat = 64
    
    // MARK: - Semantic Spacing
    public let elementSpacing: CGFloat = 8      // Between related elements
    public let componentSpacing: CGFloat = 16   // Between components
    public let sectionSpacing: CGFloat = 24     // Between sections
    public let screenPadding: CGFloat = 16      // Screen edge padding
    
    // MARK: - Content Spacing
    public let contentPadding: CGFloat = 16
    public let cardPadding: CGFloat = 16
    public let buttonSpacing: CGFloat = 12
    public let listItemSpacing: CGFloat = 8
    
    // MARK: - Accessibility Minimum Tap Targets
    public let minimumTapTarget: CGFloat = 44
    public let recommendedTapTarget: CGFloat = 48
    public let largeTapTarget: CGFloat = 56
    
    internal init() {}
}

// MARK: - Dynamic Spacing View Modifiers
public extension View {
    
    /// Applies dynamic padding that scales with accessibility settings
    func dynamicPadding(_ edges: Edge.Set = .all, _ length: CGFloat) -> some View {
        self.modifier(DynamicPaddingModifier(edges: edges, length: length))
    }
    
    /// Applies screen-level padding
    func screenPadding() -> some View {
        self.padding(.horizontal, .queChoisir.screenPadding)
    }
    
    /// Applies content-level padding
    func contentPadding() -> some View {
        self.padding(.queChoisir.contentPadding)
    }
    
    /// Applies card-style padding
    func cardPadding() -> some View {
        self.padding(.queChoisir.cardPadding)
    }
}

// MARK: - Dynamic Padding Modifier
private struct DynamicPaddingModifier: ViewModifier {
    let edges: Edge.Set
    @ScaledMetric var length: CGFloat
    
    init(edges: Edge.Set, length: CGFloat) {
        self.edges = edges
        self._length = ScaledMetric(wrappedValue: length)
    }
    
    func body(content: Content) -> some View {
        content.padding(edges, length)
    }
}

// MARK: - Spacer Variants
public struct QueChoisirSpacer: View {
    let size: SpacerSize
    let axis: Axis
    
    public init(size: SpacerSize = .medium, axis: Axis = .vertical) {
        self.size = size
        self.axis = axis
    }
    
    public var body: some View {
        Group {
            switch axis {
            case .vertical:
                Spacer()
                    .frame(height: heightForSize(size))
            case .horizontal:
                Spacer()
                    .frame(width: widthForSize(size))
            }
        }
    }
    
    private func heightForSize(_ size: SpacerSize) -> CGFloat {
        switch size {
        case .xs: return .queChoisir.xs
        case .small: return .queChoisir.sm
        case .medium: return .queChoisir.md
        case .large: return .queChoisir.lg
        case .xl: return .queChoisir.xl
        }
    }
    
    private func widthForSize(_ size: SpacerSize) -> CGFloat {
        switch size {
        case .xs: return .queChoisir.xs
        case .small: return .queChoisir.sm
        case .medium: return .queChoisir.md
        case .large: return .queChoisir.lg
        case .xl: return .queChoisir.xl
        }
    }
}

public enum SpacerSize: Sendable {
    case xs
    case small
    case medium
    case large
    case xl
}

public enum Axis: Sendable {
    case horizontal
    case vertical
}

// MARK: - Layout Helpers
public extension View {
    
    /// Ensures minimum tap target size for accessibility
    func minimumTapTarget() -> some View {
        self.frame(minWidth: .queChoisir.minimumTapTarget, minHeight: .queChoisir.minimumTapTarget)
    }
    
    /// Applies recommended tap target size
    func recommendedTapTarget() -> some View {
        self.frame(minWidth: .queChoisir.recommendedTapTarget, minHeight: .queChoisir.recommendedTapTarget)
    }
    
    /// Creates consistent spacing between elements
    func elementSpacing() -> some View {
        self.padding(.bottom, .queChoisir.elementSpacing)
    }
    
    /// Creates consistent spacing between components
    func componentSpacing() -> some View {
        self.padding(.bottom, .queChoisir.componentSpacing)
    }
    
    /// Creates consistent spacing between sections
    func sectionSpacing() -> some View {
        self.padding(.bottom, .queChoisir.sectionSpacing)
    }
}