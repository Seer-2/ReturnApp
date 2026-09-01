#!/usr/bin/env python3
from __future__ import annotations
import argparse
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]

def replace_in_file(path:Path,replacements:dict[str,str])->None:
    text=path.read_text(encoding="utf-8")
    for old,new in replacements.items(): text=text.replace(old,new)
    path.write_text(text,encoding="utf-8")

def main()->None:
    parser=argparse.ArgumentParser()
    parser.add_argument("--bundle-id",required=True,help="Main app bundle ID, e.g. com.example.return")
    parser.add_argument("--app-group",required=True,help="App Group, e.g. group.com.example.return.shared")
    parser.add_argument("--team-id",required=True,help="10-character Apple Developer Team ID")
    args=parser.parse_args()
    bundle_id=args.bundle_id.strip(); app_group=args.app_group.strip(); team_id=args.team_id.strip()
    if not bundle_id or bundle_id.endswith(".") or " " in bundle_id: raise SystemExit("Invalid --bundle-id")
    if not app_group.startswith("group.") or " " in app_group: raise SystemExit("--app-group must start with 'group.'")
    if len(team_id)!=10 or not team_id.isalnum(): raise SystemExit("--team-id should be the 10-character Apple Developer Team ID")
    project=ROOT/"project.yml"; text=project.read_text(encoding="utf-8")
    text=text.replace('DEVELOPMENT_TEAM: ""',f'DEVELOPMENT_TEAM: "{team_id}"')
    text=text.replace("com.returnfocus.app.DeviceActivityMonitor",f"{bundle_id}.DeviceActivityMonitor")
    text=text.replace("com.returnfocus.app.ShieldConfiguration",f"{bundle_id}.ShieldConfiguration")
    text=text.replace("com.returnfocus.app.ShieldAction",f"{bundle_id}.ShieldAction")
    text=text.replace("com.returnfocus.app.tests",f"{bundle_id}.tests")
    text=text.replace("com.returnfocus.app",bundle_id); project.write_text(text,encoding="utf-8")
    for relative in ["ReturnApp/ReturnApp.entitlements","DeviceActivityMonitorExtension/DeviceActivityMonitorExtension.entitlements","Shared/SharedScreenTime.swift"]:
        replace_in_file(ROOT/relative,{"group.com.returnfocus.shared":app_group})
    print("Configured RETURN identifiers:")
    print(f"  Main app: {bundle_id}"); print(f"  Monitor:  {bundle_id}.DeviceActivityMonitor")
    print(f"  Shield UI:{bundle_id}.ShieldConfiguration"); print(f"  Action:   {bundle_id}.ShieldAction")
    print(f"  App Group:{app_group}"); print(f"  Team ID:  {team_id}")
    print("\nRun this script only once on a fresh placeholder-configured checkout.")

if __name__=="__main__": main()
