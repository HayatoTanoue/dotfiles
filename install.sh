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
brew install tmux tmuxinator cheat starship zsh-autosuggestions eza bat lazygit tig rust fzf yazi nvm glow poppler btop
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

# ghostty
brew install --cask ghostty

mkdir -p ~/.config/ghostty
ln -sf "$DOTFILES/.config/ghostty/config" ~/.config/ghostty/config

# cheat
mkdir -p ~/.config/cheat/cheatsheets
ln -sf "$DOTFILES/.config/cheat/conf.yml" ~/.config/cheat/conf.yml
ln -sf "$DOTFILES/.config/cheat/cheatsheets/personal" ~/.config/cheat/cheatsheets/personal

# tmux
ln -sf "$DOTFILES/.tmux.conf" ~/.tmux.conf

# TPM (tmux plugin manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

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
ln -sf "$DOTFILES/bin/tmux-status-color" ~/bin/tmux-status-color

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

# btop
mkdir -p ~/.config/btop
ln -sf "$DOTFILES/.config/btop/btop.conf" ~/.config/btop/btop.conf

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
