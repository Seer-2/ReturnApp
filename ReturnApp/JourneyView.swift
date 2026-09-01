import SwiftUI

struct JourneyView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    SectionHeader("Your journey", subtitle: "A gradual reduction designed to give your habits time to adapt.")

                    ForEach(1...appState.plan.durationWeeks, id: \.self) { week in
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(week <= appState.plan.currentWeek ? Color.returnOlive : Color.returnBone)
                                    .frame(width: 42, height: 42)
                                Text("\(week)")
                                    .font(.headline)
                                    .foregroundStyle(week <= appState.plan.currentWeek ? Color.returnIvory : Color.returnStone)
                            }

                            VStack(alignment: .leading, spacing: 5) {
                                Text(week == appState.plan.currentWeek ? "Week \(week) · current" : "Week \(week)")
                                    .font(.headline).foregroundStyle(Color.returnInk)
                                Text("Daily allowance: \(formatMinutes(appState.plan.allowance(forWeek: week)))")
                                    .font(.subheadline).foregroundStyle(Color.returnStone)
                            }
                            Spacer()
                            if week < appState.plan.currentWeek {
                                Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.returnOlive)
                            }
                        }
                        .returnCard()
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("The end goal").font(.headline)
                        Text("RETURN is built to become less necessary as you become more deliberate. Completing the program should feel like graduation, not dependency on another app.")
                            .font(.subheadline).foregroundStyle(Color.returnStone)
                    }
                    .returnCard()
                }
                .padding(20)
            }
            .background(Color.returnIvory)
            .navigationTitle("Journey")
        }
    }

    private func formatMinutes(_ minutes: Int) -> String {
        if minutes < 60 { return "\(minutes)m" }
        return "\(minutes / 60)h \(minutes % 60)m"
    }
}
