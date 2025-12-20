#!/bin/bash

# Function to install packages from a configuration file
install_from_config() {
    local config_file="$1"
    local script_root_dir="$2" # Accept SCRIPT_ROOT_DIR as an argument

    # Source utility functions using the provided SCRIPT_ROOT_DIR
    source "$script_root_dir/install/utils.sh"

    if [ ! -f "$config_file" ]; then
        log_error "Configuration file not found: $config_file"
    fi

    log_info "Installing packages from $config_file..."

    # Source the config file to load the arrays
    # This will define arrays like WINDOW_MANAGER, QUICKSHELL, etc.
    . "$config_file"

    # Explicitly call install_packages for each expected array
    # This list should cover all package arrays in essential.conf and extra.conf
    local package_array_names=("WINDOW_MANAGER" "QUICKSHELL" "FILE_MANAGEMENT" "CORE_UTILS" "CODECS" "FONTS" "AUDIO" "CLI_UTILS" "EXTRA" "BLUETOOTH" "WIFI" "DEV_TOOLS")

    local packages_installed_successfully=true

    for var_name in "${package_array_names[@]}"; do
        if declare -p "$var_name" &>/dev/null && [[ "$(declare -p "$var_name")" =~ "declare -a" ]]; then
            local -n current_array="$var_name" # Nameref to access the array by its name
            if [ ${#current_array[@]} -gt 0 ]; then
                log_info "Processing package group: $var_name"
                install_packages "${current_array[@]}" || packages_installed_successfully=false
            else
                log_warn "No packages found in group: $var_name"
            fi
        fi
    done

    if $packages_installed_successfully; then
        log_success "All packages from $config_file installed successfully."
    else
        log_error "Some packages from $config_file failed to install."
    fi
}

# Function to install packages if not already installed
install_packages() {
    local packages=("$@")
    local to_install=()
    local aur_helper=$(get_aur_helper)

    if [ -z "$aur_helper" ]; then
        log_error "No AUR helper found. Please install yay or paru first."
    fi

    for pkg in "${packages[@]}"; do
        if ! is_installed "$pkg" && ! is_group_installed "$pkg"; then
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -ne 0 ]; then
        log_info "Using $aur_helper to install: ${to_install[*]}"
        # Do NOT use sudo here, yay/paru will prompt for it if needed
        try "$aur_helper" -S --noconfirm "${to_install[@]}" || return 1 # Return 1 on failure
    else
        log_info "All packages are already installed. Skipping."
    fi
}

# Function to install Flatpak applications from a configuration file
install_flatpaks() {
    local config_file="$1"
    local script_root_dir="$2" # Accept SCRIPT_ROOT_DIR as an argument

    # Source utility functions using the provided SCRIPT_ROOT_DIR
    source "$script_root_dir/install/utils.sh"

    if [ ! -f "$config_file" ]; then
        log_error "Configuration file not found: $config_file"
    fi

    log_info "Installing Flatpak applications from $config_file..."

    # Source the config file to load the arrays
    . "$config_file"

    # Source the config file to load the arrays
    . "$config_file"

    local flatpak_array_names=("FLATPAKS") # Assuming the array is named FLATPAKS
    local flatpaks_installed_successfully=true

    if ! check_command_exists "flatpak"; then
        log_warn "Flatpak command not found. Skipping Flatpak installation."
        return 0
    fi

    for var_name in "${flatpak_array_names[@]}"; do
        if declare -p "$var_name" &>/dev/null && [[ "$(declare -p "$var_name")" =~ "declare -a" ]]; then
            local -n current_array="$var_name"
            if [ ${#current_array[@]} -gt 0 ]; then
                log_info "Installing Flatpak applications from group: $var_name"
                try flatpak install -y "${current_array[@]}" || flatpaks_installed_successfully=false
            else
                log_warn "No Flatpak applications found in group: $var_name"
            fi
        fi
    done

    if $flatpaks_installed_successfully; then
        log_success "All Flatpak applications from $config_file installed successfully."
    else
        log_error "Some Flatpak applications from $config_file failed to install."
    fi
}

# Function to enable system services from a configuration file
enable_services() {
    local config_file="$1"
    local script_root_dir="$2" # Accept SCRIPT_ROOT_DIR as an argument

    # Source utility functions using the provided SCRIPT_ROOT_DIR
    source "$script_root_dir/install/utils.sh"

    if [ ! -f "$config_file" ]; then
        log_error "Configuration file not found: $config_file"
    fi

    log_info "Enabling system services from $config_file..."

    # Source the config file to load the arrays
    . "$config_file"

    # Source the config file to load the arrays
    . "$config_file"

    local service_array_names=("SERVICES") # Assuming the array is named SERVICES
    local services_enabled_successfully=true

    if ! check_command_exists "systemctl"; then
        log_warn "systemctl command not found. Skipping service enabling."
        return 0
    fi

    for var_name in "${service_array_names[@]}"; do
        if declare -p "$var_name" &>/dev/null && [[ "$(declare -p "$var_name")" =~ "declare -a" ]]; then
            local -n current_array="$var_name"
            if [ ${#current_array[@]} -gt 0 ]; then
                log_info "Enabling services from group: $var_name"
                for service in "${current_array[@]}"; do
                    log_info "Enabling service: $service"
                    try sudo systemctl enable now "$service" || services_enabled_successfully=false
                done
            else
                log_warn "No services found in group: $var_name"
            fi
        fi
    done

    if $services_enabled_successfully; then
        log_success "All system services from $config_file enabled successfully."
    else
        log_error "Some system services from $config_file failed to enable."
    fi
}
