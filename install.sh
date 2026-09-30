#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"

echo "Installing dotfiles from: $DOTFILES_DIR"

mkdir -p "$HOME/.config/hypr" \
         "$HOME/.config/waybar" \
         "$HOME/.config/wezterm" \
         "$HOME/.config/nvim" \
         "$HOME/.config/oh-my-posh" \
         "$HOME/.config/Antigravity IDE/User" \
         "$HOME/.config/Code/User" \
         "$HOME/.local/bin"

backup_and_link() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "Backing up existing $dest to $BACKUP_DIR"
        mv "$dest" "$BACKUP_DIR/"
    fi

    ln -sfn "$src" "$dest"
    echo "Linked: $dest -> $src"
}

# Hyprland
backup_and_link "$DOTFILES_DIR/.config/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
backup_and_link "$DOTFILES_DIR/.config/hypr/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"
backup_and_link "$DOTFILES_DIR/.config/hypr/xdph.conf" "$HOME/.config/hypr/xdph.conf"
backup_and_link "$DOTFILES_DIR/.config/hypr/wallpapers" "$HOME/.config/hypr/wallpapers"

# Waybar
backup_and_link "$DOTFILES_DIR/.config/waybar/config.jsonc" "$HOME/.config/waybar/config.jsonc"
backup_and_link "$DOTFILES_DIR/.config/waybar/style.css" "$HOME/.config/waybar/style.css"

# WezTerm
backup_and_link "$DOTFILES_DIR/.config/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
if [ -f "$DOTFILES_DIR/bin/wezterm-paste-handler.sh" ]; then
    chmod +x "$DOTFILES_DIR/bin/wezterm-paste-handler.sh"
    backup_and_link "$DOTFILES_DIR/bin/wezterm-paste-handler.sh" "$HOME/.local/bin/wezterm-paste-handler.sh"
fi

# Neovim
backup_and_link "$DOTFILES_DIR/.config/nvim/init.lua" "$HOME/.config/nvim/init.lua"
backup_and_link "$DOTFILES_DIR/.config/nvim/lazy-lock.json" "$HOME/.config/nvim/lazy-lock.json"
backup_and_link "$DOTFILES_DIR/.config/nvim/lua" "$HOME/.config/nvim/lua"

# Okular
backup_and_link "$DOTFILES_DIR/.config/okular/okularrc" "$HOME/.config/okularrc"
backup_and_link "$DOTFILES_DIR/.config/okular/okularpartrc" "$HOME/.config/okularpartrc"

# Oh-My-Posh
backup_and_link "$DOTFILES_DIR/.config/oh-my-posh/ayu_dark.json" "$HOME/.config/oh-my-posh/ayu_dark.json"

# Antigravity IDE / VS Code
backup_and_link "$DOTFILES_DIR/.config/antigravity-ide/settings.json" "$HOME/.config/Antigravity IDE/User/settings.json"
backup_and_link "$DOTFILES_DIR/.config/antigravity-ide/keybindings.json" "$HOME/.config/Antigravity IDE/User/keybindings.json"
backup_and_link "$DOTFILES_DIR/.config/antigravity-ide/settings.json" "$HOME/.config/Code/User/settings.json"
backup_and_link "$DOTFILES_DIR/.config/antigravity-ide/keybindings.json" "$HOME/.config/Code/User/keybindings.json"

# Shell (.bashrc)
backup_and_link "$DOTFILES_DIR/shell/.bashrc" "$HOME/.bashrc"

# Create local bashrc template if not present
if [ ! -f "$HOME/.bashrc.local" ]; then
    echo "# Local machine-specific aliases and environment configurations" > "$HOME/.bashrc.local"
fi

echo "Dotfiles installation complete."
