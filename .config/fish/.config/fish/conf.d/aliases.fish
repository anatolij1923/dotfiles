# List directories
abbr -a ls "eza -1  --color=always --icons=always"
abbr -a ll "eza -la --color=always --icons=always --git"
abbr -a tree "eza --tree"

# Utilities
abbr -a cat "bat"
abbr -a ff "fastfetch"

# Zellij
abbr -a zj "zellij"

# Neovim
abbr -a svim "sudo -E nvim"
abbr -a v "nvim"

# Git
abbr -a gcl "git clone"
abbr -a ga "git add"
abbr -a gc "git commit"
abbr -a gp "git push"
abbr -a gu "git pull"
abbr -a lg "lazygit" 

# Misc
abbr -a update-mirrors "sudo reflector --sort rate --number 10 --threads 100 --protocol https --save /etc/pacman.d/mirrorlist"
abbr -a c "clear"

# Pnpm
abbr -a p "pnpm"
abbr -a px "pnpx"
