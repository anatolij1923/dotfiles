# Disable greeting
set fish_greeting

# Load secret env
if test -f ~/.env.fish
    source ~/.env.fish
end

# Set proxy
set -gx http_proxy http://127.0.0.1:12334

# For quickshell
set -Ux QML_IMPORT_PATH /usr/lib/qt6/qml

# Fzf tab
set -gx FZF_COMPLETE 2

set -U FZF_DISABLE_KEYBINDINGS 0