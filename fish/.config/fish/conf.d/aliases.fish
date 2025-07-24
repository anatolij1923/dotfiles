# --- Aliases ---

# List directories
alias ls="eza --no-filesize --long --color=always --icons=always --no-user"
alias tree="eza --tree"

# Utilities
alias cat="bat"

# Neovim
alias svim="sudo nvim"
alias v="nvim"

# Git
alias gcl="git clone"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gu="git pull"
alias lg="lazygit" 

# Misc
alias update-mirrors="reflector --sort rate --number 10 --threads 100 --protocol https | sudo tee /etc/pacman.d/mirrorlist"
alias c="clear"
