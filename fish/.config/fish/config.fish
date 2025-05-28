if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch
end

# Disable greeting
set fish_greeting

# Set proxy
# set -gx http_proxy http://127.0.0.1:12334

oh-my-posh init fish --config ~/.config/ohmyposh/config.toml | source

# FZF 
fzf --fish | source

# Aliases
alias svim="sudo nvim"
alias v="nvim"

# Functions
function mkcd
    mkdir -p $argv
    cd $argv
end

