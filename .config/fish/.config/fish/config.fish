if status is-interactive
    # Commands to run in interactive sessions can go here
    # fastfetch

    starship init fish | source
    zoxide init fish | source
    fzf --fish | source
    atuin init fish | source
end

fish_add_path /home/anatolij1923/.spicetify
fish_add_path $HOME/.local/bin/winapps
fish_add_path $HOME/.cargo/bin

# pnpm
set -gx PNPM_HOME "/home/anatolij1923/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
