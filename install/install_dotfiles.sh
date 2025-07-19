#!/usr/bin/env bash

# --- Configuration ---
# The directory where your dotfile folders (like hyprland, kitty, nvim) are located.
# '..' means the parent directory of the 'install' script.
DOTFILES_SOURCE_DIR="../"
# The target directory for most configs.
CONFIG_TARGET_DIR="$HOME/.config"

# --- Pretty-printing functions (could be sourced from utils.sh) ---
print_header() {
  echo -e "\n\e[1;34m--- $1 ---\e[0m"
}
print_success() {
  echo -e "\e[1;32m✅ $1\e[0m"
}
print_info() {
  echo -e "\e[1;36m$1\e[0m"
}
print_warning() {
  echo -e "\e[1;33m⚠️ $1\e[0m"
}

# --- Find potential dotfile directories ---
# This looks for any directory in the source directory that contains a '.config' sub-directory.
mapfile -t available_dotfiles < <(find "$DOTFILES_SOURCE_DIR" -maxdepth 2 -type d -name ".config" | xargs -n 1 dirname | xargs -n 1 basename)

if [ ${#available_dotfiles[@]} -eq 0 ]; then
    print_warning "No dotfile directories found in '$DOTFILES_SOURCE_DIR'. Skipping dotfile installation."
    exit 0
fi

# --- User selection ---
print_header "Dotfile Selection"
echo "The following dotfile configurations were found:"
selected_dotfiles=()
for i in "${!available_dotfiles[@]}"; do
  read -p "  -> Install '${available_dotfiles[$i]}'? [Y/n]: " choice
  if [[ "$choice" != "n" && "$choice" != "N" ]]; then
    selected_dotfiles+=("${available_dotfiles[$i]}")
  fi
done

if [ ${#selected_dotfiles[@]} -eq 0 ]; then
    print_info "No dotfiles selected. Skipping."
    exit 0
fi

print_info "Will install the following dotfiles: ${selected_dotfiles[*]}"

# --- Backup and Copy ---
print_header "Backing up and installing selected dotfiles"

# Ensure the main .config directory exists
mkdir -p "$CONFIG_TARGET_DIR"

for dotfile_name in "${selected_dotfiles[@]}"; do
    source_dir="$DOTFILES_SOURCE_DIR/$dotfile_name/.config/"
    
    # Find all items (files and dirs) in the source .config directory
    mapfile -t items < <(find "$source_dir" -maxdepth 1 -mindepth 1)

    if [ ${#items[@]} -eq 0 ]; then
        print_warning "No config files found in '$source_dir' for '$dotfile_name'. Skipping."
        continue
    fi

    print_info "Processing '$dotfile_name'..."

    for item_path in "${items[@]}"; do
        item_name=$(basename "$item_path")
        target_path="$CONFIG_TARGET_DIR/$item_name"

        # If target exists, create a backup
        if [ -e "$target_path" ] || [ -L "$target_path" ]; then
            backup_name="$target_path.bak-$(date +%Y%m%d-%H%M%S)"
            print_warning "Existing config found at '$target_path'. Backing up to '$backup_name'."
            mv "$target_path" "$backup_name"
        fi

        # Copy the new config
        print_info "  -> Copying '$item_name' to '$CONFIG_TARGET_DIR/'"
        cp -r "$item_path" "$CONFIG_TARGET_DIR/"
    done
done

print_success "Dotfile installation complete."
