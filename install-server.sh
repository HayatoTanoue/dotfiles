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
    sudo apt-get install -y zsh zsh-autosuggestions bat gpg wget unzip tig fzf locales poppler-utils

    # setup UTF-8 locale
    sudo locale-gen en_US.UTF-8
    sudo update-locale LANG=en_US.UTF-8

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

# install tmux (build from source for 3.3+ features)
TMUX_REQUIRED="3.3"
TMUX_CURRENT=$(tmux -V 2>/dev/null | awk '{print $2}' | tr -d 'a-z')
if [ -z "$TMUX_CURRENT" ] || awk "BEGIN{exit (!($TMUX_CURRENT < $TMUX_REQUIRED))}"; then
    echo "Installing tmux >= $TMUX_REQUIRED from source..."
    sudo apt-get install -y libevent-dev ncurses-dev build-essential bison pkg-config
    TMUX_VERSION="3.5a"
    cd /tmp
    curl -sLO "https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz"
    tar xf "tmux-${TMUX_VERSION}.tar.gz"
    cd "tmux-${TMUX_VERSION}"
    ./configure && make -j"$(nproc)"
    sudo make install
    cd /tmp && rm -rf "tmux-${TMUX_VERSION}" "tmux-${TMUX_VERSION}.tar.gz"
fi

# install starship
if ! command -v starship &> /dev/null; then
    echo "Installing starship..."
    mkdir -p ~/.local/bin
    curl -sS https://starship.rs/install.sh | sh -s -- -y -b ~/.local/bin
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
    mkdir -p ~/.local/bin
    mv lazygit ~/.local/bin/
    cd -
fi

# install Claude Code
if ! command -v claude &> /dev/null; then
    echo "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
fi

# install nvm + node
if ! command -v node &> /dev/null; then
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm install --lts
fi

# install codex
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
if ! command -v codex &> /dev/null; then
    echo "Installing OpenAI Codex..."
    npm i -g @openai/codex
fi

# install tmuxinator
if ! command -v tmuxinator &> /dev/null; then
    echo "Installing tmuxinator..."
    sudo apt-get install -y ruby
    sudo gem install tmuxinator
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

# install yazi (pre-built musl binary to avoid glibc version issues)
if ! command -v yazi &> /dev/null; then
    echo "Installing yazi..."
    ARCH=$(uname -m)
    if [ "$ARCH" = "aarch64" ]; then
        YAZI_ARCH="aarch64-unknown-linux-musl"
    else
        YAZI_ARCH="x86_64-unknown-linux-musl"
    fi
    curl -sLo /tmp/yazi.zip "https://github.com/sxyazi/yazi/releases/latest/download/yazi-${YAZI_ARCH}.zip"
    unzip -o /tmp/yazi.zip -d /tmp/yazi
    mkdir -p ~/.local/bin
    mv "/tmp/yazi/yazi-${YAZI_ARCH}/ya" ~/.local/bin/
    mv "/tmp/yazi/yazi-${YAZI_ARCH}/yazi" ~/.local/bin/
    rm -rf /tmp/yazi /tmp/yazi.zip
fi

# install glow (markdown renderer for yazi preview)
if ! command -v glow &> /dev/null; then
    echo "Installing glow..."
    ARCH=$(uname -m)
    if [ "$ARCH" = "x86_64" ]; then
        GLOW_ARCH="x86_64"
    elif [ "$ARCH" = "aarch64" ]; then
        GLOW_ARCH="arm64"
    fi
    GLOW_VERSION=$(curl -s "https://api.github.com/repos/charmbracelet/glow/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -sLo /tmp/glow.tar.gz "https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/glow_${GLOW_VERSION}_Linux_${GLOW_ARCH}.tar.gz"
    mkdir -p ~/.local/bin
    tar xf /tmp/glow.tar.gz -C /tmp --strip-components=1 "glow_${GLOW_VERSION}_Linux_${GLOW_ARCH}/glow"
    mv /tmp/glow ~/.local/bin/
    rm -f /tmp/glow.tar.gz
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
    mkdir -p ~/.local/bin
    mv "cheat-linux-${ARCH}" ~/.local/bin/cheat
    cd -
fi

# tmux config
ln -sf "$DOTFILES/.tmux.conf" ~/.tmux.conf

# starship config
mkdir -p ~/.config
ln -sf "$DOTFILES/.config/starship.toml" ~/.config/starship.toml

# yazi config
ln -sfn "$DOTFILES/.config/yazi" ~/.config/yazi
source "$HOME/.cargo/env" 2>/dev/null || true
ya pkg add BennyOe/tokyo-night 2>/dev/null || true
ya pkg add yazi-rs/plugins:piper 2>/dev/null || true

# cheat config
mkdir -p ~/.config/cheat/cheatsheets
ln -sf "$DOTFILES/.config/cheat/conf.yml" ~/.config/cheat/conf.yml
rm -rf ~/.config/cheat/cheatsheets/personal
ln -s "$DOTFILES/.config/cheat/cheatsheets/personal" ~/.config/cheat/cheatsheets/personal

# fzf-tab
if [ ! -d "$HOME/.zsh/fzf-tab" ]; then
    echo "Installing fzf-tab..."
    mkdir -p ~/.zsh
    git clone https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab
fi

# bin scripts
mkdir -p ~/bin
ln -sf "$DOTFILES/bin/dev" ~/bin/dev
ln -sf "$DOTFILES/bin/multi-claude" ~/bin/multi-claude
ln -sf "$DOTFILES/bin/git-summary" ~/bin/git-summary
ln -sf "$DOTFILES/bin/tmux-status-color" ~/bin/tmux-status-color

# tmuxinator config
mkdir -p ~/.config/tmuxinator
ln -sf "$DOTFILES/.config/tmuxinator/dev.yml" ~/.config/tmuxinator/dev.yml
ln -sf "$DOTFILES/.config/tmuxinator/ssh.yml" ~/.config/tmuxinator/ssh.yml

# ssht config
mkdir -p ~/.config/ssht
ln -sf "$DOTFILES/.config/ssht/paths" ~/.config/ssht/paths

# aliases
ln -sf "$DOTFILES/.aliases" ~/.aliases

# zshrc
ln -sf "$DOTFILES/.zshrc.server" ~/.zshrc

# change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s $(which zsh) || echo "chsh failed, run manually: chsh -s \$(which zsh)"
fi

echo "Done! Restarting shell..."
exec zsh
