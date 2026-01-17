#!/bin/bash
# dotfiles installer for servers (Linux/Ubuntu)
# Usage: curl -sL https://raw.githubusercontent.com/HayatoTanoue/dotfiles/main/install-server.sh | bash

set -e

DOTFILES="$HOME/dotfiles"

# clone if not exists
if [ ! -d "$DOTFILES" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/HayatoTanoue/dotfiles.git "$DOTFILES"
fi

# install packages (Ubuntu/Debian)
if command -v apt-get &> /dev/null; then
    echo "Installing packages..."
    sudo apt-get update
    sudo apt-get install -y tmux zsh zsh-autosuggestions
fi

# install starship
if ! command -v starship &> /dev/null; then
    echo "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# install cheat
if ! command -v cheat &> /dev/null; then
    echo "Installing cheat..."
    cd /tmp
    CHEAT_VERSION="4.4.2"
    ARCH=$(uname -m)
    if [ "$ARCH" = "x86_64" ]; then
        ARCH="amd64"
    elif [ "$ARCH" = "aarch64" ]; then
        ARCH="arm64"
    fi
    curl -sLO "https://github.com/cheat/cheat/releases/download/${CHEAT_VERSION}/cheat-linux-${ARCH}.gz"
    gunzip "cheat-linux-${ARCH}.gz"
    chmod +x "cheat-linux-${ARCH}"
    sudo mv "cheat-linux-${ARCH}" /usr/local/bin/cheat
    cd -
fi

# tmux config
ln -sf "$DOTFILES/.tmux.conf" ~/.tmux.conf

# starship config
mkdir -p ~/.config
ln -sf "$DOTFILES/.config/starship.toml" ~/.config/starship.toml

# cheat config
mkdir -p ~/.config/cheat/cheatsheets
ln -sf "$DOTFILES/.config/cheat/conf.yml" ~/.config/cheat/conf.yml
ln -sf "$DOTFILES/.config/cheat/cheatsheets/personal" ~/.config/cheat/cheatsheets/personal

# setup .zshrc
if [ ! -f ~/.zshrc ] || ! grep -q 'starship init' ~/.zshrc 2>/dev/null; then
    cat >> ~/.zshrc << 'EOF'

# dotfiles config
eval "$(starship init zsh)"
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
EOF
    echo "Added config to .zshrc"
fi

# change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s $(which zsh)
fi

echo "Done!"
echo ""
echo "Restart your shell or run: exec zsh"
