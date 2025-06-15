import Foundation

public nonisolated struct Product: Codable, Identifiable, Sendable, Hashable {
    public let id: UUID
    public let name: String
    public let specifications: String
    public let price: Double
    public let category: String

    public init(name: String, specifications: String, price: Double, category: String) {
        self.id = UUID()
        self.name = name
        self.specifications = specifications
        self.price = price
        self.category = category
    }
}

public nonisolated struct ProductAnalysis: Codable, Sendable {
    public let reviewsScore: Int
    public let repairabilityScore: Int
    public let reputationScore: Int
    public let consumptionScore: Int
    public let priceScore: Int
    public let overallScore: Int
    public let reasoning: String

    public init(
        reviewsScore: Int,
        repairabilityScore: Int,
        reputationScore: Int,
        consumptionScore: Int,
        priceScore: Int,
        overallScore: Int,
        reasoning: String
    ) {
        self.reviewsScore = reviewsScore
        self.repairabilityScore = repairabilityScore
        self.reputationScore = reputationScore
        self.consumptionScore = consumptionScore
        self.priceScore = priceScore
        self.overallScore = overallScore
        self.reasoning = reasoning
    }
}

public nonisolated struct WeightSettings: Codable, Sendable {
    public var reviewsWeight: Double
    public var repairabilityWeight: Double
    public var reputationWeight: Double
    public var consumptionWeight: Double
    public var priceWeight: Double

    public init(
        reviewsWeight: Double = 1.0,
        repairabilityWeight: Double = 1.0,
        reputationWeight: Double = 1.0,
        consumptionWeight: Double = 1.0,
        priceWeight: Double = 1.0
    ) {
        self.reviewsWeight = reviewsWeight
        self.repairabilityWeight = repairabilityWeight
        self.reputationWeight = reputationWeight
        self.consumptionWeight = consumptionWeight
        self.priceWeight = priceWeight
    }
}
