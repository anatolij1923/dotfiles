# utils
alias ff="fastfetch"
alias cat="bat"

# list directories
alias ls="eza --no-filesize --long --color=always --icons=always --no-user"
alias tree="eza --tree"

# neovim
alias v="nvim"
alias sv="sudo nvim"

# misc
alias update-mirrors="reflector --sort rate --number 10 --threads 100 --protocol https | sudo tee /etc/pacman.d/mirrorlist"
alias c="clear"
alias cleanup="yay -Sc"
alias zr="source $ZDOTDIR/.zshrc"

# git
alias lg="lazygit"
alias gcl="git clone"
alias ga="git add"
alias gcm="git commit -m"
alias gp="git push"
alias gpull="git pull"
