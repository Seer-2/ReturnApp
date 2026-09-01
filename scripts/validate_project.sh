#!/bin/bash
set -euo pipefail

python3 scripts/generate_app_icons.py

for plist in ReturnApp/Info.plist DeviceActivityMonitorExtension/Info.plist ShieldActionExtension/Info.plist ShieldConfigurationExtension/Info.plist ReturnApp/PrivacyInfo.xcprivacy DeviceActivityMonitorExtension/PrivacyInfo.xcprivacy; do
  plutil -lint "$plist"
done

required=("com.apple.deviceactivity.monitor-extension" "com.apple.ManagedSettings.shield-action-service" "com.apple.ManagedSettingsUI.shield-configuration-service" "com.apple.developer.family-controls" "group.com.returnfocus.shared")
for value in "${required[@]}"; do
  if ! grep -Rqs "$value" . --exclude-dir=.git; then
    echo "Missing required project value: $value" >&2
    exit 1
  fi
done

for size in 40 58 60 80 87 120 180 1024; do
  test -f "ReturnApp/Assets.xcassets/AppIcon.appiconset/AppIcon-${size}.png"
done

echo "Project structure validation passed."
