#!/bin/bash
set -euo pipefail
for plist in ReturnApp/Info.plist DeviceActivityMonitorExtension/Info.plist ShieldActionExtension/Info.plist ShieldConfigurationExtension/Info.plist ReturnApp/PrivacyInfo.xcprivacy DeviceActivityMonitorExtension/PrivacyInfo.xcprivacy; do
  plutil -lint "$plist"
done
required=("com.apple.deviceactivity.monitor-extension" "com.apple.ManagedSettings.shield-action-service" "com.apple.ManagedSettingsUI.shield-configuration-service" "com.apple.developer.family-controls" "group.com.returnfocus.shared")
for value in "${required[@]}"; do
  if ! grep -Rqs "$value" . --exclude-dir=.git; then echo "Missing required project value: $value" >&2; exit 1; fi
done
test -f ReturnApp/Assets.xcassets/AppIcon.appiconset/Contents.json
echo "Project structure validation passed."
