#!/bin/bash

# Color codes for terminal output
COLOR_RESET="\e[0m"

# Foreground colors (not directly used for log tags, but kept for general use)
COLOR_RED="\e[0;31m"
COLOR_GREEN="\e[0;32m"
COLOR_YELLOW="\e[0;33m"
COLOR_BLUE="\e[0;34m"
COLOR_CYAN="\e[0;36m"
COLOR_WHITE="\e[1;37m"
COLOR_BLACK="\e[0;30m"

# Combined foreground and background colors for log tags
LOG_INFO_TAG="\e[30;44m INFO ${COLOR_RESET}"       # Black text on Blue background
LOG_SUCCESS_TAG="\e[30;42m SUCCESS ${COLOR_RESET}" # Black text on Green background
LOG_WARN_TAG="\e[30;43m WARN ${COLOR_RESET}"       # Black text on Yellow background
LOG_ERROR_TAG="\e[30;41m ERROR ${COLOR_RESET}"     # Black text on Red background

# Function to display informational messages
log_info() {
    echo -e "${LOG_INFO_TAG} $1"
}

# Function to display success messages
log_success() {
    echo -e "${LOG_SUCCESS_TAG} $1"
}

# Function to display warnings
log_warn() {
    echo -e "${LOG_WARN_TAG} $1"
}

# Function to display error messages and exit
log_error() {
    echo -e "${LOG_ERROR_TAG} $1" >&2
    # exit 1
}

# Function to check if a command exists
check_command_exists() {
    command -v "$1" &>/dev/null
}

# Function to determine the installed AUR helper (yay or paru)
get_aur_helper() {
    if check_command_exists "yay"; then
        echo "yay"
    elif check_command_exists "paru"; then
        echo "paru"
    else
        echo ""
    fi
}

# Function to install an AUR helper (yay or paru)
install_aur_helper() {
    local aur_helper=$(get_aur_helper)

    if [ -n "$aur_helper" ]; then
        log_success "AUR helper '$aur_helper' is already installed."
        return 0
    fi

    log_warn "AUR helper (yay or paru) not found."
    echo "Choose an AUR helper to install:"
    echo "1) yay"
    echo "2) paru"
    read -p "Enter 1 or 2: " choice

    local chosen_helper=""
    local repo_url=""
    case $choice in
    1)
        chosen_helper="yay"
        repo_url="https://aur.archlinux.org/yay.git"
        ;;
    2)
        chosen_helper="paru"
        repo_url="https://aur.archlinux.org/paru.git"
        ;;
    *)
        log_error "Invalid choice. AUR helper installation cancelled."
        ;;
    esac

    log_info "Installing '$chosen_helper'..."

    # Install git and base-devel if they are not present
    if ! check_command_exists "git" || ! check_command_exists "makepkg"; then
        log_info "Installing 'git' and 'base-devel' (required for AUR builds)..."
        try sudo pacman -S --noconfirm git base-devel || log_error "Failed to install 'git' and 'base-devel'."
    fi

    local temp_dir=$(mktemp -d)
    log_info "Cloning '$chosen_helper' repository into '$temp_dir'..."
    try git clone "$repo_url" "$temp_dir" || log_error "Failed to clone '$chosen_helper' repository."

    (
        cd "$temp_dir" || log_error "Failed to change directory to '$temp_dir'."
        log_info "Building and installing '$chosen_helper'..."
        try makepkg -si --noconfirm || log_error "Failed to build and install '$chosen_helper'."
    )

    log_info "Removing temporary directory '$temp_dir'..."
    try rm -rf "$temp_dir"

    if check_command_exists "$chosen_helper"; then
        log_success "AUR helper '$chosen_helper' installed successfully."
    else
        log_error "Failed to verify '$chosen_helper' installation."
    fi
}

# Function to check if a package is installed via pacman
is_installed() {
    pacman -Qi "$1" &>/dev/null
}

# Function to check if a package group is installed via pacman
is_group_installed() {
    pacman -Qg "$1" &>/dev/null
}

# Function to execute a command with retry/skip/exit
try() {
    local attempt=0
    while true; do
        attempt=$((attempt + 1))
        if [ "$attempt" -gt 1 ]; then
            log_warn "Retrying command: $*"
        fi

        # Выполняем команду, используя все переданные аргументы
        "$@"
        local status=$?

        if [ $status -ne 0 ]; then
            log_error "Command failed with status $status: \"$cmd\"" # Используем log_error, но без exit 1
            echo "Options: (R)etry, (S)kip, (E)xit script? [R/s/e]"
            read -p "Choose an option (default: R): " choice
            choice=${choice:-R} # Default to Retry

            case "$choice" in
            [Rr]*)
                # log_info "Retrying..."
                ;;
            [Ss]*)
                log_warn "Skipping command: \"$cmd\""
                return 1 # Возвращаем 1, чтобы вызывающая функция знала, что команда была пропущена
                ;;
            [Ee]*)
                log_error "Exiting script due to user choice after command failure: \"$cmd\""
                exit 1 # Выходим из всего скрипта
                ;;
            *)
                log_warn "Invalid choice. Please enter 'r', 's', or 'e'. Retrying by default."
                ;;
            esac
        else
            return 0 # Command succeeded, exit the function successfully
        fi
    done
}
