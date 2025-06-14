import SwiftUI
import Core
import TopProductsFeature
import CompareFeature
import SettingsFeature
import ClaudeService

@main
struct QueChoisirApp: App {
    
    init() {
        setupDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func setupDependencies() {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "CLAUDE_API_KEY") as? String ?? ""
        let claudeAssembly = ClaudeServiceAssembly(apiKey: apiKey)
        DependencyContainer.shared.addAssembly(claudeAssembly)
    }
}
