#!/usr/bin/env bash

# Function to check if a package is installed
is_installed() {
  pacman -Qi "$1" &> /dev/null
}

# Function to check if a package is installed
is_group_installed() {
  pacman -Qg "$1" &> /dev/null
}

# Function to install packages if not already installed
install_packages() {
  local packages=("$@")
  local to_install=()

  for pkg in "${packages[@]}"; do
    if ! is_installed "$pkg" && ! is_group_installed "$pkg"; then
      to_install+=("$pkg")
    fi
  done

  if [ ${#to_install[@]} -ne 0 ]; then
    echo "Installing: ${to_install[*]}"
    yay -S --noconfirm "${to_install[@]}"
  fi
} 

# Function to execute a command with retry/skip/exit 
try() {
  while true; do
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
      echo "Error: Command \"$@\" failed with status $status."
      read -p "Do you want to (r)etry, (s)kip, or (e)xit? " choice
      case "$choice" in
        r|R ) continue;; # Retry the command 
        s|S ) return 0;; # Skip 
        e|E ) exit 1;;   # Exit the script entirely
        * ) echo "Invalid choice. Please enter r, s, or e.";;
      esac
    else
      return 0 # Command succeeded, exit the function successfully
    fi
  done
}
