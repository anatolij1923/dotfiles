alias ls="eza -1  --color=always --group-directories-first --icons=always"
abbr -a ll "eza -la --color=always --icons=always --git"
abbr -a tree "eza --tree"

abbr -a cat bat
abbr -a ff fastfetch

abbr -a zj zellij

abbr -a sv "sudo nvim"
abbr -a v nvim
abbr -a hx helix

abbr -a gcl "git clone"
abbr -a ga "git add"
abbr -a gc "git commit"
abbr -a gp "git push"
abbr -a gu "git pull"
abbr -a lg lazygit

abbr -a update-mirrors "sudo reflector --sort rate --number 10 --threads 100 --protocol https --save /etc/pacman.d/mirrorlist"
abbr -a c clear

abbr -a p pnpm
abbr -a px pnpx
