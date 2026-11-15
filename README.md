# ❄️ Dotfiles

A modern, minimal, keyboard-driven dotfiles ecosystem unified under the **Catppuccin Mocha** palette. Built for speed, aesthetic harmony, and seamless muscle memory across **Ubuntu (Hyprland)** and **macOS (AeroSpace)**.

---

## 🛠️ Tooling Stack

| Category | Ubuntu / Linux | macOS | Config Location |
| :--- | :--- | :--- | :--- |
| **Window Manager** | **Hyprland** (v0.57.2, Lua engine) | **AeroSpace** (v2, Tiling WM) | [`hypr/`](file:///home/kaizen/dotfiles/hypr/.config/hypr/hyprland.lua), [`aerospace/`](file:///home/kaizen/dotfiles/aerospace/.config/aerospace/aerospace.toml) |
| **Desktop Shell** | **Wayle** (v0.7.1, GTK4/Rust) | macOS native menubar | [`wayle/`](file:///home/kaizen/dotfiles/wayle/.config/wayle/config.toml) |
| **Launcher & Clipboard** | **Vicinae** | **Raycast** | [`vicinae/`](file:///home/kaizen/dotfiles/vicinae/.config/vicinae/settings.json) |
| **Terminal** | **Kitty** | **Kitty** | [`kitty/`](file:///home/kaizen/dotfiles/kitty/.config/kitty/theme.conf) |
| **Shell & Prompt** | **Zsh** + **Oh-My-Posh** | **Zsh** + **Oh-My-Posh** | [`zsh/`](file:///home/kaizen/dotfiles/zsh/.config/zsh/zshrc), [`oh-my-posh/`](file:///home/kaizen/dotfiles/oh-my-posh/.config/oh-my-posh/zen.toml) |
| **History Sync** | **Atuin** | **Atuin** | [`atuin/`](file:///home/kaizen/dotfiles/atuin/.config/atuin/config.toml) |
| **Code Editors** | **Neovim** & **Zed** | **Neovim** & **Zed** | [`nvim/`](file:///home/kaizen/dotfiles/nvim/.config/nvim/lua/custom/plugins/colorscheme.lua), [`zed/`](file:///home/kaizen/dotfiles/zed/.config/zed/settings.json) |
| **Web Browsers** | **Zen Browser** & **Firefox** | **Zen Browser** & **Firefox** | [`zen/`](file:///home/kaizen/dotfiles/zen/setup_zen.sh), [`firefox/`](file:///home/kaizen/dotfiles/firefox/setup_firefox.sh) |
| **Multiplexer** | **Tmux** (Catppuccin + `wl-copy`) | **Tmux** (Catppuccin) | [`tmux/`](file:///home/kaizen/dotfiles/tmux/.config/tmux/tmux.conf) |
| **System Monitor** | **btop** (Catppuccin Mocha) | **btop** (Catppuccin Mocha) | [`btop/`](file:///home/kaizen/dotfiles/btop/.config/btop/btop.conf) |
| **Git Interface** | **Lazygit** & CLI | **Lazygit** & CLI | [`lazygit/`](file:///home/kaizen/dotfiles/lazygit/.config/lazygit/config.yml) |
| **Runtime Manager**| **Mise** (Node, Python, Go, Rust, tools) | **Mise** | [`mise/`](file:///home/kaizen/dotfiles/mise/.config/mise/config.toml) |

---

## ⌨️ Unified Keybindings (Muscle Memory Across Platforms)

Both **Hyprland** (Linux) and **AeroSpace** (macOS) share identical ergonomics:
* On Linux: <kbd>Super</kbd> (Windows key) is the modifier.
* On macOS: <kbd>Alt</kbd> (Option key) is the modifier.
* Workspaces are strictly **numbered 1 to 10** across both environments.

| Action | Linux (Hyprland) | macOS (AeroSpace) |
| :--- | :--- | :--- |
| **Terminal (Kitty)** | <kbd>Super</kbd> + <kbd>T</kbd> or <kbd>Return</kbd> | <kbd>Alt</kbd> + <kbd>T</kbd> or <kbd>Return</kbd> |
| **Browser (Zen / Firefox)** | <kbd>Super</kbd> + <kbd>B</kbd> | <kbd>Alt</kbd> + <kbd>B</kbd> |
| **Launcher / Search** | <kbd>Super</kbd> + <kbd>Space</kbd> (Vicinae) | <kbd>Alt</kbd> + <kbd>Space</kbd> (Raycast) |
| **Clipboard History** | <kbd>Super</kbd> + <kbd>V</kbd> (Vicinae) | <kbd>Alt</kbd> + <kbd>V</kbd> (Raycast) |
| **Emoji Picker** | <kbd>Super</kbd> + <kbd>.</kbd> (Vicinae) | <kbd>Alt</kbd> + <kbd>.</kbd> (Raycast) |
| **Terminal Editor (Neovim)** | <kbd>Super</kbd> + <kbd>C</kbd> | <kbd>Alt</kbd> + <kbd>C</kbd> |
| **GUI Editor (Zed)** | <kbd>Super</kbd> + <kbd>Z</kbd> | <kbd>Alt</kbd> + <kbd>Z</kbd> |
| **Cycle Windows** | <kbd>Alt</kbd> + <kbd>Tab</kbd> (Native cycling) | <kbd>Alt</kbd> + <kbd>Tab</kbd> (Native cycling) |
| **Focus Window (Vim)** | <kbd>Super</kbd> + <kbd>H</kbd> / <kbd>J</kbd> / <kbd>K</kbd> / <kbd>L</kbd> | <kbd>Alt</kbd> + <kbd>H</kbd> / <kbd>J</kbd> / <kbd>K</kbd> / <kbd>L</kbd> |
| **Move Window (Vim)** | <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>H</kbd> / <kbd>J</kbd> / <kbd>K</kbd> / <kbd>L</kbd> | <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>H</kbd> / <kbd>J</kbd> / <kbd>K</kbd> / <kbd>L</kbd> |
| **Switch Workspace 1-10** | <kbd>Super</kbd> + <kbd>1</kbd> .. <kbd>0</kbd> | <kbd>Alt</kbd> + <kbd>1</kbd> .. <kbd>0</kbd> |
| **Move Window to WS 1-10**| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>1</kbd> .. <kbd>0</kbd> | <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>1</kbd> .. <kbd>0</kbd> |
| **Close Window** | <kbd>Super</kbd> + <kbd>Q</kbd> | <kbd>Alt</kbd> + <kbd>Q</kbd> |
| **Toggle Fullscreen** | <kbd>Super</kbd> + <kbd>F</kbd> | <kbd>Alt</kbd> + <kbd>F</kbd> |
| **Toggle Float / Tile** | <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>Space</kbd> | <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>Space</kbd> |
| **Toggle Topbar (Wayle)** | <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>B</kbd> | N/A (macOS native menubar) |
| **Reload Config** | <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>R</kbd> | <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>R</kbd> |

---

## 🚀 Installation & Setup

### 🐧 Ubuntu / Linux (Hyprland Desktop)
To bootstrap the complete desktop environment (Hyprland, Wayle, Vicinae, Kitty, fonts, mise tools, wallpapers, and browser profiles):

```bash
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles
./hypr_install.sh
```

Or for base CLI tools and configs only:
```bash
./install.sh
```

### 🍎 macOS (AeroSpace Desktop)
To bootstrap Homebrew, AeroSpace, Kitty, Raycast, Neovim, Zed, mise, and stowed configs:

```bash
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles
./mac_install.sh
```

---

## 🌐 Reproducible Browser Profiles (Zen & Firefox)

Both **Zen Browser** and **Firefox** profiles are declarative and reproducible across machines:

```
zen/
├── setup_zen.sh          # Auto-links profile configuration
├── user.js               # Hardware accel (VAAPI), WebRender, smooth scroll & privacy
└── chrome/
    ├── userChrome.css    # Catppuccin Mocha UI for Zen Browser
    └── userContent.css   # Catppuccin Mocha for internal / newtab pages

firefox/
├── setup_firefox.sh      # Auto-links profile configuration
├── user.js               # Privacy & performance flags
└── chrome/
    ├── userChrome.css    # Catppuccin Mocha UI for Firefox
    └── userContent.css   # Catppuccin Mocha for internal pages
```

Run either script anytime to apply the configuration to any local profile (Linux Flatpak, native Linux, or macOS):
```bash
~/dotfiles/zen/setup_zen.sh
~/dotfiles/firefox/setup_firefox.sh
```

---

## 📦 Directory Structure

```
dotfiles/
├── aerospace/            # AeroSpace window manager config for macOS
├── atuin/                # Shell history sync & search
├── btop/                 # System monitor with Catppuccin Mocha theme
├── firefox/              # Reproducible Firefox profile & userChrome.css
├── git/                  # Global gitconfig and gitignore
├── hypr/                 # Hyprland (hyprland.lua, hyprpaper, hypridle, hyprlock)
├── kitty/                # Kitty terminal with Catppuccin Mocha
├── lazygit/              # TUI git client with Catppuccin Mocha theme
├── mise/                 # Polyglot runtimes & CLI tools config
├── nvim/                 # Neovim (Lazy.nvim, transparent Catppuccin Mocha)
├── oh-my-posh/           # Catppuccin Mocha prompt theme
├── opencode/             # AI agent CLI configuration
├── tmux/                 # Tmux with Catppuccin & Wayland clipboard
├── vicinae/              # Raycast-style launcher, clipboard, and emoji selector
├── wayle/                # Minimal 27px GTK4/Rust desktop menubar
├── zed/                  # Zed editor settings & Catppuccin Mocha theme
├── zen/                  # Reproducible Zen browser profile & userChrome.css
├── zsh/                  # Modular Zsh configuration
├── install.sh            # Universal bootstrap script
├── hypr_install.sh       # Ubuntu / Hyprland full installer
└── mac_install.sh        # macOS / AeroSpace full installer
```
