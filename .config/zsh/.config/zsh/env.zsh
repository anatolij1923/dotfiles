export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git" 
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {} | head -100'"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_OPTS="--preview 'eza -al --color=always {} | head -100'"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export STARSHIP_CONFIG=~/.config/starship/starship.toml
