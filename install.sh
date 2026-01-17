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
brew install tmux
brew install --cask alacritty

# alacritty
mkdir -p ~/.config/alacritty
ln -sf "$DOTFILES/.config/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml
ln -sf "$DOTFILES/.config/alacritty/cheatsheet.txt" ~/.config/alacritty/cheatsheet.txt

# tmux
ln -sf "$DOTFILES/.tmux.conf" ~/.tmux.conf

echo "Done!"
