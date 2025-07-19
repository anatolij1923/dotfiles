#!/usr/bin/env bash

# Exit on any error in non-interactive mode
set -e

# --- Source utilities and configurations ---
source ./utils.sh
source ./services.conf

# --- Pretty-printing functions ---
print_header() {
  echo -e "\n\e[1;34m--- $1 ---\e[0m"
}

print_success() {
  echo -e "\e[1;32m✅ $1\e[0m"
}

print_info() {
  echo -e "\e[1;36m$1\e[0m"
}

# --- Global state ---
CONFIRM_MODE=false

# --- Core installation logic ---

install_yay() {
  if ! command -v yay &> /dev/null; then
    print_info "Installing yay AUR helper..."
    sudo pacman -S --needed git base-devel --noconfirm
    if [[ -d "yay" ]]; then
      rm -rf yay
    fi
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
  else
    print_success "yay is already installed."
  fi
}

run_install_packages() {
    local group_name="$1"
    shift
    local packages=("$@")
    if [ ${#packages[@]} -gt 0 ]; {
        print_info "Installing $group_name..."
        install_packages "${packages[@]}"
    }
    fi
}

# Placeholder for dotfiles installation
install_dotfiles() {
    print_header "Installing Dotfiles"
    # Logic for this will be in install_dotfiles.sh
    . ./install_dotfiles.sh
}

# Function to enable systemd services
enable_services() {
    print_header "Enabling Systemd Services"
    local to_enable=()
    for service in "${SERVICES[@]}"; do
        if ! systemctl is-enabled --quiet "$service"; then
            to_enable+=("$service")
        fi
    done

    if [ ${#to_enable[@]} -ne 0 ]; then
        print_info "Enabling services: ${to_enable[*]}"
        sudo systemctl enable --now "${to_enable[@]}"
    else
        print_success "All required services are already enabled."
    fi
}


# --- Main execution flow ---

main() {
  clear
  print_header "Anatolij's Dotfiles Installer"

  # --- Mode selection ---
  echo "Please choose an installation mode:"
  echo "  [1] Minimal (essential packages only)"
  echo "  [2] Full (essential + extra packages)"
  echo "  [3] Custom (select categories)"
  read -p "Enter your choice [1-3]: " mode

  # --- Confirmation mode ---
  read -p "Enable step-by-step confirmation? [y/N]: " confirm
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    CONFIRM_MODE=true
    # Redefine try function to include confirmation
    try() {
        read -p "Press Enter to execute: '$@' or (s) to skip..." choice
        if [[ "$choice" == "s" || "$choice" == "S" ]]; then
            return 0
        fi
        
        "$@"
        local status=$?
        if [ $status -ne 0 ]; then
            echo "Error: Command \"$@\" failed with status $status."
            while true; do
            read -p "Do you want to (r)etry, (s)kip, or (e)xit? " choice
            case "$choice" in
                r|R ) try "$@"; return;;
                s|S ) return;;
                e|E ) exit 1;;
                * ) echo "Invalid choice. Please enter r, s, or e.";;
            esac
            done
        fi
        return 0
    }
  fi

  # --- Load package lists based on mode ---
  source ./essential_packages.conf

  case "$mode" in
    1) # Minimal
      print_info "Minimal installation selected."
      ;;
    2) # Full
      print_info "Full installation selected."
      source ./extra_packages.conf
      ;;
    3) # Custom
      # TODO: Implement custom selection logic
      print_info "Custom installation is not yet implemented. Proceeding with Full install."
      source ./extra_packages.conf
      ;;
    *)
      echo "Invalid choice. Exiting."
      exit 1
      ;;
  esac

  # --- Combine package lists ---
  # This handles the case where a group exists in both files.
  # We source essential first, then extra, then add them up.
  # A cleaner way is to ensure unique variable names, but this is robust.
  
  # Let's assume unique names for now as it's cleaner.
  # If CLI_UTILS is in essential and EXTRA_CLI_UTILS is in extra:
  # ALL_CLI_UTILS=("${CLI_UTILS[@]}" "${EXTRA_CLI_UTILS[@]}")

  # --- Start installation ---
  print_header "Starting Installation"
  
  try install_yay

  print_header "Installing Packages"
  try run_install_packages "Graphics Drivers" "${GRAPHICS[@]}"
  try run_install_packages "Window Manager" "${WINDOW_MANAGER[@]}"
  try run_install_packages "Aylur's GTK Shell" "${ASTAL[@]}"
  try run_install_packages "File Management" "${FILE_MANAGEMENT[@]}"
  try run_install_packages "Fonts" "${FONTS[@]}"
  try run_install_packages "Audio" "${AUDIO[@]}"
  try run_install_packages "CLI Utilities" "${CLI_UTILS[@]}"
  try run_install_packages "Extra Apps" "${EXTRA[@]}"
  try run_install_packages "Browser" "${BROWSER[@]}"
  try run_install_packages "Bluetooth" "${BLUETOOTH[@]}"
  try run_install_packages "Development Tools" "${DEV_TOOLS[@]}"
  
  # Dotfiles and Services
  try install_dotfiles
  try enable_services

  print_header "Installation Complete!"
  print_success "Your system is ready."
}

main "$@"
