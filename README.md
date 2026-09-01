# RETURN

RETURN is a local-first SwiftUI iPhone app for gradually reducing distracting social-media use. It combines a personalized weekly taper, private Screen Time enforcement, reflection prompts, a Why Vault, and on-device narrated reset sessions.

## Architecture

- iOS 17+ SwiftUI application
- `FamilyControls` for individual authorization and privacy-preserving app/category selection
- `DeviceActivity` for daily threshold monitoring
- `ManagedSettings` for shielding selected apps/categories/web domains
- `ManagedSettingsUI` custom shield configuration
- App Group storage for opaque FamilyActivitySelection tokens and protection configuration
- Local `UserDefaults` storage for the user's taper plan, reflections, and Why Vault
- `AVSpeechSynthesizer` for on-device audio sessions
- Local notifications for the evening reflection reminder

## Build without owning a Mac

The repository is designed to use GitHub Actions as the cloud Mac. The workflow in `.github/workflows/ios-ci.yml` runs on `macos-26`, installs XcodeGen, generates the Xcode project, validates the plist/privacy configuration, and performs an unsigned iOS Simulator build.

For local Mac development, install XcodeGen and run:

```bash
xcodegen generate
open ReturnApp.xcodeproj
```

## Before signed device/TestFlight builds

The identifiers in `project.yml` and the `.entitlements` files are placeholders. On your Dell, after you create the Apple identifiers, you can configure them without Xcode:

```bash
python scripts/configure_identifiers.py --bundle-id com.yourcompany.return --app-group group.com.yourcompany.return.shared --team-id YOURTEAMID
```

Then register the App Group and configure Family Controls for the app and Screen Time extensions in your Apple Developer account.

Distribution requires Apple's Family Controls distribution entitlement for the main app and each included Screen Time API extension.

## Privacy manifests

The main app declares both app-only UserDefaults access and App Group UserDefaults access. The Device Activity Monitor extension declares App Group UserDefaults access. The current app contains no third-party SDKs, analytics, ads, or developer-operated backend.

## Release materials

See `AppStore/` for metadata, App Review notes, and the release checklist. `docs/` contains a privacy policy and support page ready to host after replacing the support-email placeholder.
