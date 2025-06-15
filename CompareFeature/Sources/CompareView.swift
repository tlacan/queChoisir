import Core
import DesignSystem
import SwiftUI

public struct CompareView: View {
    @State private var viewModel = CompareViewModel()
    @State private var showingProductSelection = false

    public init() {}

    public var body: some View {
        NavigationView {
            Group {
                if viewModel.selectedProducts.isEmpty {
                    EmptyCompareView {
                        showingProductSelection = true
                    }
                } else {
                    CompareContentView(viewModel: viewModel)
                }
            }
            .navigationTitle(String(localized: "Compare"))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !viewModel.selectedProducts.isEmpty {
                        QueChoisirIconButton(
                            icon: "plus",
                            variant: .ghost,
                            isDisabled: !viewModel.canSelectMoreProducts,
                            accessibilityLabel: String(localized: "Add Product")
                        ) {
                            showingProductSelection = true
                        }
                    }

                    if !viewModel.selectedProducts.isEmpty {
                        QueChoisirIconButton(
                            icon: "trash",
                            variant: .ghost,
                            accessibilityLabel: "Clear selection"
                        ) {
                            viewModel.clearSelection()
                        }
                    }
                }
            }
            .sheet(isPresented: $showingProductSelection) {
                ProductSelectionView(viewModel: viewModel)
            }
            .alert(String(localized: "Error"), isPresented: .constant(viewModel.errorMessage != nil)) {
                QueChoisirButton(String(localized: "OK"), variant: .primary) {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
                    .queChoisirStyle(.bodyMedium)
            }
        }
    }
}

private struct EmptyCompareView: View {
    let onAddProduct: () -> Void

    var body: some View {
        VStack(spacing: .queChoisir.lg) {
            Image(systemName: "scale.3d")
                .font(.system(size: 64))
                .foregroundColor(.queChoisir.secondary)

            Text(String(localized: "Select products to compare"))
                .queChoisirStyle(.headlineSmall)
                .multilineTextAlignment(.center)

            QueChoisirButton(
                String(localized: "Add Product"),
                icon: "plus",
                variant: .primary,
                accessibilityLabel: String(localized: "Add Product")
            ) {
                onAddProduct()
            }
        }
        .screenPadding()
    }
}

private struct CompareContentView: View {
    let viewModel: CompareViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: .queChoisir.sectionSpacing) {
                // Selected Products Header
                SelectedProductsHeaderView(products: viewModel.selectedProducts)

                // Compare Button
                if !viewModel.selectedProducts.isEmpty {
                    QueChoisirButton(
                        "Analyze & Compare",
                        icon: "magnifyingglass",
                        variant: .primary,
                        isDisabled: viewModel.isLoading,
                        accessibilityLabel: "Analyze and compare selected products"
                    ) {
                        Task {
                            await viewModel.analyzeSelectedProducts()
                        }
                    }
                    .screenPadding()
                }

                // Comparison Results
                if viewModel.selectedProducts.allSatisfy({ viewModel.analyzedProducts[$0] != nil }) {
                    ComparisonResultsView(
                        products: viewModel.selectedProducts,
                        analyses: viewModel.analyzedProducts
                    )
                }
            }
            .dynamicPadding(.top, .queChoisir.sectionSpacing)
        }
    }
}

private struct SelectedProductsHeaderView: View {
    let products: [Product]

    var body: some View {
        VStack(alignment: .leading, spacing: .queChoisir.elementSpacing) {
            Text("Selected Products (\(products.count)/3)")
                .queChoisirStyle(.titleMedium)
                .screenPadding()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .queChoisir.elementSpacing) {
                    ForEach(products) { product in
                        CompactProductCardView(product: product)
                    }
                }
                .screenPadding()
            }
        }
    }
}

private struct CompactProductCardView: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: .queChoisir.xxs) {
            Text(product.name)
                .queChoisirStyle(.labelLarge)
                .lineLimit(2)

            Text("$\(product.price, specifier: "%.0f")")
                .queChoisirStyle(.labelMedium)
                .foregroundColor(.queChoisir.primary)

            Text(product.category)
                .queChoisirStyle(.labelSmall)
                .foregroundColor(.queChoisir.secondaryText)
        }
        .frame(width: 120)
        .padding(.queChoisir.sm)
        .background(Color.queChoisir.cardBackground)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

private struct ComparisonResultsView: View {
    let products: [Product]
    let analyses: [Product: ProductAnalysis]

    private let scoreCategories = [
        ("Reviews", \ProductAnalysis.reviewsScore),
        ("Repairability", \ProductAnalysis.repairabilityScore),
        ("Reputation", \ProductAnalysis.reputationScore),
        ("Consumption", \ProductAnalysis.consumptionScore),
        ("Price", \ProductAnalysis.priceScore)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: .queChoisir.componentSpacing) {
            Text("Comparison Results")
                .queChoisirStyle(.titleLarge)
                .screenPadding()

            // Overall Scores
            OverallScoresComparisonView(products: products, analyses: analyses)

            // Category Comparisons
            ForEach(scoreCategories, id: \.0) { category, keyPath in
                CategoryComparisonView(
                    title: String(localized: LocalizedStringResource(stringLiteral: category)),
                    products: products,
                    analyses: analyses,
                    scoreKeyPath: keyPath
                )
            }
        }
    }
}

private struct OverallScoresComparisonView: View {
    let products: [Product]
    let analyses: [Product: ProductAnalysis]

    var body: some View {
        VStack(alignment: .leading, spacing: .queChoisir.elementSpacing) {
            Text(String(localized: "Overall Score"))
                .queChoisirStyle(.titleMedium)
                .screenPadding()

            VStack(spacing: .queChoisir.xs) {
                ForEach(products) { product in
                    if let analysis = analyses[product] {
                        ScoreComparisonRowView(
                            productName: product.name,
                            score: analysis.overallScore,
                            isHighest: analysis.overallScore == products.compactMap { analyses[$0]?.overallScore }.max()
                        )
                    }
                }
            }
            .screenPadding()
        }
    }
}

private struct CategoryComparisonView: View {
    let title: String
    let products: [Product]
    let analyses: [Product: ProductAnalysis]
    let scoreKeyPath: KeyPath<ProductAnalysis, Int>

    var body: some View {
        VStack(alignment: .leading, spacing: .queChoisir.elementSpacing) {
            Text(title)
                .queChoisirStyle(.titleMedium)
                .screenPadding()

            VStack(spacing: .queChoisir.xs) {
                ForEach(products) { product in
                    if let analysis = analyses[product] {
                        let score = analysis[keyPath: scoreKeyPath]
                        let maxScore = products.compactMap { analyses[$0]?[keyPath: scoreKeyPath] }.max() ?? 0

                        ScoreComparisonRowView(
                            productName: product.name,
                            score: score,
                            isHighest: score == maxScore
                        )
                    }
                }
            }
            .screenPadding()
        }
    }
}

private struct ScoreComparisonRowView: View {
    let productName: String
    let score: Int
    let isHighest: Bool

    var body: some View {
        HStack {
            Text(productName)
                .queChoisirStyle(.bodyMedium)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: .queChoisir.xxs) {
                Text("\(score)")
                    .queChoisirStyle(.labelLarge)
                    .fontWeight(isHighest ? .bold : .medium)
                    .foregroundColor(.queChoisir.scoreColor(for: score))

                if isHighest {
                    Image(systemName: "crown.fill")
                        .font(.caption)
                        .foregroundColor(.queChoisir.accent)
                }
            }
        }
        .padding(.queChoisir.sm)
        .background(isHighest ? Color.queChoisir.secondary.opacity(0.1) : Color.queChoisir.tertiaryBackground)
        .cornerRadius(8)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(productName): \(score) out of 100\(isHighest ? ", highest score" : "")")
    }
}

private struct ProductSelectionView: View {
    let viewModel: CompareViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.availableProducts) { product in
                    ProductSelectionRowView(
                        product: product,
                        isSelected: viewModel.isProductSelected(product),
                        canSelect: viewModel.canSelectMoreProducts || viewModel.isProductSelected(product)
                    ) {
                        viewModel.toggleProductSelection(product)
                    }
                }
            }
            .navigationTitle("Select Products")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    QueChoisirButton("Cancel", variant: .ghost) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    QueChoisirButton("Done", variant: .primary) {
                        dismiss()
                    }
                    .disabled(viewModel.selectedProducts.isEmpty)
                }
            }
        }
    }
}

private struct ProductSelectionRowView: View {
    let product: Product
    let isSelected: Bool
    let canSelect: Bool
    let onToggle: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: .queChoisir.xxs) {
                Text(product.name)
                    .queChoisirStyle(.bodyLarge)

                Text("$\(product.price, specifier: "%.0f")")
                    .queChoisirStyle(.bodyMedium)
                    .foregroundColor(.queChoisir.primary)

                Text(product.category)
                    .queChoisirStyle(.labelSmall)
                    .foregroundColor(.queChoisir.secondaryText)
            }

            Spacer()

            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .queChoisir.primary : .queChoisir.separator)
                .font(.title3)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if canSelect {
                onToggle()
            }
        }
        .opacity(canSelect ? 1.0 : 0.5)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(product.name), \(product.price) dollars, \(isSelected ? "selected" : "not selected")")
        .accessibilityHint(canSelect
            ? "Double tap to \(isSelected ? "deselect" : "select")"
            : "Selection limit reached"
        )
        .accessibility(addTraits: .isButton)
        // .accessibilityAddTraits(canSelect ? .button : [])
    }
}

#Preview {
    CompareView()
}
