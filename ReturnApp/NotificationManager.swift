import Foundation
import UserNotifications

@MainActor
final class NotificationManager {
    static let shared = NotificationManager()

    func requestAndSchedule(hour: Int) async {
        let center = UNUserNotificationCenter.current()
        _ = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
        center.removePendingNotificationRequests(withIdentifiers: ["return.evening"])
        let content = UNMutableNotificationContent()
        content.title = "Return to what matters"
        content.body = "Take sixty seconds to notice where your attention went today."
        content.sound = .default
        var components = DateComponents(); components.hour = hour
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "return.evening", content: content, trigger: trigger)
        try? await center.add(request)
    }
}
