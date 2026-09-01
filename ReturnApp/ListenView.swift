import SwiftUI

struct ListenView: View {
    @StateObject private var narrator = AudioNarrator()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SectionHeader("Listen", subtitle: "Short audio sessions for urges, boredom, mornings, and the end of the day.")

                    ForEach(NarrationSession.library) { session in
                        Button {
                            narrator.toggle(session)
                        } label: {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(Color.returnOlive.opacity(0.13))
                                        .frame(width: 54, height: 54)
                                    Image(systemName: narrator.currentID == session.id && narrator.isSpeaking ? "pause.fill" : session.symbol)
                                        .font(.title3)
                                        .foregroundStyle(Color.returnOlive)
                                }
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(session.title).font(.headline).foregroundStyle(Color.returnInk)
                                    Text(session.subtitle).font(.subheadline).foregroundStyle(Color.returnStone).multilineTextAlignment(.leading)
                                    Text("\(session.minutes) min").font(.caption.weight(.semibold)).foregroundStyle(Color.returnOlive)
                                }
                                Spacer()
                            }
                            .returnCard()
                        }
                        .buttonStyle(.plain)
                    }

                    Text("Audio is generated on-device using the iPhone's built-in speech system. RETURN does not send these listening sessions to a server.")
                        .font(.footnote).foregroundStyle(Color.returnStone).padding(.top, 4)
                }
                .padding(20)
            }
            .background(Color.returnIvory)
            .navigationTitle("Listen")
        }
    }
}
