# Disable greeting
set fish_greeting

# Load secret env
if test -f ~/.env.fish
    source ~/.env.fish
end

# For quickshell
set -Ux QML_IMPORT_PATH /usr/lib/qt6/qml

# Fzf tab
set -gx FZF_COMPLETE 2

set -U FZF_DISABLE_KEYBINDINGS 0

# Starship config path
set -Ux STARSHIP_CONFIG ~/.config/starship/starship.toml

# colors
set -g fish_color_command green

set -Ux XDG_PICTURES_DIR "$HOME/Изображения"

set -Ux LIBVIRT_DEFAULT_URI "qemu:///system"
