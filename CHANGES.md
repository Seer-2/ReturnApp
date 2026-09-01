# Production-readiness pass — September 1, 2026

This pass focused on making RETURN safer to ship and easier to build without a local Mac.

## Screen Time reliability
- Prevents Device Activity monitoring from starting with an empty Family Activity selection.
- Persists protection state in the App Group so the monitor extension can distinguish enabled vs disabled protection.
- Reset now stops Device Activity monitoring, clears enforcement/preview stores, clears the opaque selection, and removes shared protection state.
- The app checks the current weekly allowance when it becomes active and replaces a stale/missing Device Activity schedule when needed.
- Changing protected items while protection is enabled refreshes the active monitoring event.
- Protection preview uses a separate ManagedSettings store so removing a preview cannot clear the daily enforcement store.
- The monitor validates the activity/event name, enabled state, and non-empty selection before shielding.

## Store/build readiness
- Added full Info.plist version/bundle metadata for app and extensions.
- Added required-reason privacy manifests for UserDefaults and App Group UserDefaults access.
- Added app icon asset set with a 1024px marketing icon and iPhone variants.
- Added version/build settings and an explicit XcodeGen scheme.
- Added ProgramPlan unit tests.
- Added a GitHub Actions macOS 26 / Xcode 26 unsigned build workflow.
- Added project validation and cross-platform Apple identifier configuration scripts.
- Reduced App Group entitlement scope to the main app and Device Activity Monitor extension only.

## App Store preparation
- Added App Store metadata draft.
- Added App Review notes with an immediate Screen Time shield verification flow.
- Added release checklist.
- Added hostable privacy policy and support pages.
- Removed MVP/developer-facing copy from the shipping UI and softened health-adjacent wording.
