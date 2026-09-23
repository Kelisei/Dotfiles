# Dotfiles

Personal configuration files for Wayland, Neovim, and terminal workflows.

---

## Components

| Component | Tool | Description |
| :--- | :--- | :--- |
| Window Manager | **Hyprland** | Dynamic tiling Wayland compositor, dual-monitor setup (1080p + 4K 160Hz), NVIDIA optimizations, dwindle layout, and blur decorations. |
| Status Bar | **Waybar** | Top status bar configured with workspace indicators, hardware monitors, and clock. |
| Terminal | **WezTerm** | GPU-accelerated terminal emulator, Catppuccin Mocha colors, and clipboard paste helper. |
| Editor | **Neovim** | Lua-based setup with Lazy.nvim, LSP, Mason, Telescope, Neogit, and Org mode emulation. |
| Document Viewer | **Okular** | PDF viewer configured with Catppuccin recoloring and custom highlight palettes. |
| Shell & Prompt | **Bash + Oh-My-Posh** | Bash configuration featuring Oh-My-Posh `ayu_dark` theme and `~/.bashrc.local` isolation. |
| Wallpapers | **swaybg / hyprpaper** | Desktop background images bundled under `wallpapers/`. |

---

## Directory Structure

```text
dotfiles/
├── .config/
│   ├── hypr/
│   │   ├── hyprland.conf
│   │   ├── hyprpaper.conf
│   │   ├── xdph.conf
│   │   └── wallpapers/
│   ├── waybar/
│   │   ├── config.jsonc
│   │   └── style.css
│   ├── wezterm/
│   │   └── wezterm.lua
│   ├── nvim/
│   │   ├── init.lua
│   │   ├── lazy-lock.json
│   │   └── lua/
│   ├── okular/
│   │   ├── okularrc
│   │   └── okularpartrc
│   └── oh-my-posh/
│       └── ayu_dark.json
├── bin/
│   └── wezterm-paste-handler.sh
├── shell/
│   └── .bashrc
├── wallpapers/
│   ├── star-wars-padme-amidala-desktop-wallpaper.jpg
│   └── wallhaven-3qlqwd.jpg
├── install.sh
└── README.md
```

---

## Installation

Clone the repository and run the automated installer:

```bash
git clone https://github.com/Kelisei/Dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` performs the following actions:
1. Creates target configuration directories under `~/.config/` and `~/.local/bin/`.
2. Backs up existing non-symlinked configurations into `~/.config_backup_<timestamp>/`.
3. Creates atomic symbolic links directly into `~/.config/`, `~/.local/bin/`, and `~/.bashrc`.
4. Initializes `~/.bashrc.local` if it does not already exist.

---

## Local Customizations

Machine-specific aliases, private tokens, or proprietary paths should be placed inside `~/.bashrc.local`. This file is git-ignored and automatically sourced at the end of `.bashrc`.

```bash
# ~/.bashrc.local
export PRIVATE_ENV_VAR="value"
alias mylocalapp="/opt/app/bin"
```

---

## Prerequisites

- **Fonts:** JetBrainsMono Nerd Font or any Nerd Font family.
- **Packages:** `hyprland`, `waybar`, `wezterm`, `neovim`, `okular`, `oh-my-posh`, `swaybg`, `wl-clipboard`, `slurp`, `grim`, `wofi`.
