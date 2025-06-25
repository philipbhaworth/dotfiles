#!/bin/bash
# Comprehensive Ubuntu Homelab Update Script

set -e # Exit on any error

echo "🚀 Starting Ubuntu Homelab Tools Update..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Update system packages
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y
print_success "System packages updated"

# Update PPAs (if any exist)
if [ -d /etc/apt/sources.list.d ] && [ "$(ls -A /etc/apt/sources.list.d)" ]; then
  print_status "Updating PPA sources..."
  sudo apt update
  print_success "PPA sources updated"
fi

# Update pipx tools
if command -v pipx >/dev/null 2>&1; then
  print_status "Updating pipx tools..."
  pipx upgrade-all
  print_success "pipx tools updated"
else
  print_warning "pipx not found, skipping pipx updates"
fi

# Update zsh plugins
print_status "Updating zsh plugins..."
if [ -d ~/.zsh/plugins/zsh-autosuggestions ]; then
  cd ~/.zsh/plugins/zsh-autosuggestions && git pull
  print_success "zsh-autosuggestions updated"
else
  print_warning "zsh-autosuggestions plugin not found"
fi

if [ -d ~/.zsh/plugins/zsh-syntax-highlighting ]; then
  cd ~/.zsh/plugins/zsh-syntax-highlighting && git pull
  print_success "zsh-syntax-highlighting updated"
else
  print_warning "zsh-syntax-highlighting plugin not found"
fi

# Update Starship
if command -v starship >/dev/null 2>&1; then
  print_status "Updating Starship..."
  # Check if installed via package manager or script
  if dpkg -l | grep -q starship; then
    # Installed via package manager, handled by apt
    print_success "Starship updated via apt"
  else
    # Installed via install script, update manually
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
    print_success "Starship updated via install script"
  fi
else
  print_warning "Starship not found"
fi

# Update LazyGit
if command -v lazygit >/dev/null 2>&1; then
  print_status "Checking LazyGit version..."
  current_version=$(lazygit --version | head -n1 | cut -d' ' -f6)
  latest_version=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name"' | cut -d'"' -f4)

  if [ "$current_version" != "$latest_version" ]; then
    print_status "Updating LazyGit from $current_version to $latest_version..."
    # Download and install latest lazygit
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
    print_success "LazyGit updated to $latest_version"
  else
    print_success "LazyGit is already up to date ($current_version)"
  fi
else
  print_warning "LazyGit not found"
fi

# Update lsd
if command -v lsd >/dev/null 2>&1; then
  print_status "Checking lsd version..."
  if dpkg -l | grep -q lsd; then
    print_success "lsd updated via apt"
  else
    print_warning "lsd not installed via package manager, check for manual updates"
  fi
else
  print_warning "lsd not found"
fi

# Note: Additional GitHub tools can be added here if needed

# Clean up
print_status "Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean

# Show versions
print_status "Current tool versions:"
echo "================================"
command -v ansible-lint >/dev/null 2>&1 && echo "ansible-lint: $(ansible-lint --version)"
command -v yamllint >/dev/null 2>&1 && echo "yamllint: $(yamllint --version)"
command -v jq >/dev/null 2>&1 && echo "jq: $(jq --version)"
command -v bat >/dev/null 2>&1 && echo "bat: $(bat --version)"
command -v rg >/dev/null 2>&1 && echo "ripgrep: $(rg --version | head -n1)"
command -v fzf >/dev/null 2>&1 && echo "fzf: $(fzf --version)"
command -v starship >/dev/null 2>&1 && echo "starship: $(starship --version)"
command -v lazygit >/dev/null 2>&1 && echo "lazygit: $(lazygit --version | head -n1)"
command -v lsd >/dev/null 2>&1 && echo "lsd: $(lsd --version)"
echo "================================"

print_success "✅ All updates completed!"
echo ""
print_status "💡 Tip: Run 'source ~/.zshrc' to reload your shell configuration"
