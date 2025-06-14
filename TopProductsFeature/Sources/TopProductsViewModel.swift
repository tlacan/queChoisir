import SwiftUI
import Core
import ClaudeService

@Observable
public final class TopProductsViewModel: Sendable {
    public private(set) var products: [Product] = []
    public private(set) var analyzedProducts: [Product: ProductAnalysis] = [:]
    public private(set) var isLoading = false
    public var errorMessage: String?
    
    private let claudeService: ClaudeServiceProtocol
    
    public init() {
        self.claudeService = DependencyContainer.shared.resolve(ClaudeServiceProtocol.self)!
        loadSampleProducts()
    }
    
    public func analyzeProduct(_ product: Product) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let analysis = try await claudeService.analyzeProduct(product)
            analyzedProducts[product] = analysis
        } catch {
            errorMessage = "Failed to analyze product: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    public func refreshProducts() async {
        for product in products {
            await analyzeProduct(product)
        }
    }
    
    public var topProducts: [Product] {
        products.sorted { product1, product2 in
            let score1 = analyzedProducts[product1]?.overallScore ?? 0
            let score2 = analyzedProducts[product2]?.overallScore ?? 0
            return score1 > score2
        }
    }
    
    private func loadSampleProducts() {
        products = [
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
                name: "Sony WH-1000XM5",
                specifications: "Noise canceling, 30-hour battery, Premium sound quality",
                price: 399.0,
                category: "Headphones"
            )
        ]
    }
}
