#!/usr/bin/env bash
set -euo pipefail

### -----------------------------
### Variables
### -----------------------------
DOTFILES_DIR="$HOME/mydotfiles"
CONFIG_SRC="$DOTFILES_DIR/config"
FONTS_SRC="$DOTFILES_DIR/fonts"
WALLPAPER_SRC="$DOTFILES_DIR/wallpaper"
PACKAGES_FILE="$DOTFILES_DIR/packages/packages.txt"
BLOG_DIR="$HOME/naba-r.github.io"

### -----------------------------
### Sanity checks
### -----------------------------
if [[ $EUID -eq 0 ]]; then
  echo "❌ Do not run as root"
  exit 1
fi

if [[ ! -f "$PACKAGES_FILE" ]]; then
  echo "❌ packages.txt not found"
  exit 1
fi

echo "✔ Starting install process"

### -----------------------------
### System configuration (root)
### -----------------------------
echo "🔧 Configuring zypper (no recommends)"
sudo sed -i 's/^#\?installRecommends.*/installRecommends = false/' /etc/zypp/zypp.conf

echo "🔒 Locking sway pattern"
sudo zypper al patterns-sway-sway || true

### -----------------------------
### Install packages
### -----------------------------
echo "📦 Installing packages"
sudo zypper refresh
sudo zypper in --no-recommends $(< "$PACKAGES_FILE")

### -----------------------------
### User groups
### -----------------------------
echo "👥 Adding user to groups"
sudo usermod -aG libvirt "$USER"
sudo usermod -aG input "$USER"

### -----------------------------
### Enable services
### -----------------------------
echo "⚙ Enabling services"
sudo systemctl enable --now libvirtd || true
sudo systemctl enable --now NetworkManager || true

### -----------------------------
### Restore configs
### -----------------------------
echo "📁 Restoring config files"
mkdir -p "$HOME/.config"
rsync -a --delete "$CONFIG_SRC/" "$HOME/.config/"

### -----------------------------
### Install fonts (user-local)
### -----------------------------
echo "🔤 Installing fonts"
mkdir -p "$HOME/.local/share/fonts"
rsync -a "$FONTS_SRC/" "$HOME/.local/share/fonts/"
fc-cache -fv

### -----------------------------
### Wallpaper
### -----------------------------
echo "🖼 Setting wallpaper"
mkdir -p "$HOME/Pictures/wallpapers"
rsync -a "$WALLPAPER_SRC/" "$HOME/Pictures/wallpapers/"

### -----------------------------
### Hugo blog directory
### -----------------------------
echo "✍ Preparing Hugo blog directory"
mkdir -p "$BLOG_DIR"

### -----------------------------
### Final notes
### -----------------------------
echo
echo "✅ Installation complete"
echo
echo "⚠ IMPORTANT:"
echo " - Log out and back in for group changes"
echo " - Start Sway manually or reboot"
echo " - Hugo content is NOT cloned (by design)"
echo
