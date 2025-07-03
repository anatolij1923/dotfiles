if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch
end

# Disable greeting
set fish_greeting

# Set proxy
set -gx http_proxy http://127.0.0.1:12334

if test -f ~/.env.fish
    source ~/.env.fish
end

oh-my-posh init fish --config ~/.config/ohmyposh/config.toml | source

# Zoxide
zoxide init fish | source

# FZF 
set -gx FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git" 

set -gx FZF_CTRL_T_OPTS "--preview 'bat --style=numbers --color=always {} | head -100'"
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

set -gx FZF_ALT_C_OPTS "--preview 'eza -al --color=always {} | head -100'"
set -gx FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"

fzf --fish | source

# --- Yazi Setup ---
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# Aliases
alias svim="sudo nvim"
alias v="nvim"

alias gcl="git clone"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gu="git pull"
alias lg="lazygit" 

alias ls="eza --no-filesize --long --color=always --icons=always --no-user"

alias update-mirrors="reflector --sort rate --number 10 --threads 100 --protocol https | sudo tee /etc/pacman.d/mirrorlist"

alias cat="bat"

# Functions
function mkcd
    mkdir -p $argv
    cd $argv
end

function arch_news_check
    echo "Latest news check:"
    curl -s https://archlinux.org/news/ \
        | grep -Eo 'href="/news/[^"]+"' \
        | cut -d'"' -f2 \
        | head -n 5 \
        | sed 's|^|https://archlinux.org|'
    echo

    read -l -P "Do you want to continue with the system upgrade? [y/N] " answer
    switch $answer
        case y Y
            sudo pacman -Syu
        case '*'
            echo "Upgrade cancelled."
    end
end


alias pacnews="arch_news_check"

