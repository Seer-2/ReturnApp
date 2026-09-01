import Foundation

struct WhyAnswer: Codable, Identifiable, Equatable {
    let id: UUID
    var question: String
    var answer: String
    var createdAt: Date
    init(id: UUID = UUID(), question: String, answer: String, createdAt: Date = Date()) {
        self.id = id; self.question = question; self.answer = answer; self.createdAt = createdAt
    }
}

struct DailyReflection: Codable, Identifiable, Equatable {
    let id: UUID
    var date: Date
    var trigger: String
    var note: String
    var urgeRating: Int
    init(id: UUID = UUID(), date: Date = Date(), trigger: String, note: String, urgeRating: Int) {
        self.id = id; self.date = date; self.trigger = trigger; self.note = note; self.urgeRating = urgeRating
    }
}

struct ProgramPlan: Codable, Equatable {
    var startDate: Date
    var baselineMinutes: Int
    var targetMinutes: Int
    var durationWeeks: Int

    var currentWeek: Int {
        let days = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: startDate), to: Calendar.current.startOfDay(for: Date())).day ?? 0
        return min(max(days / 7 + 1, 1), durationWeeks)
    }

    func allowance(forWeek week: Int) -> Int {
        guard durationWeeks > 1 else { return targetMinutes }
        let clamped = min(max(week, 1), durationWeeks)
        let progress = Double(clamped - 1) / Double(durationWeeks - 1)
        let value = Double(baselineMinutes) - (Double(baselineMinutes - targetMinutes) * progress)
        return max(targetMinutes, Int(value.rounded()))
    }

    var currentAllowance: Int { allowance(forWeek: currentWeek) }
    var projectedMinutesReclaimedPerDay: Int { max(0, baselineMinutes - currentAllowance) }
}

struct NarrationSession: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let minutes: Int
    let script: String
    let symbol: String
}

enum QuestionBank {
    static let onboarding = [
        "Why did you download this app today?",
        "What is social media taking away from you right now?",
        "What do you care about most in your life?",
        "Who deserves more of your attention than your phone currently gets?",
        "What is something you say matters to you, but your habits keep pushing aside?",
        "If nothing changes for the next five years, what are you most afraid you will lose?",
        "What kind of person do you want to become?",
        "Why is changing this worth being uncomfortable for?"
    ]
    static let continuing = [
        "What did you do today that felt more real than scrolling?",
        "When do you reach for social media without deciding to?",
        "What feeling are you most likely to avoid by opening an app?",
        "What would you do with one extra hour tonight?",
        "What part of your future deserves your attention today?",
        "What are you comparing your life to online?",
        "What do you want to remember about this season of your life?",
        "What are you building that requires sustained attention?",
        "Which relationship would improve if you were more present?",
        "What did boredom make room for before your phone filled every pause?",
        "What do you want to be proud of one year from now?",
        "What is one small thing you can finish before opening social media?"
    ]
}

extension NarrationSession {
    static let library = [
        NarrationSession(id:"attention",title:"Your attention is your life",subtitle:"A reset for the moments you forget why you started.",minutes:3,script:"Your attention is not a small thing. It is the raw material of your days. Every place you repeatedly put it becomes part of your life. This program is not asking you to hate social media. It is asking you to choose. Notice the urge. Notice the automatic reach. Then remember that you are allowed to decide what deserves the next ten minutes of your life.",symbol:"circle.dotted"),
        NarrationSession(id:"boredom",title:"Boredom is not an emergency",subtitle:"For the moments when nothing is happening.",minutes:4,script:"Boredom can feel like a problem that needs to be solved immediately. But a quiet minute is not an emergency. It is often the doorway to thought, movement, curiosity, and rest. You do not need to fill every empty space. Let this one stay empty for a moment. See what your mind reaches for when the feed is not there to answer first.",symbol:"wind"),
        NarrationSession(id:"urge",title:"Ride the urge",subtitle:"A short session before you bypass your limit.",minutes:2,script:"You want to open the app right now. That feeling is real, but it is not a command. Give it sixty seconds. Feel where the urge shows up. Restlessness. Curiosity. Fear of missing something. You do not need to argue with it. Just watch it rise, and watch it change. Then decide deliberately what you want to do next.",symbol:"waveform.path"),
        NarrationSession(id:"night",title:"Close the day",subtitle:"A quiet evening reflection.",minutes:5,script:"The day is almost over. Do not reduce it to whether you hit a perfect number. Think about where your attention went. Think about what felt worthwhile. Think about the moments you were pulled away from something you cared about. Tomorrow is another chance to practice. Not perfection. Practice.",symbol:"moon.stars")
    ]
}
