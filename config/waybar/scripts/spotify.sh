#!/bin/bash

# Only track Spotify — ignore everything else
PLAYER="spotify"

STATUS=$(playerctl --player=$PLAYER status 2>/dev/null)

if [ -z "$STATUS" ]; then
    # Spotify not running
    printf '{"text":"󰓇  —","class":"stopped"}\n'
    exit 0
fi

ARTIST=$(playerctl --player=$PLAYER metadata artist 2>/dev/null)
TITLE=$(playerctl --player=$PLAYER metadata title 2>/dev/null)

# Truncate long strings
MAX=28
if [ ${#TITLE} -gt $MAX ]; then
    TITLE="${TITLE:0:$MAX}…"
fi
if [ ${#ARTIST} -gt 18 ]; then
    ARTIST="${ARTIST:0:18}…"
fi

if [ "$STATUS" = "Playing" ]; then
    ICON="󰓇"
    CLASS="playing"
elif [ "$STATUS" = "Paused" ]; then
    ICON="󰓇"
    CLASS="paused"
else
    ICON="󰓇"
    CLASS="stopped"
fi

if [ -n "$TITLE" ] && [ -n "$ARTIST" ]; then
    printf '{"text":"%s  %s — %s","class":"%s"}\n' "$ICON" "$TITLE" "$ARTIST" "$CLASS"
elif [ -n "$TITLE" ]; then
    printf '{"text":"%s  %s","class":"%s"}\n' "$ICON" "$TITLE" "$CLASS"
else
    printf '{"text":"%s  —","class":"%s"}\n' "$ICON" "$CLASS"
fi
