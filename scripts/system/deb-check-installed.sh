#!/usr/bin/env bash
# inventory-system.sh
# Enumerate what's installed/active on a Debian system for reproducible rebuilds.

set -euo pipefail
IFS=$'\n\t'

hr() { printf '\n=== %s ===\n' "$1"; }

# 0) Basic context
hr "System Context"
printf 'Hostname: %s\n' "$(hostname)"
printf 'Debian: %s\n' "$(grep -oP '(?<=VERSION=).+' /etc/os-release | tr -d '"')"
printf 'Kernel: %s\n' "$(uname -r)"
printf 'Arch:   %s\n' "$(dpkg --print-architecture)"
printf 'Foreign Architectures: %s\n' "$(dpkg --print-foreign-architectures | xargs echo || true)"

# 1) APT sources & keys
hr "APT Sources"
grep -rhE '^(deb|deb-src)\b' /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null || echo "No additional repos"

hr "APT Trusted Keys (*.gpg)"
# Keys can be in trusted.gpg.d or inline 'signed-by=' in sources entries
ls -1 /etc/apt/trusted.gpg.d/*.gpg 2>/dev/null || echo "No keyring files in /etc/apt/trusted.gpg.d"
grep -rh --color=never -E 'signed-by=.*\.gpg' /etc/apt/sources.list* /etc/apt/sources.list.d/* 2>/dev/null || true

hr "APT Pins (/etc/apt/preferences.d)"
grep -rH . /etc/apt/preferences /etc/apt/preferences.d 2>/dev/null || echo "No pinning configured"

# 2) APT package state
hr "Explicit APT Packages (name version)"
# Manual minus auto; show exact versions. -r avoids xargs on empty input.
comm -23 \
  <(apt-mark showmanual | sort -u) \
  <(apt-mark showauto | sort -u) \
  | xargs -r dpkg-query -W -f='${Package} ${Version}\n' \
  | sort

hr "Held APT Packages"
apt-mark showhold 2>/dev/null || echo "No holds"

hr "All APT Selections (dpkg)"
# Complete installed states (useful as a canonical fallback)
dpkg --get-selections

# 3) Orphans / locally installed .debs
hr "Locally Installed or Orphaned Packages"
# Packages not currently from any configured repo (need local .deb or extra repo)
if command -v aptitude >/dev/null 2>&1; then
  aptitude search '~i~o' || echo "Install 'aptitude' to detect orphans (~i~o)."
else
  # Fallback heuristic: 'apt list --installed' lines marked 'installed,local'
  apt list --installed 2>/dev/null | grep -F 'installed,local' || echo "No 'installed,local' packages found."
fi

# 4) Other ecosystems (optional but common)
hr "pipx Tools"
if command -v pipx >/dev/null 2>&1; then
  pipx list
else
  echo "pipx not installed"
fi

hr "Flatpak Apps"
if command -v flatpak >/dev/null 2>&1; then
  flatpak list --app --columns=application,version,origin
else
  echo "flatpak not installed"
fi

hr "Snap Packages"
if command -v snap >/dev/null 2>&1; then
  snap list
else
  echo "snap not installed"
fi

hr "Cargo (Rust) Installed Binaries"
if command -v cargo >/dev/null 2>&1; then
  cargo install --list || true
else
  echo "cargo not installed"
fi

hr "npm Global Packages"
if command -v npm >/dev/null 2>&1; then
  npm -g ls --depth=0 || true
else
  echo "npm not installed"
fi

hr "Go Installed Binaries"
if command -v go >/dev/null 2>&1; then
  GOPATH="$(go env GOPATH)"
  echo "GOPATH: ${GOPATH}"
  if [ -d "${GOPATH}/bin" ]; then
    find "${GOPATH}/bin" -maxdepth 1 -type f -executable -printf '%f\n'
  else
    echo "No ${GOPATH}/bin"
  fi
else
  echo "go not installed"
fi

# 5) Manually installed binaries (outside dpkg ownership)
hr "Manual Tools (/usr/local/bin, ~/.local/bin not owned by dpkg)"
for dir in /usr/local/bin "$HOME/.local/bin"; do
  [ -d "$dir" ] || continue
  # -print0 / xargs -0 to handle spaces
  find "$dir" -type f -executable -print0 2>/dev/null \
    | xargs -0 -I{} sh -c 'dpkg -S "{}" >/dev/null 2>&1 || echo "{}"'
done

# 6) Systemd state (what actually starts)
hr "Enabled systemd Services (system + user)"
systemctl list-unit-files --type=service --state=enabled --no-pager --no-legend | awk '{print $1}' | sort
if loginctl show-user "$USER" >/dev/null 2>&1; then
  systemctl --user list-unit-files --type=service --state=enabled --no-pager --no-legend | awk '{print $1}' | sort || true
fi

# 7) Sway/Wayland bits worth tracking
hr "Desktop Session (Sway-related)"
# Useful to verify portals/idle/locks etc. that affect usability
for pkg in sway swaybg swayidle swaylock xwayland wayland-protocols \
           xdg-desktop-portal xdg-desktop-portal-wlr grim slurp wl-clipboard \
           kanshi waybar foot alacritty mako; do
  dpkg-query -W -f='${Package} ${Version}\n' "$pkg" 2>/dev/null || true
done

#hr "Fonts Installed (family names)"
#if command -v fc-list >/dev/null 2>&1; then
#  fc-list : family | sort -u
#else
#  echo "fontconfig (fc-list) not installed"
#fi

hr "Done"
