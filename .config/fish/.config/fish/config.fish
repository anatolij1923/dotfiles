if status is-interactive
    starship init fish | source
    zoxide init fish | source
    fzf --fish | source
    atuin init fish | source


    # install fisher automatically
    if not functions -q fisher
        echo "Fisher is not installed. Installing..."
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source

        fisher update
    end

end

fish_add_path /home/anatolij1923/.spicetify
fish_add_path $HOME/.local/bin/winapps
fish_add_path $HOME/.cargo/bin
fish_add_path "/home/anatolij1923/.local/share/pnpm"

