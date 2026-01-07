#!/usr/bin/env bash
set -euo pipefail

### -----------------------------
### 1. Bootstrap (Clone Repo)
### -----------------------------
DOTFILES_REPO="https://github.com/naba-r/mydotfiles.git"
DOTFILES_DIR="$HOME/mydotfiles"

# Sanity check: Don't run as root (we use sudo later)
if [[ $EUID -eq 0 ]]; then
  echo "❌ Do not run as root. Run as user."
  exit 1
fi

echo "🚀 Starting setup..."

# Install git and rsync if missing
if ! command -v git &>/dev/null || ! command -v rsync &>/dev/null; then
  echo "📦 Installing git and rsync..."
  sudo zypper refresh
  sudo zypper in -y git rsync
fi

# Clone or Pull the repo
if [[ -d "$DOTFILES_DIR" ]]; then
  echo "📂 Updating existing dotfiles..."
  git -C "$DOTFILES_DIR" pull --ff-only
else
  echo "⬇️ Cloning dotfiles..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

### -----------------------------
### Variables (Set AFTER Clone)
### -----------------------------
# Now that the folder exists, we can point variables to files inside it
CONFIG_SRC="$DOTFILES_DIR/config"
FONTS_SRC="$DOTFILES_DIR/fonts"
WALLPAPER_SRC="$DOTFILES_DIR/wallpaper"
PACKAGES_FILE="$DOTFILES_DIR/packages/packages.txt"
BLOG_DIR="$HOME/naba-r.github.io"

# Verify packages file exists
if [[ ! -f "$PACKAGES_FILE" ]]; then
  echo "❌ packages.txt not found at $PACKAGES_FILE"
  exit 1
fi

### -----------------------------
### 2. System Configuration
### -----------------------------
echo "🔧 Configuring zypper (no recommends)"
sudo sed -i 's/^#\?installRecommends.*/installRecommends = false/' /etc/zypp/zypp.conf

echo "🔒 Locking sway pattern"
sudo zypper al patterns-sway-sway || true

### -----------------------------
### 3. Install Packages
### -----------------------------
echo "📦 Installing packages..."
sudo zypper refresh
# The -y flag is important for unattended install
sudo zypper in -y --no-recommends $(< "$PACKAGES_FILE")

### -----------------------------
### 4. User Configuration
### -----------------------------
echo "👥 Adding user to groups"
sudo usermod -aG libvirt "$USER"
sudo usermod -aG input "$USER"

echo "⚙ Enabling services"
sudo systemctl enable --now libvirtd || true
sudo systemctl enable --now NetworkManager || true

### -----------------------------
### 5. Restore Configs
### -----------------------------
echo "📁 Restoring config files"
mkdir -p "$HOME/.config"
rsync -a --delete "$CONFIG_SRC/" "$HOME/.config/"

### -----------------------------
### 6. Install Fonts & Wallpaper
### -----------------------------
echo "🔤 Installing fonts"
mkdir -p "$HOME/.local/share/fonts"
rsync -a "$FONTS_SRC/" "$HOME/.local/share/fonts/"
fc-cache -fv

echo "🖼 Setting wallpaper"
mkdir -p "$HOME/Pictures/wallpapers"
rsync -a "$WALLPAPER_SRC/" "$HOME/Pictures/wallpapers/"

### -----------------------------
### 7. Extras
### -----------------------------
echo "✍ Preparing Hugo blog directory"
mkdir -p "$BLOG_DIR"

echo
echo "✅ Installation complete!"
echo "⚠  Please reboot your system."
