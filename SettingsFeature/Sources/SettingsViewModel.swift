import SwiftUI
import Core

@MainActor
@Observable
public final class SettingsViewModel {
    public var weightSettings: WeightSettings {
        didSet {
            saveWeightSettings()
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let weightSettingsKey = "weight_settings"
    
    public init() {
        self.weightSettings = Self.loadWeightSettings()
    }
    
    private static func loadWeightSettings() -> WeightSettings {
        if let data = UserDefaults.standard.data(forKey: "weight_settings"),
           let settings = try? JSONDecoder().decode(WeightSettings.self, from: data) {
            return settings
        }
        return WeightSettings() // Default values
    }
    
    private func saveWeightSettings() {
        if let data = try? JSONEncoder().encode(weightSettings) {
            userDefaults.set(data, forKey: weightSettingsKey)
        }
    }
    
    public func resetToDefaults() {
        weightSettings = WeightSettings()
    }
    
    public var isUsingDefaultWeights: Bool {
        let defaultSettings = WeightSettings()
        return weightSettings.reviewsWeight == defaultSettings.reviewsWeight &&
               weightSettings.repairabilityWeight == defaultSettings.repairabilityWeight &&
               weightSettings.reputationWeight == defaultSettings.reputationWeight &&
               weightSettings.consumptionWeight == defaultSettings.consumptionWeight &&
               weightSettings.priceWeight == defaultSettings.priceWeight
    }
    
    public func normalizedWeightSettings() -> WeightSettings {
        let total = weightSettings.reviewsWeight +
                   weightSettings.repairabilityWeight +
                   weightSettings.reputationWeight +
                   weightSettings.consumptionWeight +
                   weightSettings.priceWeight
        
        guard total > 0 else { return WeightSettings() }
        
        return WeightSettings(
            reviewsWeight: weightSettings.reviewsWeight / total,
            repairabilityWeight: weightSettings.repairabilityWeight / total,
            reputationWeight: weightSettings.reputationWeight / total,
            consumptionWeight: weightSettings.consumptionWeight / total,
            priceWeight: weightSettings.priceWeight / total
        )
    }
}