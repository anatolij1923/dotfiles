# Disable greeting
set fish_greeting

# Load secret env
if test -f ~/.env.fish
    source ~/.env.fish
end

# Fzf tab
set -gx FZF_COMPLETE 2
set -g FZF_DISABLE_KEYBINDINGS 0

# Starship config path
set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml

# colors
set -g fish_color_command green

set -gx LIBVIRT_DEFAULT_URI "qemu:///system"
set -gx EDITOR nvim
