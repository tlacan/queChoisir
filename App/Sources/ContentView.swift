import SwiftUI
import TopProductsFeature
import CompareFeature
import SettingsFeature

struct ContentView: View {
    var body: some View {
        TabView {
            TopProductsView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text(String(localized: "Top Products"))
                }
            
            CompareView()
                .tabItem {
                    Image(systemName: "scale.3d")
                    Text(String(localized: "Compare"))
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text(String(localized: "Settings"))
                }
        }
    }
}

#Preview {
    ContentView()
}