import Foundation
import Combine
import FamilyControls
import DeviceActivity
import ManagedSettings

@MainActor
final class ScreenTimeManager: ObservableObject {
    @Published var selection: FamilyActivitySelection { didSet { SharedSelectionStore.save(selection) } }
    @Published private(set) var activeAllowanceMinutes: Int?
    @Published private(set) var protectionEnabled = false
    @Published var authorizationError: String?
    @Published var monitoringError: String?

    private let center = DeviceActivityCenter()
    private let enforcementStore = ManagedSettingsStore(named: .returnFocus)
    private let previewStore = ManagedSettingsStore(named: .returnPreview)

    init() {
        selection = SharedSelectionStore.load()
        if let configuration = SharedProtectionStore.load() {
            activeAllowanceMinutes = configuration.allowanceMinutes
            protectionEnabled = configuration.isEnabled
        }
    }

    var hasSelection: Bool { selection.returnHasSelection }
    var selectionCount: Int { selection.returnSelectionCount }

    func requestAuthorization() async -> Bool {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            authorizationError = nil; return true
        } catch {
            authorizationError = error.localizedDescription; return false
        }
    }

    @discardableResult
    func startDailyMonitoring(allowanceMinutes: Int) -> Bool {
        guard hasSelection else {
            monitoringError = "Choose at least one app, category, or website before enabling protection."
            return false
        }
        let minutes = max(1, allowanceMinutes)
        let schedule = DeviceActivitySchedule(intervalStart: DateComponents(hour:0,minute:0), intervalEnd: DateComponents(hour:23,minute:59,second:59), repeats:true, warningTime:DateComponents(minute:5))
        let event = DeviceActivityEvent(applications:selection.applicationTokens,categories:selection.categoryTokens,webDomains:selection.webDomainTokens,threshold:DateComponents(minute:minutes),includesPastActivity:true)
        do {
            center.stopMonitoring([.returnDaily]); enforcementStore.clearAllSettings()
            try center.startMonitoring(.returnDaily, during:schedule, events:[.returnLimit:event])
            monitoringError=nil; activeAllowanceMinutes=minutes; protectionEnabled=true
            SharedProtectionStore.save(.init(isEnabled:true,allowanceMinutes:minutes,updatedAt:Date()))
            return true
        } catch {
            monitoringError=error.localizedDescription; protectionEnabled=false
            SharedProtectionStore.save(.init(isEnabled:false,allowanceMinutes:minutes,updatedAt:Date()))
            return false
        }
    }

    func refreshIfNeeded(allowanceMinutes: Int) {
        guard protectionEnabled, hasSelection else { return }
        let monitorMissing = !center.activities.contains(.returnDaily)
        guard monitorMissing || activeAllowanceMinutes != allowanceMinutes else { return }
        _ = startDailyMonitoring(allowanceMinutes: allowanceMinutes)
    }

    func showPreviewShield() {
        guard hasSelection else { return }
        previewStore.shield.applications = selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
        previewStore.shield.applicationCategories = selection.categoryTokens.isEmpty ? nil : .specific(selection.categoryTokens)
        previewStore.shield.webDomains = selection.webDomainTokens.isEmpty ? nil : selection.webDomainTokens
    }
    func clearPreviewShield() { previewStore.clearAllSettings() }
    func stopProtection() {
        center.stopMonitoring([.returnDaily]); enforcementStore.clearAllSettings(); previewStore.clearAllSettings()
        protectionEnabled=false
        SharedProtectionStore.save(.init(isEnabled:false,allowanceMinutes:activeAllowanceMinutes ?? 1,updatedAt:Date()))
    }
    func resetProtection() {
        stopProtection(); selection=FamilyActivitySelection(); activeAllowanceMinutes=nil; monitoringError=nil; authorizationError=nil
        SharedSelectionStore.clear(); SharedProtectionStore.clear()
    }
}
