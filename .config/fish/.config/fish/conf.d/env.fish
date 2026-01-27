# Disable greeting
set fish_greeting

# Load secret env
if test -f ~/.env.fish
    source ~/.env.fish
end

# For quickshell
set -gx QML_IMPORT_PATH /usr/lib/qt6/qml

# Fzf tab
set -gx FZF_COMPLETE 2

set -g FZF_DISABLE_KEYBINDINGS 0

# Starship config path
set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml

# colors
set -g fish_color_command green

# xdg dirs
set -gx XDG_PICTURES_DIR "$HOME/Изображения"
set -gx XDG_VIDEOS_DIR "$HOME/Видео"

set -gx LIBVIRT_DEFAULT_URI "qemu:///system"

set -gx ESP_PATH /boot/EFI/limine/
