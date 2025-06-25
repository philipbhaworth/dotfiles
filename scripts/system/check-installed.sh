#!/bin/bash

echo "=== PPAs & Repositories ==="
grep -rh ^deb /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null || echo "No additional repos"

echo -e "\n=== Explicit APT Packages ==="
comm -23 \
  <(apt-mark showmanual | sort) \
  <(apt-mark showauto | sort) \
  | xargs dpkg-query -W -f='${Package} ${Version}\n'

echo -e "\n=== pipx Tools ==="
command -v pipx >/dev/null && pipx list || echo "pipx not installed"

echo -e "\n=== Snap Packages ==="
command -v snap >/dev/null && snap list || echo "snap not installed"

echo -e "\n=== Manual Tools (/usr/local/bin, ~/.local/bin) ==="
for dir in /usr/local/bin ~/.local/bin; do
  [ -d "$dir" ] && find "$dir" -type f -executable 2>/dev/null | while read -r bin; do
    dpkg -S "$bin" >/dev/null 2>&1 || echo "$bin"
  done
done
