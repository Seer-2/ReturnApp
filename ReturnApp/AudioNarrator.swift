import AVFoundation
import Combine
import Foundation

@MainActor
final class AudioNarrator: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var isSpeaking = false
    @Published var currentID: String?
    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func toggle(_ session: NarrationSession) {
        if isSpeaking && currentID == session.id {
            synthesizer.stopSpeaking(at: .immediate)
            isSpeaking = false
            currentID = nil
            return
        }
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: session.script)
        utterance.rate = 0.46
        utterance.pitchMultiplier = 0.96
        utterance.volume = 0.95
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        currentID = session.id
        isSpeaking = true
        synthesizer.speak(utterance)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) { isSpeaking = false; currentID = nil }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) { isSpeaking = false; currentID = nil }
}
