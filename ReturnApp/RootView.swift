import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState
    var body: some View {
        Group {
            if appState.onboardingComplete { MainTabView() } else { OnboardingView() }
        }
        .background(Color.returnIvory.ignoresSafeArea())
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView().tabItem { Label("Today", systemImage: "circle.lefthalf.filled") }
            JourneyView().tabItem { Label("Journey", systemImage: "chart.line.uptrend.xyaxis") }
            ListenView().tabItem { Label("Listen", systemImage: "waveform") }
            WhyVaultView().tabItem { Label("Why", systemImage: "quote.bubble") }
            SettingsView().tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .tint(Color.returnOlive)
    }
}
