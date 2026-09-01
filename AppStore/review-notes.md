# App Review notes — draft

RETURN is a self-directed productivity app that uses Apple's Screen Time APIs. It requests Family Controls authorization for the individual device owner and uses opaque FamilyActivitySelection tokens. It does not use FamilyActivityData or request access to readable installed-app identifiers.

The app contains these Screen Time API extensions:
- DeviceActivityMonitorExtension
- ShieldConfigurationExtension
- ShieldActionExtension

All four relevant bundle IDs (the main app and three extensions) require the Family Controls distribution entitlement before TestFlight/App Store distribution.

## Reviewer test flow
1. Launch RETURN and complete onboarding.
2. On the protection step, approve Screen Time access.
3. Select at least one app or category in Apple's Family Activity picker.
4. Finish onboarding to start the daily Device Activity monitor.
5. To verify shielding immediately without waiting for the daily threshold, open Settings > Preview protection > Show protection now.
6. Open one of the selected apps. The custom RETURN shield should appear.
7. Tap Open RETURN on the shield to return to the app.
8. In RETURN Settings, tap Remove preview shield to clear the temporary preview.

The preview action exists only to let users confirm that their Screen Time configuration is working; it does not modify the configured daily allowance.

## Privacy behavior
- Why Vault entries and reflections are saved locally with UserDefaults.
- FamilyActivitySelection is encoded into the app's private App Group so the DeviceActivityMonitor extension can apply the selected opaque tokens.
- No analytics, advertising SDK, account system, cloud database, or third-party tracking SDK is included.
- Audio sessions use AVSpeechSynthesizer on-device.
