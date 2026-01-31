#!/bin/bash
# dotfiles installer (macOS)

set -e

DOTFILES="$HOME/dotfiles"

# brew install
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing packages..."
brew install tmux tmuxinator cheat starship zsh-autosuggestions eza bat lazygit tig rust fzf yazi nvm glow poppler
brew install --cask font-hack-nerd-font

# node (via nvm) + codex
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
if ! command -v node &> /dev/null; then
    echo "Installing Node.js via nvm..."
    nvm install --lts
fi
if ! command -v codex &> /dev/null; then
    echo "Installing OpenAI Codex..."
    npm i -g @openai/codex
fi

# filetree (cargo)
if ! command -v ft &> /dev/null; then
    echo "Installing filetree..."
    cargo install filetree
fi
# fzf-tab
if [ ! -d "$HOME/.zsh/fzf-tab" ]; then
    echo "Installing fzf-tab..."
    mkdir -p ~/.zsh
    git clone https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab
fi

# alacritty (build from source — Homebrew cask deprecated)
if [ ! -d "$HOME/.local/src/alacritty" ]; then
    echo "Cloning alacritty..."
    mkdir -p ~/.local/src
    git clone https://github.com/alacritty/alacritty.git ~/.local/src/alacritty
fi
cd ~/.local/src/alacritty
git pull
echo "Building alacritty..."
make app
if [ -d /Applications/Alacritty.app ]; then
    rm -rf /Applications/Alacritty.app
fi
cp -r target/release/osx/Alacritty.app /Applications/
cd "$DOTFILES"

mkdir -p ~/.config/alacritty
ln -sf "$DOTFILES/.config/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml

# cheat
mkdir -p ~/.config/cheat/cheatsheets
ln -sf "$DOTFILES/.config/cheat/conf.yml" ~/.config/cheat/conf.yml
ln -sf "$DOTFILES/.config/cheat/cheatsheets/personal" ~/.config/cheat/cheatsheets/personal

# tmux
ln -sf "$DOTFILES/.tmux.conf" ~/.tmux.conf

# tmuxinator
mkdir -p ~/.config/tmuxinator
ln -sf "$DOTFILES/.config/tmuxinator/dev.yml" ~/.config/tmuxinator/dev.yml
ln -sf "$DOTFILES/.config/tmuxinator/ssh.yml" ~/.config/tmuxinator/ssh.yml

# bin scripts
mkdir -p ~/bin
ln -sf "$DOTFILES/bin/ssht" ~/bin/ssht
ln -sf "$DOTFILES/bin/dev" ~/bin/dev
ln -sf "$DOTFILES/bin/multi-claude" ~/bin/multi-claude
ln -sf "$DOTFILES/bin/git-summary" ~/bin/git-summary
ln -sf "$DOTFILES/bin/claude-notify" ~/bin/claude-notify
ln -sf "$DOTFILES/bin/claude-state-reporter" ~/bin/claude-state-reporter
ln -sf "$DOTFILES/bin/claude-supervisor" ~/bin/claude-supervisor
ln -sf "$DOTFILES/bin/claude-orchestrator" ~/bin/claude-orchestrator

# ssht config
mkdir -p ~/.config/ssht
ln -sf "$DOTFILES/.config/ssht/paths" ~/.config/ssht/paths

# git config for this repo
cd "$DOTFILES"
git config user.name "HayatoTanoue"
git config user.email "HayatoTanoue@users.noreply.github.com"

# yazi
ln -sfn "$DOTFILES/.config/yazi" ~/.config/yazi
ya pkg add BennyOe/tokyo-night 2>/dev/null || true
ya pkg add yazi-rs/plugins:piper 2>/dev/null || true

# starship
ln -sf "$DOTFILES/.config/starship.toml" ~/.config/starship.toml

# claude code settings
mkdir -p ~/.claude
sed "s|\$HOME|$HOME|g" "$DOTFILES/.claude/settings.json" > ~/.claude/settings.json

# claude code agents
mkdir -p ~/.claude/agents
ln -sfn "$DOTFILES/.claude/agents/dev-doc-architect" ~/.claude/agents/dev-doc-architect

# vimrc
ln -sf "$DOTFILES/.vimrc" ~/.vimrc

# aliases
ln -sf "$DOTFILES/.aliases" ~/.aliases

# zshrc
ln -sf "$DOTFILES/.zshrc" ~/.zshrc

echo "Done! Restart your shell or run: source ~/.zshrc"
