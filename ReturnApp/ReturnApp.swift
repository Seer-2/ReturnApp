import SwiftUI

@main
struct ReturnApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var screenTime = ScreenTimeManager()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(screenTime)
                .preferredColorScheme(.light)
        }
        .onChange(of: scenePhase) { _, phase in
            guard phase == .active, appState.onboardingComplete else { return }
            screenTime.refreshIfNeeded(allowanceMinutes: appState.plan.currentAllowance)
        }
    }
}
