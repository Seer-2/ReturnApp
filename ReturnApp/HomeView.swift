import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @State private var showingReflection = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    HStack {
                        ReturnWordmark()
                        Spacer()
                        Text("Week \(appState.plan.currentWeek) of \(appState.plan.durationWeeks)")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.returnStone)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(formatMinutes(appState.plan.projectedMinutesReclaimedPerDay))
                            .font(.system(size: 54, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.returnInk)
                        Text("potentially given back today")
                            .font(.title3)
                            .foregroundStyle(Color.returnStone)
                    }
                    .padding(.vertical, 8)

                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("Today's allowance").font(.headline)
                            Spacer()
                            Text(formatMinutes(appState.plan.currentAllowance)).font(.headline).foregroundStyle(Color.returnOlive)
                        }
                        ProgressView(value: Double(appState.plan.currentWeek), total: Double(appState.plan.durationWeeks))
                            .tint(Color.returnOlive)
                        Text("RETURN reduces the allowance gradually each week. The goal is adaptation, not punishment.")
                            .font(.caption).foregroundStyle(Color.returnStone)
                    }
                    .returnCard()

                    if let why = appState.featuredWhy {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("FROM YOUR WHY VAULT").font(.caption2.weight(.bold)).tracking(1.4).foregroundStyle(Color.returnOlive)
                            Text("“\(why.answer)”").font(.system(.title3, design: .serif, weight: .medium)).foregroundStyle(Color.returnInk)
                            Text(why.question).font(.caption).foregroundStyle(Color.returnStone)
                        }
                        .returnCard()
                    }

                    HStack(spacing: 12) {
                        MetricPill(value: formatMinutes(appState.reclaimedMinutesThisWeek), label: "reclaimed / week")
                        MetricPill(value: "\(max(0, appState.plan.baselineMinutes - appState.plan.currentAllowance))m", label: "less / day")
                    }

                    Button { showingReflection = true } label: {
                        Label("Check in with yourself", systemImage: "square.and.pencil")
                    }
                    .buttonStyle(ReturnPrimaryButtonStyle())

                    SectionHeader("Today's prompt")
                    Text(QuestionBank.continuing[(Calendar.current.component(.day, from: Date()) - 1) % QuestionBank.continuing.count])
                        .font(.title3.weight(.medium))
                        .foregroundStyle(Color.returnInk)
                        .returnCard()
                }
                .padding(20)
            }
            .background(Color.returnIvory)
            .sheet(isPresented: $showingReflection) { ReflectionSheet() }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private func formatMinutes(_ minutes: Int) -> String {
        if minutes < 60 { return "\(minutes)m" }
        return "\(minutes / 60)h \(minutes % 60)m"
    }
}

struct ReflectionSheet: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var trigger = "Habit"
    @State private var note = ""
    @State private var rating = 5.0

    private let triggers = ["Habit", "Boredom", "Stress", "Loneliness", "Procrastination", "Something happened", "I don't know"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    SectionHeader("What was pulling you in?", subtitle: "No streaks. No punishment. Just notice the pattern.")
                    Picker("Trigger", selection: $trigger) {
                        ForEach(triggers, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.menu).tint(Color.returnOlive).returnCard()

                    VStack(alignment: .leading, spacing: 10) {
                        Text("How strong was the urge? \(Int(rating))/10").font(.headline)
                        Slider(value: $rating, in: 1...10, step: 1).tint(Color.returnOlive)
                    }
                    .returnCard()

                    TextEditor(text: $note)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 150)
                        .padding(12)
                        .background(Color.returnBone)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay(alignment: .topLeading) {
                            if note.isEmpty {
                                Text("What happened?").foregroundStyle(Color.returnStone).padding(18).allowsHitTesting(false)
                            }
                        }

                    Button("Save reflection") {
                        appState.addReflection(trigger: trigger, note: note, urgeRating: Int(rating))
                        dismiss()
                    }
                    .buttonStyle(ReturnPrimaryButtonStyle())
                }
                .padding(20)
            }
            .background(Color.returnIvory)
            .navigationTitle("Reflection")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Close") { dismiss() } } }
        }
    }
}
