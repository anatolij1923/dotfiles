#!/bin/bash
# set -e

# Define the root directory of the install script as an absolute path
SCRIPT_ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source utility functions and modules
source "$SCRIPT_ROOT_DIR/install/utils.sh"
source "$SCRIPT_ROOT_DIR/install/modules/install_packages.sh"
source "$SCRIPT_ROOT_DIR/install/modules/install_dotfiles.sh"
source "$SCRIPT_ROOT_DIR/install/modules/install_npm.sh"

if [[ $(whoami) = "root" ]]; then
    log_error "You should not run this as root"
    exit 0
fi

log_info "Welcome to the dotfiles installation script!"

echo
echo "This script will perform the following actions:"
echo "  1) Install AUR helper of your choice if missing"
echo "  2) Install essential packages listed in the configuration file"
echo "  4) Optionally install Flatpak applications if you want"
echo "  5) Optionally install and setup npm with a user-global directory (~/.npm-global)"
echo "  6) Optionally enable system services listed in the configuration"
echo "  7) Optionally install your dotfiles using GNU Stow"

echo
read -p "Do you want to continue with the installation? (y/N): " proceed
proceed=${proceed:-N}

if [[ ! "$proceed" =~ ^[Yy]$ ]]; then
    log_warn "installation aborted by user"
    exit 0
fi

# Variable for tracking the --full flag
INSTALL_FULL=false

# Parse command-line arguments
for arg in "$@"; do
    case $arg in
    --full)
        INSTALL_FULL=true
        shift
        ;;
    *)
        # Unknown argument, can be handled or ignored
        shift
        ;;
    esac
done

log_info "This script will install aur helper of your choise, "

# 1. Check and install AUR helper
install_aur_helper
log_info "AUR helper check/installation complete."

# 2. Install essential packages
log_info "Installing essential packages..."
try install_from_config "$SCRIPT_ROOT_DIR/install/config/essential.conf" "$SCRIPT_ROOT_DIR"

# 3. Install extra packages if --full flag is present
if [ "$INSTALL_FULL" = true ]; then
    log_info "Installing extra packages (--full flag detected)..."
    try install_from_config "$SCRIPT_ROOT_DIR/install/config/extra.conf" "$SCRIPT_ROOT_DIR"
fi

# 4. Install Flatpak applications (optional, interactive)
read -p "Do you want to install Flatpak applications? (y/N): " flatpak_choice
if [[ "$flatpak_choice" =~ ^[Yy]$ ]]; then
    try install_flatpaks "$SCRIPT_ROOT_DIR/install/config/flatpaks.conf" "$SCRIPT_ROOT_DIR"
fi

# 5. Install and setup npm
read -p "Do you want to install and setup (create global dir for packages) npm? (y/N)" npm_choice
if [[ "$npm_choice" =~ ^[Yy]$ ]]; then
    try install_npm
fi

# 6. Enable system services (optional, interactive)
read -p "Do you want to enable system services? (y/N): " services_choice
if [[ "$services_choice" =~ ^[Yy]$ ]]; then
    try enable_services "$SCRIPT_ROOT_DIR/install/config/services.conf" "$SCRIPT_ROOT_DIR"
fi

# 7. Install dotfiles using stow
read -p "Do you want to install dotfiles using stow? (y/N): " dotfiles_choice
if [[ "$dotfiles_choice" =~ ^[Yy]$ ]]; then
    try install_dotfiles_with_stow "$SCRIPT_ROOT_DIR"
fi

log_success "Dotfiles installation script finished successfully!"
log_info "You might need to restart your terminal or log out/in for some changes to take effect."
