# Dotfiles Repo

This repository contains personal configuration files (dotfiles) for various tools and environments, managed using [GNU Stow](https://www.gnu.org/software/stow/).

## 📦 Structure

The repo is organized by tool/service. Each subdirectory is a stow package and contains config files that should be symlinked to your home directory.

```
dots/
├── bash/          -> ~/.bashrc
├── zsh/           -> ~/.zshrc
├── tmux/          -> ~/.tmux.conf
├── vim/           -> ~/.vimrc
├── nvim/          -> ~/.config/nvim/
├── starship/      -> ~/.config/starship/
├── wezterm/       -> ~/.config/wezterm/
├── yazi/          -> ~/.config/yazi/
├── karabiner/     -> ~/.config/karabiner/
├── aerospace/     -> ~/.config/aerospace/
├── scripts/       -> ~/scripts/
└── Brewfile       -> used for macOS Homebrew setup
```

> **Note:** Files like `.gitconfig` or `Brewfile` can either be symlinked manually or wrapped in a subdirectory (e.g., `git/`) for Stow to handle.

---

## ✅ Prerequisites

Install GNU Stow:

### On Linux

```bash
sudo apt install stow         # Debian/Ubuntu
# OR
sudo pacman -S stow           # Arch
# OR
sudo dnf install stow         # Fedora
```

### On macOS (via Homebrew)

```bash
brew install stow
```

---

## 🚀 Usage

From the repo root:

```bash
stow <package>
```

Example:

```bash
stow bash
stow zsh
stow nvim
```

This creates symlinks from the files inside each package (like `bash/.bashrc`) to your home directory (`~/.bashrc`).

To remove a stowed package:

```bash
stow -D <package>
```

---

## 🗂️ Note on Nested Dotfile Directories

If you're managing dotfiles from a **nested directory** (e.g., `~/dotfiles/`), and not directly from your home directory, you'll need to add the `-t` (target) flag:

```bash
stow -t ~ zsh
stow -t ~ nvim
```

This ensures Stow places the symlinks correctly into your home directory.

---

## 🛠 Extras

* `scripts/`: Handy utilities (e.g., ZFS checks, IPMI power control, Raycast integrations).
* `Brewfile`: Run `brew bundle` to install macOS packages.

---

