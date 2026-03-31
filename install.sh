#!/usr/bin/env bash
set -euo pipefail

### =========================================================
### 1. Bootstrap (Clone Repo)
### =========================================================
DOTFILES_REPO="https://github.com/naba-r/mydotfiles.git"
DOTFILES_DIR="$HOME/mydotfiles"

if [[ $EUID -eq 0 ]]; then
  echo "❌ Do not run as root. Run as a normal user."
  exit 1
fi

echo "🚀 Starting openSUSE Tumbleweed setup..."

if ! command -v git &>/dev/null || ! command -v rsync &>/dev/null; then
  echo "📦 Installing git and rsync..."
  sudo zypper refresh
  sudo zypper in -y git rsync
fi

if [[ -d "$DOTFILES_DIR" ]]; then
  echo "📂 Updating existing dotfiles..."
  git -C "$DOTFILES_DIR" pull --ff-only
else
  echo "⬇️ Cloning dotfiles repository..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

### =========================================================
### 2. Variables
### =========================================================
CONFIG_SRC="$DOTFILES_DIR/config"
FONTS_SRC="$DOTFILES_DIR/fonts"
WALLPAPER_SRC="$DOTFILES_DIR/wallpaper"
THEMES_SRC="$DOTFILES_DIR/Themes"
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
sudo mkdir -p /etc/zypp
if [ ! -f /etc/zypp/zypp.conf ]; then
    echo -e "[main]\ninstallRecommends = false" | sudo tee /etc/zypp/zypp.conf > /dev/null
else
    sudo sed -i 's/^#\?installRecommends.*/installRecommends = false/' /etc/zypp/zypp.conf
fi

echo "🔒 Locking sway pattern"
sudo zypper al patterns-sway-sway 2>/dev/null || true

# --- BRAVE BROWSER REPO REMOVED ---

### =========================================================
### 4. Install Packages (Smart Loop with Report)
### =========================================================
echo "📦 Installing packages..."
sudo zypper refresh

mapfile -t packages < <(grep -v '^\s*#' "$PACKAGES_FILE" | grep -v '^\s*$')
failed_packages=()
installed_packages=()

for pkg in "${packages[@]}"; do
  echo -n "  Installing $pkg... "
  if sudo zypper in -y --no-recommends "$pkg" 2>/dev/null; then
    echo "✅"
    installed_packages+=("$pkg")
  else
    echo "⚠️ SKIPPED"
    failed_packages+=("$pkg")
  fi
done

### =========================================================
### 5. User Groups & Services
### =========================================================
echo "👥 Adding user to groups"
sudo usermod -aG libvirt "$USER" 2>/dev/null || true
sudo usermod -aG input "$USER" 2>/dev/null || true

echo "⚙ Enabling services"
sudo systemctl enable --now libvirtd 2>/dev/null || true
sudo systemctl enable --now NetworkManager 2>/dev/null || true

### =========================================================
### 6. Restore Config Files
### =========================================================
echo "📁 Restoring configuration files"
mkdir -p "$HOME/.config"

# Special handling for newsflash to avoid deleting its internal database/cache
# while still updating the gtk.css and fontconfig
rsync -a --delete "$CONFIG_SRC/" "$HOME/.config/"

### =========================================================
### 7. Fonts & Wallpaper & Themes
### =========================================================
echo "🔤 Installing fonts"
mkdir -p "$HOME/.local/share/fonts"
rsync -a "$FONTS_SRC/" "$HOME/.local/share/fonts/"
fc-cache -fv

echo "🖼 Installing wallpapers"
mkdir -p "$HOME/Pictures/wallpapers"
mkdir -p "$HOME/Pictures/Screenshots"
rsync -a "$WALLPAPER_SRC/" "$HOME/Pictures/wallpapers/"

echo "🎨 Installing Themes, Icons, and Cursors"
mkdir -p "$HOME/.themes"
mkdir -p "$HOME/.icons"

# Copy Graphite Theme
if [ -d "$THEMES_SRC/Graphite" ]; then
    rsync -a "$THEMES_SRC/Graphite" "$HOME/.themes/"
fi

# Copy Icons/Cursors content into ~/.icons
if [ -d "$THEMES_SRC/icons/" ]; then
    rsync -a "$THEMES_SRC/icons/" "$HOME/.icons/"
fi

# Fix for GTK4 apps (Papers/Calculator)
echo "🧪 Applying GTK4 theme links"
mkdir -p "$HOME/.config/gtk-4.0"
if [ -d "$HOME/.themes/Graphite/gtk-4.0" ]; then
    ln -sf "$HOME/.themes/Graphite/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
    ln -sf "$HOME/.themes/Graphite/gtk-4.0/gtk-dark.css" "$HOME/.config/gtk-4.0/gtk-dark.css"
    ln -sf "$HOME/.themes/Graphite/gtk-4.0/assets" "$HOME/.config/gtk-4.0/assets"
fi

### =========================================================
### 8. Default Applications & UI Settings
### =========================================================
echo "📂 Setting Nemo as default file manager"
xdg-mime default nemo.desktop inode/directory 2>/dev/null || true

echo "⚙️ Applying UI Themes via GSettings"
gsettings set org.gnome.desktop.interface gtk-theme "Graphite"
gsettings set org.gnome.desktop.interface icon-theme "Boston-Cardboard"
gsettings set org.gnome.desktop.interface cursor-theme "Future-cursors"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
# Force Dubai as the interface font for other apps too
gsettings set org.gnome.desktop.interface font-name 'Dubai 11'

echo "🐟 Setting fish as default shell"
if command -v fish &>/dev/null; then
  sudo chsh -s "$(command -v fish)" "$USER"
fi

### =========================================================
### Done (Final Report)
### =========================================================
echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Installation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
