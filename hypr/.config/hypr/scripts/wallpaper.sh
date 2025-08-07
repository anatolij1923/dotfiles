#!/bin/bash

# 1. Path to waypaper config
WALLPAPER=$(grep "^wallpaper *= *" "$HOME/.config/waypaper/config.ini" | sed 's/wallpaper *= *//' | sed "s|~|$HOME|")

# 2. Path to hyprlock config
HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"

# 3. Update wallpaper path in hyprlock config
awk -v new_path="$WALLPAPER" '
/^\s*background\s*{/ { in_block=1 }
in_block && /^\s*path\s*=/ { sub(/path\s*=.*/, "path = " new_path) }
in_block && /^\s*}/ { in_block=0 }
{ print }
' "$HYPRLOCK_CONFIG" > "$HYPRLOCK_CONFIG.tmp" && mv "$HYPRLOCK_CONFIG.tmp" "$HYPRLOCK_CONFIG"

echo "WALLPAPER = $WALLPAPER"

# 4. Generate palette with matugen
matugen -m dark image "$WALLPAPER"

# 5. Reload 
# "$HOME/.config/hypr/scripts/reload.sh"
