if status is-interactive
    # Commands to run in interactive sessions can go here
    # fastfetch
end


fish_add_path /home/anatolij1923/.spicetify

# pnpm
set -gx PNPM_HOME "/home/anatolij1923/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
