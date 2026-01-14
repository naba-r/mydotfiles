#!/usr/bin/env bash
set -euo pipefail

### =========================================================
### 1. Bootstrap (Clone Repo)
### =========================================================
DOTFILES_REPO="https://github.com/naba-r/mydotfiles.git"
DOTFILES_DIR="$HOME/mydotfiles"

# Do NOT run as root
if [[ $EUID -eq 0 ]]; then
  echo "❌ Do not run as root. Run as a normal user."
  exit 1
fi

echo "🚀 Starting openSUSE Tumbleweed setup..."

# Ensure git + rsync exist
if ! command -v git &>/dev/null || ! command -v rsync &>/dev/null; then
  echo "📦 Installing git and rsync..."
  sudo zypper refresh
  sudo zypper in -y git rsync
fi

# Clone or update repo
if [[ -d "$DOTFILES_DIR" ]]; then
  echo "📂 Updating existing dotfiles..."
  git -C "$DOTFILES_DIR" pull --ff-only
else
  echo "⬇️ Cloning dotfiles repository..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

### =========================================================
### 2. Variables (AFTER clone)
### =========================================================
CONFIG_SRC="$DOTFILES_DIR/config"
FONTS_SRC="$DOTFILES_DIR/fonts"
WALLPAPER_SRC="$DOTFILES_DIR/wallpaper"
PACKAGES_FILE="$DOTFILES_DIR/packages/packages.txt"
BLOG_DIR="$HOME/naba-r.github.io"

if [[ ! -f "$PACKAGES_FILE" ]]; then
  echo "❌ packages.txt not found at $PACKAGES_FILE"
  exit 1
fi

### =========================================================
### 3. System Configuration
### =========================================================
echo "🔧 Configuring zypper (disable recommends)"
sudo sed -i 's/^#\?installRecommends.*/installRecommends = false/' /etc/zypp/zypp.conf

echo "🔒 Locking sway pattern"
sudo zypper al patterns-sway-sway 2>/dev/null || true

### =========================================================
### 3.1 Brave Browser Repo
### =========================================================
echo "🦁 Adding Brave Browser repository..."

# 1. Import the GPG Key (prevents verification errors during install)
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

# 2. Add the repository if it is not already there
if ! sudo zypper lr | grep -q "brave-browser"; then
    sudo zypper addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    # Refresh metadata specifically for this new repo
    sudo zypper refresh brave-browser
fi

### =========================================================
### 4. Install Packages
### =========================================================
echo "📦 Installing packages..."
sudo zypper refresh
sudo zypper in -y --no-recommends \
  $(grep -v '^\s*#' "$PACKAGES_FILE" | grep -v '^\s*$')

### =========================================================
### 5. User Groups & Services
### =========================================================
echo "👥 Adding user to groups"
sudo usermod -aG libvirt "$USER"
sudo usermod -aG input "$USER"

echo "⚙ Enabling services"
sudo systemctl enable --now libvirtd 2>/dev/null || true
sudo systemctl enable --now NetworkManager 2>/dev/null || true

### =========================================================
### 6. Restore Config Files
### =========================================================
echo "📁 Restoring configuration files"
mkdir -p "$HOME/.config"
rsync -a --delete "$CONFIG_SRC/" "$HOME/.config/"

### =========================================================
### 7. Fonts & Wallpaper
### =========================================================
echo "🔤 Installing fonts"
mkdir -p "$HOME/.local/share/fonts"
rsync -a "$FONTS_SRC/" "$HOME/.local/share/fonts/"
fc-cache -fv

echo "🖼 Installing wallpapers"
mkdir -p "$HOME/Pictures/wallpapers"
mkdir -p "$HOME/Pictures/Screenshots"
rsync -a "$WALLPAPER_SRC/" "$HOME/Pictures/wallpapers/"

### =========================================================
### 8. Default Applications
### =========================================================
echo "📂 Setting Thunar as default file manager"
xdg-mime default thunar.desktop inode/directory
xdg-mime default thunar.desktop application/octet-stream
xdg-mime default thunar.desktop x-scheme-handler/file

echo "🐟 Setting fish as default shell"
if command -v fish &>/dev/null; then
  sudo chsh -s "$(command -v fish)" "$USER"
fi

echo "📝 Setting micro as default editor"
sudo tee /etc/profile.d/editor.sh >/dev/null <<'EOF'
export EDITOR=micro
export VISUAL=micro
EOF

echo "🖥 Setting kitty as default terminal"
sudo tee /etc/profile.d/terminal.sh >/dev/null <<'EOF'
export TERMINAL=kitty
EOF

### =========================================================
### 8.5 Compile GLIB Schemas (Fix Notifications/GTK)
### =========================================================
echo "⚙️ Compiling GLIB schemas..."
if [ -d "/usr/share/glib-2.0/schemas/" ]; then
    sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
    # Ensure the user-level schema path is also recognized
    mkdir -p "$HOME/.local/share/glib-2.0/schemas"
    echo "✅ Schemas compiled successfully."
else
    echo "⚠️ Warning: Schema directory not found, skipping."
fi

### =========================================================
### 9. Hugo Blog Directory
### =========================================================
echo "✍ Preparing Hugo blog directory"
mkdir -p "$BLOG_DIR"

### =========================================================
### Done
### =========================================================
echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Installation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "⚠ NEXT STEPS:"
echo "  1. Reboot (required for groups, shell, fonts)"
echo "  2. Login and start Sway"
echo
