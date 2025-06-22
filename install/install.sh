#!/usr/bin/env bash

# Exit on any error
set -e

# Source utility functions
source utils.sh

if [ ! -f "packages.conf" ]; then
  echo "Error: packages.conf not found!"
  exit 1
fi

source packages.conf

# Install yay if not installed
if ! command -v yay &> /dev/null; then
  echo "Installing yay AUR helper..."
  sudo pacman -S --needed git base-devel --noconfirm
  if [[ ! -d "yay" ]]; then
    echo "Cloning yay repository..."
  else
    echo "yay directory already exists, removing it..."
    rm -rf yay
  fi

  git clone https://aur.archlinux.org/yay.git

  cd yay
  echo "building yay.... yaaaaayyyyy"
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
else
  echo "yay is already installed"
fi

# Install packages

echo "Installing system utils..."
install_packages "${SYS_UTILS[@]}"

echo "Installing window manager..."
install_packages "${WINDOW_MANAGER[@]}"

echo "Installing development tools..."
install_packages "${DEV_TOOLS[@]}"

echo "Installing Astal (AGS)..."
install_packages "${ASTAL[@]}"

echo "Installing fonts..."
install_packages "${FONTS[@]}"

echo "Installing browser..."
install_packages "${BROWSER[@]}"

echo "Installing file management packages..."
install_packages "${FILE_MANAGEMENT[@]}"

echo "Installing extra stuff..."
install_packages "${EXTRA[@]}"

echo "Installing flatpaks..."
. install_flatpak.sh