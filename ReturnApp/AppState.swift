import Foundation
import SwiftUI

@MainActor
final class AppState: ObservableObject {
    @Published var onboardingComplete = false { didSet { save() } }
    @Published var whyAnswers: [WhyAnswer] = [] { didSet { save() } }
    @Published var reflections: [DailyReflection] = [] { didSet { save() } }
    @Published var plan = ProgramPlan(startDate: Date(), baselineMinutes: 150, targetMinutes: 60, durationWeeks: 8) { didSet { save() } }
    @Published var selectedLifeAreas: [String] = [] { didSet { save() } }
    @Published var notificationHour = 20 { didSet { save() } }

    private let defaults = UserDefaults.standard
    private let key = "return.appState.v1"
    private var isLoading = true

    init() { load(); isLoading = false }

    var featuredWhy: WhyAnswer? {
        guard !whyAnswers.isEmpty else { return nil }
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return whyAnswers[day % whyAnswers.count]
    }

    var reclaimedMinutesThisWeek: Int { plan.projectedMinutesReclaimedPerDay * 7 }

    func addReflection(trigger: String, note: String, urgeRating: Int) {
        reflections.insert(DailyReflection(trigger: trigger, note: note, urgeRating: urgeRating), at: 0)
    }

    func reset() {
        onboardingComplete = false
        whyAnswers = []
        reflections = []
        plan = ProgramPlan(startDate: Date(), baselineMinutes: 150, targetMinutes: 60, durationWeeks: 8)
        selectedLifeAreas = []
        notificationHour = 20
        defaults.removeObject(forKey: key)
    }

    private struct Snapshot: Codable {
        var onboardingComplete: Bool
        var whyAnswers: [WhyAnswer]
        var reflections: [DailyReflection]
        var plan: ProgramPlan
        var selectedLifeAreas: [String]
        var notificationHour: Int
    }

    private func save() {
        guard !isLoading else { return }
        let snapshot = Snapshot(onboardingComplete: onboardingComplete, whyAnswers: whyAnswers, reflections: reflections, plan: plan, selectedLifeAreas: selectedLifeAreas, notificationHour: notificationHour)
        if let data = try? JSONEncoder().encode(snapshot) { defaults.set(data, forKey: key) }
    }

    private func load() {
        guard let data = defaults.data(forKey: key),
              let snapshot = try? JSONDecoder().decode(Snapshot.self, from: data) else { return }
        onboardingComplete = snapshot.onboardingComplete
        whyAnswers = snapshot.whyAnswers
        reflections = snapshot.reflections
        plan = snapshot.plan
        selectedLifeAreas = snapshot.selectedLifeAreas
        notificationHour = snapshot.notificationHour
    }
}
