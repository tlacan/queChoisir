import Core
import Foundation
import SwiftAnthropic
import Swinject

public protocol ClaudeServiceProtocol: Sendable {
    func analyzeProduct(_ product: Product) async throws -> ProductAnalysis
}

public final class ClaudeService: ClaudeServiceProtocol, @unchecked Sendable {
    private let anthropicService: AnthropicService

    public init(apiKey: String) {
      self.anthropicService = AnthropicServiceFactory.service(apiKey: apiKey, betaHeaders: nil)
    }

    public func analyzeProduct(_ product: Product) async throws -> ProductAnalysis {
        let prompt = """
        Analyze this product and give scores (0-100) for each criterion:

        Product: \(product.name)
        Specifications: \(product.specifications)
        Price: \(product.price)

        Criteria to evaluate:
        1. Reviews (based on average rating and volume)
        2. Repairability (availability of parts, ease of repair)
        3. Brand reputation (reliability, customer service)
        4. Power consumption (energy efficiency)
        5. Price (value for money in category)

        Return JSON format:
        {
          "reviews_score": 85,
          "repairability_score": 60,
          "reputation_score": 90,
          "consumption_score": 70,
          "price_score": 75,
          "overall_score": 76,
          "reasoning": "explanation for each score"
        }
        """

      let messagePrompt = MessageParameter.Message(role: .user, content: .text(prompt))
      let messageParameter = MessageParameter(model: .claude35Sonnet, messages: [messagePrompt], maxTokens: 1_000)

      do {
          let response = try await anthropicService.createMessage(messageParameter)

          guard let textContent = response.content.first else {
                throw ClaudeServiceError.invalidResponse
            }

          let textString: String
          switch textContent {
            case .text(let text): textString = text
            default: throw ClaudeServiceError.invalidResponse
          }

          let analysisData = Data(textString.utf8)
          let decoder = JSONDecoder()
          let analysis = try decoder.decode(ClaudeAnalysisResponse.self, from: analysisData)

          return ProductAnalysis(
              reviewsScore: analysis.reviewsScore,
              repairabilityScore: analysis.repairabilityScore,
              reputationScore: analysis.reputationScore,
              consumptionScore: analysis.consumptionScore,
              priceScore: analysis.priceScore,
              overallScore: analysis.overallScore,
              reasoning: analysis.reasoning
          )
        } catch {
            throw ClaudeServiceError.networkError
        }
    }
}

nonisolated private struct ClaudeAnalysisResponse: Codable, Sendable {
    let reviewsScore: Int
    let repairabilityScore: Int
    let reputationScore: Int
    let consumptionScore: Int
    let priceScore: Int
    let overallScore: Int
    let reasoning: String

    nonisolated enum CodingKeys: String, CodingKey {
        case reviewsScore = "reviews_score"
        case repairabilityScore = "repairability_score"
        case reputationScore = "reputation_score"
        case consumptionScore = "consumption_score"
        case priceScore = "price_score"
        case overallScore = "overall_score"
        case reasoning
    }
}

public enum ClaudeServiceError: Error, Sendable {
    case invalidResponse
    case networkError
    case decodingError
}

public struct ClaudeServiceAssembly: Swinject.Assembly {
    private let apiKey: String

    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    public func assemble(container: Container) {
        container.register(ClaudeServiceProtocol.self) { _ in
            ClaudeService(apiKey: self.apiKey)
        }.inObjectScope(.container)
    }
}
