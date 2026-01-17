#!/bin/bash
# dotfiles installer for servers (Linux)
# Usage: curl -sL https://raw.githubusercontent.com/HayatoTanoue/dotfiles/main/install-server.sh | bash

set -e

DOTFILES="$HOME/dotfiles"

# clone if not exists
if [ ! -d "$DOTFILES" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/HayatoTanoue/dotfiles.git "$DOTFILES"
fi

# install tmux if not exists
if ! command -v tmux &> /dev/null; then
    echo "Installing tmux..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y tmux
    elif command -v yum &> /dev/null; then
        sudo yum install -y tmux
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y tmux
    else
        echo "Package manager not found. Install tmux manually."
    fi
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

# add starship to .bashrc
if ! grep -q 'starship init' ~/.bashrc 2>/dev/null; then
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
    echo "Added starship to .bashrc"
fi

echo "Done!"
