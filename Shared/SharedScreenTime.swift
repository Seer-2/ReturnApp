import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

let returnAppGroup = "group.com.returnfocus.shared"

extension ManagedSettingsStore.Name {
    static let returnFocus = Self("ReturnFocus")
    static let returnPreview = Self("ReturnPreview")
}
extension DeviceActivityName { static let returnDaily = Self("ReturnDaily") }
extension DeviceActivityEvent.Name { static let returnLimit = Self("ReturnLimit") }

enum SharedSelectionStore {
    private static let key="return.familySelection"
    static func save(_ selection:FamilyActivitySelection) {
        guard let defaults=UserDefaults(suiteName:returnAppGroup), let data=try? JSONEncoder().encode(selection) else { return }
        defaults.set(data,forKey:key)
    }
    static func load()->FamilyActivitySelection {
        guard let defaults=UserDefaults(suiteName:returnAppGroup), let data=defaults.data(forKey:key), let selection=try? JSONDecoder().decode(FamilyActivitySelection.self,from:data) else { return FamilyActivitySelection() }
        return selection
    }
    static func clear(){ UserDefaults(suiteName:returnAppGroup)?.removeObject(forKey:key) }
}

struct SharedProtectionConfiguration:Codable,Equatable {
    var isEnabled:Bool
    var allowanceMinutes:Int
    var updatedAt:Date
}
enum SharedProtectionStore {
    private static let key="return.protectionConfiguration.v1"
    static func save(_ configuration:SharedProtectionConfiguration) {
        guard let defaults=UserDefaults(suiteName:returnAppGroup), let data=try? JSONEncoder().encode(configuration) else { return }
        defaults.set(data,forKey:key)
    }
    static func load()->SharedProtectionConfiguration? {
        guard let defaults=UserDefaults(suiteName:returnAppGroup), let data=defaults.data(forKey:key) else { return nil }
        return try? JSONDecoder().decode(SharedProtectionConfiguration.self,from:data)
    }
    static func clear(){ UserDefaults(suiteName:returnAppGroup)?.removeObject(forKey:key) }
}
extension FamilyActivitySelection {
    var returnHasSelection:Bool { !applicationTokens.isEmpty || !categoryTokens.isEmpty || !webDomainTokens.isEmpty }
    var returnSelectionCount:Int { applicationTokens.count + categoryTokens.count + webDomainTokens.count }
}
