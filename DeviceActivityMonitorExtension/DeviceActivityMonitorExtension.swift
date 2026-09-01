import DeviceActivity
import FamilyControls
import ManagedSettings

final class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    private let store = ManagedSettingsStore(named: .returnFocus)

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        guard activity == .returnDaily else { return }

        store.clearAllSettings()
    }

    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        guard activity == .returnDaily, event == .returnLimit else { return }
        guard SharedProtectionStore.load()?.isEnabled == true else {
            store.clearAllSettings()
            return
        }

        let selection = SharedSelectionStore.load()
        guard selection.returnHasSelection else {
            store.clearAllSettings()
            return
        }

        store.shield.applications = selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
        store.shield.applicationCategories = selection.categoryTokens.isEmpty ? nil : .specific(selection.categoryTokens)
        store.shield.webDomains = selection.webDomainTokens.isEmpty ? nil : selection.webDomainTokens
    }
}
