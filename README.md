
# 🚀 Minimal Sway Desktop for openSUSE Tumbleweed

minimal, and fully automated Wayland/Sway desktop environment built for a fresh **openSUSE Tumbleweed** (Server/Minimal) installation.

No Display Manager required — log in via TTY and type `sway`.

> **One-line install:**

> bash -c "$(curl -fsSL https://raw.githubusercontent.com/naba-r/mydotfiles/main/install.sh)"


---

## ✨ Features

- **Fully Automated Install:** `install.sh` handles package installation (`zypper`), user groups (`libvirt`, `input`), service activation, and config symlinking.
- **Smart Hardware & VM Detection:** Display script auto-detects QEMU/KVM vs. bare metal and adjusts to the maximum native resolution.
- **Aggressive Power-Saving Lock:** `swayidle` stays disabled during active use; automatically activates on lock via `gtklock`.
- **Polkit & Keyring Integration:** `lxqt-policykit` + `gnome-keyring` bridge — run root-level GUI apps (Nemo, Chromium) without constant password prompts.
- **Bilingual Keybindings:** Uses `--to-code` throughout so all shortcuts work in both English (`us`) and Arabic (`ara`) layouts.
- **Modern Wayland Stack:** `waybar`, `fuzzel`, `swaync`, `clipman`, PipeWire (`wpctl`).

---

## 📦 Prerequisites

1. Fresh **openSUSE Tumbleweed** install (Server/Minimal pattern recommended).
2. Log in to the TTY as your **normal user** — do NOT run as root.
3. Active internet connection.

---

## 🛠️ Installation

### Option A — One-liner (recommended)


bash -c "$(curl -fsSL https://raw.githubusercontent.com/naba-r/mydotfiles/main/install.sh)"


### Option B — Clone and run manually


git clone https://github.com/naba-r/mydotfiles.git ~/mydotfiles
cd ~/mydotfiles
chmod +x install.sh
./install.sh


The script will prompt for your `sudo` password to install packages and enable systemd services.

### After install — reboot

Some changes (e.g. `libvirt` group membership) only apply after re-login:


reboot


---

## 💻 Starting Sway

Log in at the TTY, then start Sway under a DBus session for correct portal/keyring behavior:


exec dbus-run-session -- sway


Or simply type `sway` if your shell profile already wraps it.

---

## ⌨️ Keybindings

| Action | Shortcut |
|---|---|
| Terminal (Kitty) | `Super + Enter` |
| App Launcher (Fuzzel) | `Super + D` |
| Window Switcher | `Alt + Tab` |
| File Manager (Nemo) | `Super + E` |
| Web Browser (Firefox) | `Super + F` |
| Clipboard History (Clipman) | `Super + V` |
| Switch Layout (EN/AR) | `Super + Space` |
| Close Window | `Super + Q` |
| Reload Sway Config | `Super + Shift + C` |
| Lock Screen | `Ctrl + Alt + L` |
| Power Menu | `Ctrl + Alt + Delete` |
| Screenshot → Clipboard | `Print` |
| Screenshot → File | `Ctrl + Print` |
| Volume | Media keys via `wpctl` |

---

## 📁 Repository Layout

```
mydotfiles/
├── install.sh              # Master setup script
├── packages/
│   └── packages.txt        # zypper package list
├── config/
│   ├── sway/               # Sway config + automation scripts
│   └── waybar/             # Status bar config & style
├── fonts/                  # Nerd Fonts → ~/.local/share/fonts
├── wallpaper/              # Wallpapers → ~/Pictures/wallpapers
└── Themes/                 # GTK themes + icons/cursors → ~/.themes / ~/.icons
```

---

## 🔧 Sway Session Helpers

Started automatically from the Sway config:

- `lxqt-policykit-agent` — Polkit auth dialogs
- `waybar` — status bar
- `swaync` — notification daemon
- Output auto-config script (VM/bare metal detection)
- Clipboard watcher script

Optional keyring bridge (if enabled):


~/.config/sway/scripts/start-keyring.sh


---

## ⚠️ Safety & Expectations

The config sync step runs:

```bash
rsync -a --delete config/ ~/.config/
```

This **will remove** any `~/.config/` content not present in this repo. Safe for fresh installs; use caution on existing systems.

All scripts under `~/.config/sway/scripts/*.sh` are made executable automatically by the installer.

---

## 🗒️ Notes

- This repo is opinionated and tuned for *my* workflow.  keyboad layout in English US and Arabic
- Tested exclusively on openSUSE Tumbleweed (rolling). Not tested on Leap or other distros.

