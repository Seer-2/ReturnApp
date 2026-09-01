import SwiftUI
import FamilyControls

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var screenTime: ScreenTimeManager
    @State private var showingPicker = false
    @State private var showingReset = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Protection") {
                    LabeledContent("Selected items", value: "\(screenTime.selectionCount)")
                    LabeledContent("Daily allowance", value: formatMinutes(appState.plan.currentAllowance))
                    LabeledContent("Status", value: screenTime.protectionEnabled ? "Active" : "Needs attention")
                    Button("Choose protected apps") { showingPicker = true }
                    Button("Refresh protection") { _ = screenTime.startDailyMonitoring(allowanceMinutes: appState.plan.currentAllowance) }.disabled(!screenTime.hasSelection)
                }
                Section("Preview protection") {
                    Text("Temporarily shield your selected apps so you can confirm the protection screen looks and behaves correctly. This does not change today's allowance.")
                    Button("Show protection now") { screenTime.showPreviewShield() }.disabled(!screenTime.hasSelection)
                    Button("Remove preview shield") { screenTime.clearPreviewShield() }
                }
                if let error = screenTime.monitoringError {
                    Section("Screen Time status") { Text(error).foregroundStyle(Color.returnClay) }
                }
                Section("Program") {
                    LabeledContent("Current week", value: "\(appState.plan.currentWeek) of \(appState.plan.durationWeeks)")
                    LabeledContent("Current allowance", value: formatMinutes(appState.plan.currentAllowance))
                    LabeledContent("End goal", value: formatMinutes(appState.plan.targetMinutes))
                }
                Section("Privacy") {
                    Text("Your Why Vault and reflections stay on this device. Screen Time selections are stored as Apple's opaque tokens and are shared only with RETURN's Screen Time extension so it can enforce your chosen limit.")
                }
                Section { Button("Reset RETURN", role:.destructive) { showingReset=true } } footer: {
                    Text("Resetting removes your local program data, protected-app selection, active Screen Time monitoring, and RETURN shields.")
                }
            }
            .scrollContentBackground(.hidden).background(Color.returnIvory).navigationTitle("Settings").tint(Color.returnOlive)
            .familyActivityPicker(isPresented:$showingPicker, selection:$screenTime.selection)
            .onChange(of: screenTime.selection) { _, newSelection in
                guard newSelection.returnHasSelection, screenTime.protectionEnabled else { return }
                _ = screenTime.startDailyMonitoring(allowanceMinutes: appState.plan.currentAllowance)
            }
            .alert("Reset the program?", isPresented:$showingReset) {
                Button("Cancel", role:.cancel) {}
                Button("Reset", role:.destructive) { screenTime.resetProtection(); appState.reset() }
            } message: {
                Text("This deletes your local Why Vault, reflections, taper plan, protected-app selection, and active RETURN restrictions.")
            }
        }
    }

    private func formatMinutes(_ minutes:Int)->String {
        if minutes < 60 { return "\(minutes)m" }
        return "\(minutes/60)h \(minutes%60)m"
    }
}
