import SwiftUI

struct WhyVaultView: View {
    @EnvironmentObject private var appState: AppState
    @State private var newAnswer = ""
    @State private var prompt = QuestionBank.continuing.randomElement() ?? QuestionBank.continuing[0]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment:.leading,spacing:20) {
                    SectionHeader("Why Vault", subtitle:"Your own words become the reminders RETURN gives back to you later.")
                    VStack(alignment:.leading,spacing:12) {
                        Text(prompt).font(.title3.weight(.medium))
                        TextEditor(text:$newAnswer).scrollContentBackground(.hidden).frame(minHeight:120).padding(10)
                            .background(Color.returnIvory.opacity(0.8)).clipShape(RoundedRectangle(cornerRadius:16,style:.continuous))
                        Button("Add to my vault") {
                            let trimmed = newAnswer.trimmingCharacters(in:.whitespacesAndNewlines)
                            guard !trimmed.isEmpty else { return }
                            appState.whyAnswers.insert(WhyAnswer(question:prompt,answer:trimmed),at:0)
                            newAnswer=""; prompt=QuestionBank.continuing.randomElement() ?? QuestionBank.continuing[0]
                        }.font(.headline).foregroundStyle(Color.returnOlive)
                    }.returnCard()
                    ForEach(appState.whyAnswers) { item in
                        VStack(alignment:.leading,spacing:10) {
                            Text(item.question).font(.caption.weight(.semibold)).foregroundStyle(Color.returnStone)
                            Text("“\(item.answer)”").font(.system(.title3,design:.serif,weight:.medium)).foregroundStyle(Color.returnInk)
                            Text(item.createdAt.formatted(date:.abbreviated,time:.omitted)).font(.caption2).foregroundStyle(Color.returnStone)
                        }.returnCard()
                    }
                }.padding(20)
            }.background(Color.returnIvory).navigationTitle("Why")
        }
    }
}
