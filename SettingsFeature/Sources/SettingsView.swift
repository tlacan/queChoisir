import SwiftUI
import Core
import DesignSystem

public struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            Form {
                WeightSettingsSection(viewModel: viewModel)
                
                AboutSection()
            }
            .navigationTitle(String(localized: "Settings"))
        }
    }
}

private struct WeightSettingsSection: View {
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        Section {
            WeightSliderRow(
                title: String(localized: "Reviews Weight"),
                value: $viewModel.weightSettings.reviewsWeight,
                description: "Importance of user reviews and ratings"
            )
            
            WeightSliderRow(
                title: String(localized: "Repairability Weight"),
                value: $viewModel.weightSettings.repairabilityWeight,
                description: "Ease of repair and part availability"
            )
            
            WeightSliderRow(
                title: String(localized: "Reputation Weight"),
                value: $viewModel.weightSettings.reputationWeight,
                description: "Brand reliability and customer service"
            )
            
            WeightSliderRow(
                title: String(localized: "Consumption Weight"),
                value: $viewModel.weightSettings.consumptionWeight,
                description: "Energy efficiency and environmental impact"
            )
            
            WeightSliderRow(
                title: String(localized: "Price Weight"),
                value: $viewModel.weightSettings.priceWeight,
                description: "Value for money and affordability"
            )
            
        } header: {
            Text(String(localized: "Weight Settings"))
                .queChoisirStyle(.titleMedium)
        } footer: {
            VStack(alignment: .leading, spacing: .queChoisir.xs) {
                Text("Adjust how much each criterion affects the overall score.")
                    .queChoisirStyle(.bodySmall)
                    .foregroundColor(.queChoisir.secondaryText)
                
                if !viewModel.isUsingDefaultWeights {
                    QueChoisirButton(
                        "Reset to Defaults",
                        variant: .ghost,
                        size: .small
                    ) {
                        viewModel.resetToDefaults()
                    }
                    .padding(.top, .queChoisir.xs)
                }
            }
        }
    }
}

private struct WeightSliderRow: View {
    let title: String
    @Binding var value: Double
    let description: String
    
    @ScaledMetric private var sliderHeight: CGFloat = 20
    
    var body: some View {
        VStack(alignment: .leading, spacing: .queChoisir.elementSpacing) {
            HStack {
                Text(title)
                    .queChoisirStyle(.bodyLarge)
                
                Spacer()
                
                Text("\(value, specifier: "%.1f")")
                    .queChoisirStyle(.labelLarge)
                    .foregroundColor(.queChoisir.primary)
                    .monospacedDigit()
            }
            
            Slider(value: $value, in: 0.0...5.0, step: 0.1) {
                Text(title)
            } minimumValueLabel: {
                Text("0")
                    .queChoisirStyle(.labelSmall)
                    .foregroundColor(.queChoisir.secondaryText)
            } maximumValueLabel: {
                Text("5")
                    .queChoisirStyle(.labelSmall)
                    .foregroundColor(.queChoisir.secondaryText)
            }
            .frame(height: sliderHeight)
            .accentColor(.queChoisir.primary)
            .accessibilityLabel(title)
            .accessibilityValue("\(value, specifier: "%.1f") out of 5")
            
            Text(description)
                .queChoisirStyle(.bodySmall)
                .foregroundColor(.queChoisir.secondaryText)
        }
        .padding(.vertical, .queChoisir.xs)
    }
}

private struct AboutSection: View {
    var body: some View {
        Section {
            AboutRowView(
                icon: "info.circle",
                title: "About QueChoisir",
                subtitle: "Version 1.0.0"
            )
            
            AboutRowView(
                icon: "questionmark.circle",
                title: "Help & Support",
                subtitle: "Get help using the app"
            )
            
            AboutRowView(
                icon: "star.circle",
                title: "Rate App",
                subtitle: "Rate us on the App Store"
            )
            
            AboutRowView(
                icon: "envelope.circle",
                title: "Contact Us",
                subtitle: "Send feedback or report issues"
            )
            
        } header: {
            Text("About")
                .queChoisirStyle(.titleMedium)
        }
    }
}

private struct AboutRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: .queChoisir.elementSpacing) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.queChoisir.primary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: .queChoisir.xxs) {
                Text(title)
                    .queChoisirStyle(.bodyLarge)
                
                Text(subtitle)
                    .queChoisirStyle(.bodySmall)
                    .foregroundColor(.queChoisir.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.queChoisir.separator)
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title), \(subtitle)")
        .accessibilityHint("Double tap to open")
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    SettingsView()
}
