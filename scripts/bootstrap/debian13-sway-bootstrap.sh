#!/usr/bin/env bash
set -euo pipefail

# 1) Base Sway/Wayland stack
APT_PKGS=(
  sway swaybg swayidle swaylock xwayland
  grim slurp wl-clipboard kanshi
  waybar wofi sway-notification-center clipman
  foot kitty alacritty
  xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk
  pipewire pipewire-pulse wireplumber
  thunar
)

sudo apt-get update
sudo apt-get install -y "${APT_PKGS[@]}"

# 2) Flatpaks (add flathub if missing)
if command -v flatpak >/dev/null; then
  if ! flatpak remotes | grep -q flathub; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  fi
  flatpak install -y flathub com.discordapp.Discord md.obsidian.Obsidian org.gnome.TextEditor
fi

# 3) Re-enable user services that make the session behave like before
# Requires a user session (login); if running in TTY, this will stage them.
systemctl --user daemon-reload || true
for unit in \
  waybar.service \
  swaync.service \
  pipewire.service \
  pipewire-pulse.service \
  wireplumber.service \
  foot-server.service \
  mpris-proxy.service
do
  systemctl --user enable --now "$unit" || true
done

echo "Sway stack reinstall complete. Make sure your dotfiles are in place (~/.config/sway, waybar, kanshi, etc.)."
