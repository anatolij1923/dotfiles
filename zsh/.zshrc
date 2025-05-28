export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git z zsh-autosuggestions zsh-syntax-highlighting thefuck fzf-tab)

source $ZSH/oh-my-zsh.sh


# Load configs
for config_file in $HOME/.config/zsh/*.zsh; do
        if [ -f "$config_file" ]; then
            source "$config_file"
        fi
done

# Prompt
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.toml)"

source <(fzf --zsh)
eval "$(zoxide init zsh)"
