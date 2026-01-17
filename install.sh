#!/bin/bash
# dotfiles installer

DOTFILES="$HOME/dotfiles"

# alacritty
mkdir -p ~/.config/alacritty
ln -sf "$DOTFILES/.config/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml
ln -sf "$DOTFILES/.config/alacritty/cheatsheet.txt" ~/.config/alacritty/cheatsheet.txt

# tmux
ln -sf "$DOTFILES/.tmux.conf" ~/.tmux.conf

echo "Done!"
