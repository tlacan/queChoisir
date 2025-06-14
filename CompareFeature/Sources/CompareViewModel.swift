import SwiftUI
import Core
import ClaudeService

@MainActor
@Observable
public final class CompareViewModel: Sendable {
    public private(set) var availableProducts: [Product] = []
    public private(set) var selectedProducts: [Product] = []
    public private(set) var analyzedProducts: [Product: ProductAnalysis] = [:]
    public private(set) var isLoading = false
    public var errorMessage: String?
    
    private let claudeService: ClaudeServiceProtocol
    private let maxCompareProducts = 3
    
    public init() {
        self.claudeService = DependencyContainer.shared.resolve(ClaudeServiceProtocol.self)!
        loadAvailableProducts()
    }
    
    public func toggleProductSelection(_ product: Product) {
        if selectedProducts.contains(where: { $0.id == product.id }) {
            selectedProducts.removeAll { $0.id == product.id }
        } else if selectedProducts.count < maxCompareProducts {
            selectedProducts.append(product)
        }
    }
    
    public func isProductSelected(_ product: Product) -> Bool {
        selectedProducts.contains(where: { $0.id == product.id })
    }
    
    public var canSelectMoreProducts: Bool {
        selectedProducts.count < maxCompareProducts
    }
    
    public func analyzeSelectedProducts() async {
        guard !selectedProducts.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        for product in selectedProducts {
            if analyzedProducts[product] == nil {
                do {
                    let analysis = try await claudeService.analyzeProduct(product)
                    analyzedProducts[product] = analysis
                } catch {
                    errorMessage = "Failed to analyze \(product.name): \(error.localizedDescription)"
                    break
                }
            }
        }
        
        isLoading = false
    }
    
    public func clearSelection() {
        selectedProducts.removeAll()
    }
    
    private func loadAvailableProducts() {
        availableProducts = [
            Product(
                name: "iPhone 15 Pro",
                specifications: "A17 Pro chip, 6.1-inch display, 128GB storage, Triple camera system",
                price: 999.0,
                category: "Smartphone"
            ),
            Product(
                name: "Samsung Galaxy S24",
                specifications: "Snapdragon 8 Gen 3, 6.2-inch display, 256GB storage, AI features",
                price: 899.0,
                category: "Smartphone"
            ),
            Product(
                name: "Google Pixel 8 Pro",
                specifications: "Google Tensor G3, 6.7-inch display, 128GB storage, AI photography",
                price: 899.0,
                category: "Smartphone"
            ),
            Product(
                name: "MacBook Pro 14\"",
                specifications: "M3 Pro chip, 14-inch display, 512GB SSD, 18GB RAM",
                price: 1999.0,
                category: "Laptop"
            ),
            Product(
                name: "Dell XPS 13",
                specifications: "Intel Core i7, 13.4-inch display, 512GB SSD, 16GB RAM",
                price: 1299.0,
                category: "Laptop"
            ),
            Product(
                name: "MacBook Air M3",
                specifications: "M3 chip, 13-inch display, 256GB SSD, 8GB RAM",
                price: 1099.0,
                category: "Laptop"
            ),
            Product(
                name: "Sony WH-1000XM5",
                specifications: "Noise canceling, 30-hour battery, Premium sound quality",
                price: 399.0,
                category: "Headphones"
            ),
            Product(
                name: "Apple AirPods Max",
                specifications: "Active noise cancellation, 20-hour battery, Spatial audio",
                price: 549.0,
                category: "Headphones"
            ),
            Product(
                name: "Bose QuietComfort 45",
                specifications: "Noise cancelling, 24-hour battery, Comfortable design",
                price: 329.0,
                category: "Headphones"
            )
        ]
    }
}
