#!/usr/bin/env python3
"""
Hyprland workspace icon manager - similar to sworkstyle for Sway
Dynamically renames workspaces based on running applications
"""

import json
import subprocess
import re
import sys
import os
from pathlib import Path

# Load icon mapping from sworkstyle config
def load_icon_config():
    config_path = Path.home() / ".config/sworkstyle/config.toml"
    icons = {}

    if not config_path.exists():
        return icons

    with open(config_path, 'r') as f:
        in_matching = False
        for line in f:
            line = line.strip()
            if line == '[matching]':
                in_matching = True
                continue
            if in_matching and line and not line.startswith('#'):
                # Parse TOML lines like: 'firefox' = ' '
                match = re.match(r"'([^']+)'\s*=\s*'([^']*)'", line)
                if match:
                    pattern, icon = match.groups()
                    icons[pattern] = icon

    return icons

def get_workspaces():
    """Get all workspaces from Hyprland"""
    result = subprocess.run(['hyprctl', 'workspaces', '-j'], capture_output=True, text=True)
    return json.loads(result.stdout)

def get_clients():
    """Get all clients from Hyprland"""
    result = subprocess.run(['hyprctl', 'clients', '-j'], capture_output=True, text=True)
    return json.loads(result.stdout)

def match_icon(window_class, title, icons):
    """Match window to icon based on class or title"""
    # First try exact class match
    if window_class in icons:
        return icons[window_class]

    # Try case-insensitive class match
    for pattern, icon in icons.items():
        if pattern.lower() == window_class.lower():
            return icon

    # Try regex pattern matching on title
    for pattern, icon in icons.items():
        if pattern.startswith('/') and pattern.endswith('/'):
            regex = pattern[1:-1]
            if re.search(regex, title, re.IGNORECASE):
                return icon

    return None

def get_workspace_icons(workspaces, clients, icon_mapping):
    """Determine icons for each workspace based on windows"""
    workspace_icons = {}

    for ws in workspaces:
        ws_id = ws['id']
        ws_name = ws['name']

        # Get all clients in this workspace
        ws_clients = [c for c in clients if c['workspace']['id'] == ws_id]

        # Collect unique icons for this workspace
        icons = []
        seen_classes = set()

        for client in ws_clients:
            window_class = client.get('class', '')
            title = client.get('title', '')

            if window_class and window_class not in seen_classes:
                icon = match_icon(window_class, title, icon_mapping)
                if icon:
                    icons.append(icon)
                    seen_classes.add(window_class)

        # Create workspace name: number + icons
        if icons:
            # Use unique=true behavior from sworkstyle
            unique_icons = []
            for icon in icons:
                if icon not in unique_icons:
                    unique_icons.append(icon)
            workspace_name = f"{ws_id} {' '.join(unique_icons)}"
        else:
            # Fallback to just the number (empty fallback from config)
            workspace_name = str(ws_id)

        workspace_icons[ws_id] = workspace_name

    return workspace_icons

def rename_workspaces(workspace_icons):
    """Rename workspaces using hyprctl"""
    for ws_id, new_name in workspace_icons.items():
        subprocess.run(['hyprctl', 'dispatch', 'renameworkspace', str(ws_id), new_name],
                      capture_output=True)

def main():
    icon_mapping = load_icon_config()

    if not icon_mapping:
        print("Warning: No icon mapping found in ~/.config/sworkstyle/config.toml", file=sys.stderr)

    # Initial update
    workspaces = get_workspaces()
    clients = get_clients()
    workspace_icons = get_workspace_icons(workspaces, clients, icon_mapping)
    rename_workspaces(workspace_icons)

    # Listen to Hyprland events for continuous updates
    runtime_dir = os.getenv('XDG_RUNTIME_DIR', '/run/user/1000')
    socket_path = f'{runtime_dir}/hypr/{os.getenv("HYPRLAND_INSTANCE_SIGNATURE")}/.socket2.sock'
    proc = subprocess.Popen(['socat', '-U', '-', f'UNIX-CONNECT:{socket_path}'],
                           stdout=subprocess.PIPE, text=True)

    try:
        for line in proc.stdout:
            event = line.strip()
            # Update on window open/close/move events
            if any(e in event for e in ['openwindow', 'closewindow', 'movewindow', 'workspace']):
                workspaces = get_workspaces()
                clients = get_clients()
                workspace_icons = get_workspace_icons(workspaces, clients, icon_mapping)
                rename_workspaces(workspace_icons)
    except KeyboardInterrupt:
        pass
    finally:
        proc.terminate()

if __name__ == '__main__':
    main()
