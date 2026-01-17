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
brew install tmux tmuxinator cheat starship zsh-autosuggestions eza bat lazygit yazi
brew install --cask alacritty

# alacritty
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

# git config for this repo
cd "$DOTFILES"
git config user.name "HayatoTanoue"
git config user.email "HayatoTanoue@users.noreply.github.com"

# starship
ln -sf "$DOTFILES/.config/starship.toml" ~/.config/starship.toml

echo "Done!"
echo ""
echo "Add to .zshrc if not already:"
echo '  export PATH="$HOME/bin:$PATH"'
echo '  eval "$(starship init zsh)"'
echo '  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
echo '  source ~/dotfiles/.aliases'
