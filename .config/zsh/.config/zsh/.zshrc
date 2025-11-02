# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob notify
unsetopt beep nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$ZDOTDIR/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Aliases
[[ -f ~/.config/zsh/aliases.zsh ]] && source ~/.config/zsh/aliases.zsh

# Env vars
[[ -f ~/.config/zsh/env.zsh ]] && source ~/.config/zsh/env.zsh

[[ -f ~/.env.zsh ]] && source ~/.env.zsh

[[ -f ~/.config/zsh/bindkeys.zsh ]] && source ~/.config/zsh/bindkeys.zsh

# Functions
for function in ~/.config/zsh/functions/*.zsh; do
    source $function
done

# zinit plugin manager
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# starship prompt
eval "$(starship init zsh)"

# zoxide init
eval "$(zoxide init zsh)"

# fzf init
source <(fzf --zsh)

# zinit plugins
zinit light zsh-users/zsh-syntax-highlighting.git
zinit light zsh-users/zsh-completions.git
zinit light zsh-users/zsh-autosuggestions.git
zinit light Aloxaf/fzf-tab
zinit light junegunn/fzf
