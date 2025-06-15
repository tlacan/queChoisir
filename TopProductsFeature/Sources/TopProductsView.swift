import Core
import DesignSystem
import SwiftUI

public struct TopProductsView: View {
    @State private var viewModel = TopProductsViewModel()

    public init() {}

    public var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: .queChoisir.componentSpacing) {
                    ForEach(viewModel.topProducts) { product in
                        ProductCardView(
                            product: product,
                            analysis: viewModel.analyzedProducts[product],
                            isLoading: viewModel.isLoading
                        ) {
                            Task {
                                await viewModel.analyzeProduct(product)
                            }
                        }
                        .cardPadding()
                        .background(Color.queChoisir.cardBackground)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                }
                .screenPadding()
                .dynamicPadding(.top, .queChoisir.sectionSpacing)
            }
            .navigationTitle(String(localized: "Top Products"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    QueChoisirIconButton(
                        icon: "arrow.clockwise",
                        variant: .ghost,
                        isDisabled: viewModel.isLoading,
                        accessibilityLabel: String(localized: "Refresh all products")
                    ) {
                        Task {
                            await viewModel.refreshProducts()
                        }
                    }
                }
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

private struct ProductCardView: View {
    let product: Product
    let analysis: ProductAnalysis?
    let isLoading: Bool
    let onAnalyze: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .queChoisir.elementSpacing) {
            ProductHeaderView(
                product: product,
                analysis: analysis,
                isLoading: isLoading,
                onAnalyze: onAnalyze
            )

            if let analysis {
                ScoreGridView(analysis: analysis)
                    .componentSpacing()

                Text(analysis.reasoning)
                    .queChoisirStyle(.bodySmall)
                    .foregroundColor(Color.queChoisir.secondaryText)
                    .lineLimit(3)
            }
        }
    }
}

private struct ProductHeaderView: View {
    let product: Product
    let analysis: ProductAnalysis?
    let isLoading: Bool
    let onAnalyze: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: .queChoisir.xxs) {
                Text(product.name)
                    .queChoisirStyle(.productTitle)

                Text("$\(product.price, specifier: "%.0f")")
                    .queChoisirStyle(.productPrice)
                    .foregroundColor(Color.queChoisir.primary)

                Text(product.category)
                    .queChoisirStyle(.labelSmall)
                    .foregroundColor(Color.queChoisir.secondaryText)
                    .padding(.horizontal, .queChoisir.xs)
                    .padding(.vertical, .queChoisir.xxs)
                    .background(Color.queChoisir.secondary.opacity(0.1))
                    .cornerRadius(6)
            }

            Spacer()

            if let analysis {
                OverallScoreView(score: analysis.overallScore)
            } else {
                QueChoisirButton(
                    String(localized: "Analyze"),
                    icon: "magnifyingglass",
                    variant: .primary,
                    size: .small,
                    isDisabled: isLoading,
                    accessibilityLabel: String(localized: "Analyze \(product.name)")
                ) {
                    onAnalyze()
                }
            }
        }
    }
}

private struct OverallScoreView: View {
    let score: Int

    var body: some View {
        VStack(spacing: .queChoisir.xxs) {
            Text(String(localized: "Overall Score"))
                .queChoisirStyle(.scoreSubtitle)

            Text("\(score)")
                .queChoisirStyle(.scoreTitle)
                .foregroundColor(.queChoisir.scoreColor(for: score))
        }
        .padding(.queChoisir.sm)
        .background(Color.queChoisir.tertiaryBackground)
        .cornerRadius(8)
    }
}

private struct ScoreGridView: View {
    let analysis: ProductAnalysis

    private let columns = Array(repeating: GridItem(.flexible(), spacing: .queChoisir.xs), count: 2)

    var body: some View {
        LazyVGrid(columns: columns, spacing: .queChoisir.xs) {
            ScoreItemView(title: String(localized: "Reviews"), score: analysis.reviewsScore)
            ScoreItemView(title: String(localized: "Repairability"), score: analysis.repairabilityScore)
            ScoreItemView(title: String(localized: "Reputation"), score: analysis.reputationScore)
            ScoreItemView(title: String(localized: "Consumption"), score: analysis.consumptionScore)
            ScoreItemView(title: String(localized: "Price"), score: analysis.priceScore)
        }
    }
}

private struct ScoreItemView: View {
    let title: String
    let score: Int

    var body: some View {
        VStack(spacing: .queChoisir.xxs) {
            Text(title)
                .queChoisirStyle(.labelSmall)
                .multilineTextAlignment(.center)

            Text("\(score)")
                .queChoisirStyle(.labelMedium)
                .fontWeight(.semibold)
                .foregroundColor(.queChoisir.scoreColor(for: score))
        }
        .frame(maxWidth: .infinity)
        .padding(.queChoisir.xs)
        .background(Color.queChoisir.secondaryBackground)
        .cornerRadius(6)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(String(localized: "\(title): \(score) out of 100"))
    }
}

#Preview {
    TopProductsView()
}
