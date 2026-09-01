# RETURN 1.0 release checklist

## Codebase
- [x] Native SwiftUI app
- [x] Device Activity monitor extension
- [x] Shield configuration extension
- [x] Shield action extension
- [x] Family Controls/App Group entitlements in source
- [x] Privacy manifests for UserDefaults/App Group access
- [x] App icon asset catalog
- [x] Version/build-number settings
- [x] Unsigned cloud-build workflow
- [x] Project validation script
- [x] Program-plan unit tests
- [x] Reset stops Device Activity monitoring and clears shared Screen Time state
- [x] Weekly allowance resyncs when the app becomes active
- [x] Empty Screen Time selections cannot start protection
- [x] Immediate protection preview for user/App Review verification

## Requires developer account / device
- [ ] Replace placeholder bundle IDs with identifiers owned by your Apple Developer account
- [ ] Replace placeholder App Group with an App Group owned by your Apple Developer account
- [ ] Add your Apple Developer Team ID/signing configuration
- [ ] Register the main App ID and all three extension App IDs
- [ ] Register the App Group and attach it to the main app + Device Activity Monitor extension
- [ ] Request and receive Family Controls (Distribution) approval for the main app and each Screen Time API extension
- [ ] Generate App Store provisioning through automatic signing or CI signing
- [ ] Create the app record in App Store Connect
- [ ] Run a signed build on a physical iPhone
- [ ] Verify authorization, picker, daily monitoring, midnight reset, custom shield, and Open RETURN action
- [ ] Verify a weekly allowance change updates monitoring
- [ ] Run TestFlight testing on at least one physical iPhone
- [ ] Capture App Store screenshots from the shipping build
- [ ] Publish support and privacy-policy pages and enter their URLs in App Store Connect
- [ ] Complete App Privacy questionnaire
- [ ] Complete the current age-rating questionnaire
- [ ] Fill copyright/legal entity information
- [ ] Upload an archive built with the currently accepted Xcode/iOS SDK
- [ ] Add App Review notes and submit for review
