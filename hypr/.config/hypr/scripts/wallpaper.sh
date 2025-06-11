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
matugen image "$WALLPAPER"

# 5. Create blurred wallpaper
# CACHE_DIR="$HOME/.config/1923/cache"
# BLURRED_WALLPAPER="$CACHE_DIR/blurred_wallpaper.png"
# BLUR_FILE="$HOME/.config/1923/settings/blur.sh"

# mkdir -p "$CACHE_DIR"

# Read blur strength from file or use default
# if [ -f "$BLUR_FILE" ]; then
    # BLUR_STRENGTH=$(cat "$BLUR_FILE")
# else
    # BLUR_STRENGTH="0x8"  
# fi

# Blur the wallpaper
# magick "$WALLPAPER" -resize 75% "$BLURRED_WALLPAPER"
# magick "$BLURRED_WALLPAPER" -blur "$BLUR_STRENGTH" "$BLURRED_WALLPAPER"

# echo "Blurred wallpaper saved to $BLURRED_WALLPAPER with blur strength $BLUR_STRENGTH"


# 6. Reload 
"$HOME/.config/hypr/scripts/reload.sh"
