#!/bin/bash
# dotfiles installer for servers (Linux/Ubuntu)
# Usage: curl -sL https://raw.githubusercontent.com/HayatoTanoue/dotfiles/main/install-server.sh | bash

set -e

DOTFILES="$HOME/dotfiles"

# clone or update dotfiles
if [ ! -d "$DOTFILES" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/HayatoTanoue/dotfiles.git "$DOTFILES"
else
    echo "Updating dotfiles..."
    cd "$DOTFILES" && git pull
fi

# cleanup broken symlinks in dotfiles
find "$DOTFILES" -xtype l -delete 2>/dev/null || true

# install packages (Ubuntu/Debian)
if command -v apt-get &> /dev/null; then
    echo "Installing packages..."
    sudo apt-get update
    sudo apt-get install -y tmux zsh zsh-autosuggestions bat gpg wget unzip tig

    # eza (add repo if not available)
    if ! command -v eza &> /dev/null; then
        if ! sudo apt-get install -y eza 2>/dev/null; then
            echo "Adding eza repository..."
            sudo mkdir -p /etc/apt/keyrings
            wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
            echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
            sudo apt-get update
            sudo apt-get install -y eza
        fi
    fi
fi

# install starship
if ! command -v starship &> /dev/null; then
    echo "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# install lazygit
if ! command -v lazygit &> /dev/null; then
    echo "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    ARCH=$(uname -m)
    if [ "$ARCH" = "x86_64" ]; then
        ARCH="x86_64"
    elif [ "$ARCH" = "aarch64" ]; then
        ARCH="arm64"
    fi
    curl -sLo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${ARCH}.tar.gz"
    cd /tmp && tar xf lazygit.tar.gz lazygit
    sudo mv lazygit /usr/local/bin/
    cd -
fi

# install rust (for filetree)
if ! command -v cargo &> /dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# install filetree
if ! command -v ft &> /dev/null; then
    echo "Installing filetree..."
    source "$HOME/.cargo/env" 2>/dev/null || true
    cargo install filetree
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
mkdir -p ~/.config/cheat/cheatsheets/community
ln -sf "$DOTFILES/.config/cheat/conf.yml" ~/.config/cheat/conf.yml
rm -rf ~/.config/cheat/cheatsheets/personal
ln -s "$DOTFILES/.config/cheat/cheatsheets/personal" ~/.config/cheat/cheatsheets/personal

# bin scripts
mkdir -p ~/bin
ln -sf "$DOTFILES/bin/git-summary" ~/bin/git-summary

# setup .zshrc
if ! grep -q 'PATH.*bin' ~/.zshrc 2>/dev/null; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
fi
if ! grep -q 'cargo/env' ~/.zshrc 2>/dev/null; then
    echo 'source "$HOME/.cargo/env" 2>/dev/null || true' >> ~/.zshrc
fi
if ! grep -q 'starship init' ~/.zshrc 2>/dev/null; then
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi
if ! grep -q 'zsh-autosuggestions' ~/.zshrc 2>/dev/null; then
    echo 'source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
fi
if ! grep -q 'dotfiles/.aliases' ~/.zshrc 2>/dev/null; then
    echo 'source ~/dotfiles/.aliases' >> ~/.zshrc
fi

# change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s $(which zsh) || echo "chsh failed, run manually: chsh -s \$(which zsh)"
fi

echo "Done! Restarting shell..."
exec zsh
