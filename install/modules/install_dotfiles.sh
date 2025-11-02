#!/bin/bash

# Source utility functions
# Function to install dotfiles using stow
install_dotfiles_with_stow() {
  local SCRIPT_ROOT_DIR="$1"
  source "$SCRIPT_ROOT_DIR/utils.sh"
  local dotfiles_dir="$SCRIPT_ROOT_DIR" 

  log_info "Starting dotfiles installation with stow..."

  # Ensure stow is installed
  if ! check_command_exists "stow"; then
    log_info "Stow not found. Attempting to install stow..."
    log_warn "Stow is not installed. Please ensure 'stow' is included in your essential.conf and installed."
  fi

  log_info "Using current directory ($dotfiles_dir) as dotfiles repository. Skipping clone."

  # Change to dotfiles repository root
  (
    cd "$dotfiles_dir/.config" || log_error "Failed to change directory to $dotfiles_dir/.config."

    log_info "Processing dotfiles with stow..."

    local stow_config_file="$SCRIPT_ROOT_DIR/install/config/stow_packages.conf"
    if [ ! -f "$stow_config_file" ]; then
      log_error "Stow configuration file not found: $stow_config_file"
    fi

    . "$stow_config_file" # Source the config file to load STOW_PACKAGES array

    if [ ${#STOW_PACKAGES[@]} -eq 0 ]; then
      log_warn "No packages specified in $stow_config_file. Skipping dotfiles stow operation."
      return 0
    fi

    for package in "${STOW_PACKAGES[@]}"; do
      if [ -d "$package" ]; then # Check if the package directory exists in the dotfiles repo
        log_info "Processing package: $package"

        # Check for conflicting files and offer backup
        local conflicts=$(stow -n -t ~ "$package" 2>&1 | grep "would conflict")
        if [ -n "$conflicts" ]; then
          log_warn "Conflicts detected for package '$package'. Existing files will be overwritten or moved."
          read -p "Do you want to backup conflicting files before stowing? (y/N): " backup_choice
          if [[ "$backup_choice" =~ ^[Yy]$ ]]; then
            local backup_dir="$HOME/dotfiles_backup_$(date +%Y%m%d%H%M%S)"
            try mkdir -p "$backup_dir" || log_error "Failed to create backup directory."
            log_info "Backing up conflicting files to $backup_dir..."
            log_warn "Automatic backup of conflicting files is a best-effort attempt. Please review manually if critical."
            log_info "Skipping detailed file-by-file backup due to complexity. User should manually backup if concerned."
          else
            log_warn "Skipping backup for package '$package'. Existing files might be overwritten."
          fi
        fi

        try stow -t ~ "$package" || log_warn "Failed to stow package: $package. Continuing..."
        log_success "Package '$package' stowed successfully."
      else
        log_warn "Dotfile package directory not found: $package. Skipping."
      fi
    done
  )

  log_warn "IMPORTANT: Any changes made to the symlinked dotfiles will be part of the cloned repository."
  log_warn "Updating the repository (e.g., 'git pull') might lead to conflicts if you have local modifications."
  log_warn "You are responsible for resolving any such conflicts."
  log_success "Dotfiles installation with stow complete."
}
