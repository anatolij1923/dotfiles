# custom promt initiatlization
# starship init fish | source

# # Zoxide initialization
# zoxide init fish | source

# FZF 
set -gx FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git" 

set -gx FZF_CTRL_T_OPTS "--preview 'bat --style=numbers --color=always {} | head -100'"
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

set -gx FZF_ALT_C_OPTS "--preview 'eza -al --color=always {} | head -100'"
set -gx FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# fzf --fish | source

# autism
# atuin init fish | source
