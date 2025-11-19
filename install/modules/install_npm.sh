#!/bin/bash

source "$(dirname "$0")/../utils.sh"

install_npm_if_not_exist() {
    if ! check_command_exists "node" || ! check_command_exists "npm"; then
        log_info "Installing nodejs and npm via pacman..."
        try sudo pacman -S nodejs npm --noconfirm
    else
        log_info "Node.js and npm already installed"
    fi
}

setup_prefix() {
    local NPM_DIR="$HOME/.npm-global"
    if [[ ! -d "$NPM_DIR" ]]; then
        log_info "Creating global npm directory $NPM_DIR"
        mkdir -p "$NPM_DIR"
    fi

    npm config set prefix "$NPM_DIR"

    log_info "Your npm prefix dir is: $(npm get prefix)"
}

install_npm() {
    install_npm_if_not_exist

    setup_prefix

    log_info "You need to manually add ~/.npm-global/bin to your PATH:

    For fish-shell:
        set -Ux fish_user_paths \$HOME/.npm-global/bin \$fish_user_paths

    For bash/zsh:
        export PATH=\"\$HOME/.npm-global/bin:\$PATH\"
    "
    log_success "NPM successfully installed"
}
