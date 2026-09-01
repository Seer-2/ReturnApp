import SwiftUI
import FamilyControls

struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var screenTime: ScreenTimeManager

    @State private var step = 0
    @State private var questionIndex = 0
    @State private var draftAnswer = ""
    @State private var answers: [WhyAnswer] = []
    @State private var baseline = 150.0
    @State private var target = 60.0
    @State private var weeks = 8.0
    @State private var showingPicker = false
    @State private var authorizationGranted = false
    @State private var completionError: String?

    private let totalSteps = 5

    var body: some View {
        ZStack {
            Color.returnIvory.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    ReturnWordmark()
                    Spacer()
                    if step > 0 {
                        Text("\(step)/\(totalSteps)")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.returnStone)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                ProgressView(value: Double(step), total: Double(totalSteps))
                    .tint(Color.returnOlive)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .opacity(step == 0 ? 0 : 1)

                Group {
                    switch step {
                    case 0: welcome
                    case 1: baselineStep
                    case 2: whyStep
                    case 3: programStep
                    case 4: protectionStep
                    default: completionStep
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .trailing)))
                .animation(.easeInOut(duration: 0.25), value: step)
            }
        }
        .familyActivityPicker(isPresented: $showingPicker, selection: $screenTime.selection)
    }

    private var welcome: some View {
        VStack(alignment: .leading, spacing: 22) {
            Spacer()
            Text("Where has your\nattention been going?")
                .font(.system(size: 42, weight: .semibold, design: .serif))
                .foregroundStyle(Color.returnInk)
            Text("RETURN is a guided program for gradually reducing automatic social media habits without asking you to disappear from your life overnight.")
                .font(.title3).foregroundStyle(Color.returnStone).lineSpacing(5)
            Spacer()
            Text("This is not a punishment. You will choose the apps, the pace, and the reason you are doing it.")
                .font(.footnote).foregroundStyle(Color.returnStone).returnCard()
            Button("Begin") { step = 1 }.buttonStyle(ReturnPrimaryButtonStyle())
        }
        .padding(24)
    }

    private var baselineStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                SectionHeader("Start with reality", subtitle: "Estimate your average daily social media use. You can refine this later.").padding(.top, 30)
                VStack(spacing: 8) {
                    Text(formatMinutes(Int(baseline))).font(.system(size: 48, weight: .semibold, design: .rounded)).foregroundStyle(Color.returnInk)
                    Text("current daily use").foregroundStyle(Color.returnStone)
                    Slider(value: $baseline, in: 30...480, step: 5).tint(Color.returnOlive)
                }.returnCard()
                Text("Your first week will stay close to your baseline. The program then tapers gradually rather than demanding an unrealistic overnight change.")
                    .font(.subheadline).foregroundStyle(Color.returnStone)
                Button("Continue") { step = 2 }.buttonStyle(ReturnPrimaryButtonStyle())
            }.padding(24)
        }
    }

    private var whyStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer(minLength: 24)
            Text("Your Why Vault").font(.largeTitle.weight(.semibold)).foregroundStyle(Color.returnInk)
            Text(QuestionBank.onboarding[questionIndex]).font(.system(size: 27, weight: .medium, design: .serif)).foregroundStyle(Color.returnInk).lineSpacing(4)
            TextEditor(text: $draftAnswer)
                .scrollContentBackground(.hidden).padding(12).frame(minHeight: 180)
                .background(Color.returnBone.opacity(0.8)).clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous)).foregroundStyle(Color.returnInk)
            Text("\(questionIndex + 1) of \(QuestionBank.onboarding.count)").font(.caption).foregroundStyle(Color.returnStone)
            Spacer()
            Button(questionIndex == QuestionBank.onboarding.count - 1 ? "Save my answers" : "Next question") {
                let trimmed = draftAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return }
                answers.append(WhyAnswer(question: QuestionBank.onboarding[questionIndex], answer: trimmed))
                draftAnswer = ""
                if questionIndex < QuestionBank.onboarding.count - 1 { questionIndex += 1 }
                else { appState.whyAnswers = answers; step = 3 }
            }
            .buttonStyle(ReturnPrimaryButtonStyle())
            .opacity(draftAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
        }.padding(24)
    }

    private var programStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                SectionHeader("Build your taper", subtitle: "Choose where you want to end up. RETURN will create the steps between here and there.").padding(.top, 30)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Target daily use").font(.headline)
                    Text(formatMinutes(Int(target))).font(.system(size: 38, weight: .semibold, design: .rounded))
                    Slider(value: $target, in: 15...max(20, baseline - 10), step: 5).tint(Color.returnOlive)
                }.returnCard()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Program length").font(.headline)
                    Text("\(Int(weeks)) weeks").font(.system(size: 38, weight: .semibold, design: .rounded))
                    Slider(value: $weeks, in: 4...12, step: 1).tint(Color.returnOlive)
                }.returnCard()
                HStack(spacing: 12) {
                    MetricPill(value: formatMinutes(Int(baseline)), label: "today")
                    Image(systemName: "arrow.right").foregroundStyle(Color.returnStone)
                    MetricPill(value: formatMinutes(Int(target)), label: "goal")
                }
                Button("Create my program") {
                    appState.plan = ProgramPlan(startDate: Date(), baselineMinutes: Int(baseline), targetMinutes: Int(target), durationWeeks: Int(weeks)); step = 4
                }.buttonStyle(ReturnPrimaryButtonStyle())
            }.padding(24)
        }
    }

    private var protectionStep: some View {
        VStack(alignment: .leading, spacing: 22) {
            Spacer()
            Image(systemName: "shield.lefthalf.filled").font(.system(size: 48)).foregroundStyle(Color.returnOlive)
            Text("Choose what RETURN protects you from").font(.largeTitle.weight(.semibold)).foregroundStyle(Color.returnInk)
            Text("Apple's Screen Time framework lets you privately select apps and categories. RETURN receives opaque tokens rather than a readable list of your choices.")
                .font(.body).foregroundStyle(Color.returnStone).lineSpacing(4)
            Button(authorizationGranted ? "Screen Time access granted" : "Allow Screen Time access") {
                Task { authorizationGranted = await screenTime.requestAuthorization() }
            }.buttonStyle(ReturnPrimaryButtonStyle())
            Button("Select social apps") { showingPicker = true }
                .disabled(!authorizationGranted).font(.headline).foregroundStyle(Color.returnOlive).frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(Color.returnBone).clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            if let error = screenTime.authorizationError { Text(error).font(.footnote).foregroundStyle(Color.returnClay) }
            if screenTime.selectionCount > 0 {
                Label("\(screenTime.selectionCount) protected item\(screenTime.selectionCount == 1 ? "" : "s") selected", systemImage: "checkmark.circle.fill")
                    .font(.footnote.weight(.semibold)).foregroundStyle(Color.returnOlive)
            }
            Spacer()
            Button("Continue") { step = 5 }.buttonStyle(ReturnPrimaryButtonStyle())
                .disabled(!authorizationGranted || !screenTime.hasSelection).opacity(authorizationGranted && screenTime.hasSelection ? 1 : 0.5)
        }.padding(24)
    }

    private var completionStep: some View {
        VStack(alignment: .leading, spacing: 22) {
            Spacer()
            Text("You don't need to become a different person overnight.").font(.system(size: 37, weight: .semibold, design: .serif)).foregroundStyle(Color.returnInk)
            Text("You only need to make the next week more deliberate than the last one.").font(.title3).foregroundStyle(Color.returnStone)
            if let answer = appState.whyAnswers.last {
                VStack(alignment: .leading, spacing: 10) {
                    Text("You wrote:").font(.caption.weight(.semibold)).foregroundStyle(Color.returnStone)
                    Text("“\(answer.answer)”").font(.title3.weight(.medium)).foregroundStyle(Color.returnInk)
                }.returnCard()
            }
            Spacer()
            if let completionError { Text(completionError).font(.footnote).foregroundStyle(Color.returnClay) }
            Button("Start week one") {
                if screenTime.startDailyMonitoring(allowanceMinutes: appState.plan.currentAllowance) {
                    completionError = nil
                    Task { await NotificationManager.shared.requestAndSchedule(hour: appState.notificationHour) }
                    appState.onboardingComplete = true
                } else {
                    completionError = screenTime.monitoringError ?? "RETURN could not start Screen Time monitoring. Please try again."
                }
            }.buttonStyle(ReturnPrimaryButtonStyle())
        }.padding(24)
    }

    private func formatMinutes(_ minutes: Int) -> String {
        let hours = minutes / 60, remainder = minutes % 60
        if hours == 0 { return "\(remainder)m" }
        if remainder == 0 { return "\(hours)h" }
        return "\(hours)h \(remainder)m"
    }
}
