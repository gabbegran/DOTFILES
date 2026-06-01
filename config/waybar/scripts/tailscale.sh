#!/bin/bash

# Check if tailscale is reachable
if ! command -v tailscale &> /dev/null; then
    echo "{\"text\": \"?\", \"class\": \"error\", \"tooltip\": \"Tailscale not found\"}"
    exit 0
fi

# Get status, suppressing stderr (warnings about version mismatch)
STATUS=$(tailscale status --json 2>/dev/null | jq -r .BackendState 2>/dev/null)

if [ "$STATUS" = "Running" ]; then
    ICON="𓃑"
    CLASS="connected"
    TOOLTIP="Tailscale: Connected"
elif [ "$STATUS" = "Stopped" ]; then
    ICON="𓃑"
    CLASS="disconnected"
    TOOLTIP="Tailscale: Stopped"
elif [ "$STATUS" = "NeedsLogin" ]; then
    ICON="!"
    CLASS="needs-login"
    TOOLTIP="Tailscale: Needs Login"
else
    ICON=""
    CLASS="unknown"
    TOOLTIP="Tailscale: $STATUS"
fi

echo "{\"text\": \"$ICON\", \"class\": \"$CLASS\", \"tooltip\": \"$TOOLTIP\"}"
