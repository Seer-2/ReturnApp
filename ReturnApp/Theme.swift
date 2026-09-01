import SwiftUI

extension Color {
    static let returnOlive = Color(red: 0x6F/255, green: 0x77/255, blue: 0x54/255)
    static let returnSage = Color(red: 0xAA/255, green: 0xB3/255, blue: 0x9A/255)
    static let returnIvory = Color(red: 0xF4/255, green: 0xF0/255, blue: 0xE7/255)
    static let returnBone = Color(red: 0xE9/255, green: 0xE4/255, blue: 0xD9/255)
    static let returnInk = Color(red: 0x20/255, green: 0x23/255, blue: 0x1D/255)
    static let returnStone = Color(red: 0x73/255, green: 0x76/255, blue: 0x6D/255)
    static let returnClay = Color(red: 0xB9/255, green: 0x79/255, blue: 0x5F/255)
    static let returnGold = Color(red: 0xB4/255, green: 0x9A/255, blue: 0x68/255)
}
struct ReturnCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.padding(18).background(Color.returnBone.opacity(0.75)).clipShape(RoundedRectangle(cornerRadius:24,style:.continuous))
    }
}
extension View { func returnCard() -> some View { modifier(ReturnCardModifier()) } }
struct ReturnPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline).foregroundStyle(Color.returnIvory).frame(maxWidth:.infinity).padding(.vertical,15)
            .background(Color.returnOlive.opacity(configuration.isPressed ? 0.82 : 1))
            .clipShape(RoundedRectangle(cornerRadius:18,style:.continuous))
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
    }
}
