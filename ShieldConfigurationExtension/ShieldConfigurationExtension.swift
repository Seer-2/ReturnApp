import ManagedSettings
import ManagedSettingsUI
import UIKit

final class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    private let olive = UIColor(red:111/255,green:119/255,blue:84/255,alpha:1)
    private let ivory = UIColor(red:244/255,green:240/255,blue:231/255,alpha:1)
    private let ink = UIColor(red:32/255,green:35/255,blue:29/255,alpha:1)

    private var returnShield: ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle:.systemMaterial,
            backgroundColor:ivory,
            icon:UIImage(systemName:"arrow.uturn.backward.circle.fill"),
            title:ShieldConfiguration.Label(text:"Pause before you go in",color:ink),
            subtitle:ShieldConfiguration.Label(text:"You reached today's planned allowance. Open RETURN if you want to reflect before deciding what happens next.",color:ink.withAlphaComponent(0.72)),
            primaryButtonLabel:ShieldConfiguration.Label(text:"Open RETURN",color:ivory),
            primaryButtonBackgroundColor:olive,
            secondaryButtonLabel:ShieldConfiguration.Label(text:"Not now",color:olive)
        )
    }
    override func configuration(shielding application:Application)->ShieldConfiguration{returnShield}
    override func configuration(shielding application:Application,in category:ActivityCategory)->ShieldConfiguration{returnShield}
    override func configuration(shielding webDomain:WebDomain)->ShieldConfiguration{returnShield}
    override func configuration(shielding webDomain:WebDomain,in category:ActivityCategory)->ShieldConfiguration{returnShield}
}
