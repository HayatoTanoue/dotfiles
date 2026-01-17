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

# tmux config
ln -sf "$DOTFILES/.tmux.conf" ~/.tmux.conf

# starship config
mkdir -p ~/.config
ln -sf "$DOTFILES/.config/starship.toml" ~/.config/starship.toml

# add starship to .bashrc
if ! grep -q 'starship init' ~/.bashrc 2>/dev/null; then
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
    echo "Added starship to .bashrc"
fi

echo "Done!"
