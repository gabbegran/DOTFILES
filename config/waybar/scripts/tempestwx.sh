#!/bin/bash
# tempestwx.sh - Waybar weather widget for Tempest Weather System
#
# ============================================================================
# CONFIGURATION - Update these values for your Tempest station
# ============================================================================
#
# 1. Get your Station ID:
#    - Go to https://tempestwx.com and view your station
#    - Your station ID is in the URL: https://tempestwx.com/station/YOUR_ID/
#    - Example: https://tempestwx.com/station/12345/
#
# 2. Get your API Token:
#    - Go to https://tempestwx.com/settings/tokens
#    - Click "Create Token" and copy the generated token
#    - Demo token (limited access): 20c70eae-e62f-4d3b-b3a4-8586e90f3ac8
#
# Replace the values below with your own:

STATION_ID="YOUR_STATION_ID"
API_TOKEN="YOUR_API_TOKEN"

# ============================================================================
# End of configuration
# ============================================================================

# Get current conditions from Tempest API
content=$(curl -sS "https://swd.weatherflow.com/swd/rest/better_forecast?station_id=$STATION_ID&token=$API_TOKEN")

# Extract temperature and conditions
TEMP=$(echo $content | jq -r '.current_conditions.air_temperature')
CONDITIONS=$(echo $content | jq -r '.current_conditions.conditions')
ICON_NAME=$(echo $content | jq -r '.current_conditions.icon')

# Map icon names to emojis
case "$ICON_NAME" in
    "clear-day") ICON="☀️" ;;
    "clear-night") ICON="🌙" ;;
    "partly-cloudy-day") ICON="⛅" ;;
    "partly-cloudy-night") ICON="☁️" ;;
    "cloudy") ICON="☁️" ;;
    "rainy") ICON="🌧️" ;;
    "possibly-rainy-day"|"possibly-rainy-night") ICON="🌦️" ;;
    "snow") ICON="❄️" ;;
    "possibly-snow-day"|"possibly-snow-night") ICON="🌨️" ;;
    "thunderstorm") ICON="⛈️" ;;
    "windy") ICON="💨" ;;
    "foggy") ICON="🌫️" ;;
    *) ICON="🌡️" ;;
esac

# Format temperature in Fahrenheit
TEMP_F=$(echo "$TEMP" | awk '{printf "%.0f", ($1 * 9/5) + 32}')
TEMP_DISPLAY="${TEMP_F}°F"

echo "{\"text\": \"$ICON $TEMP_DISPLAY\", \"tooltip\": \"$ICON $TEMP_DISPLAY\\n$CONDITIONS\", \"class\": \"$CONDITIONS\" }"
