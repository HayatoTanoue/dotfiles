# ============================================
# Path & Environment
# ============================================
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export EDITOR="nvim"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv &> /dev/null; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"

# uv
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# conda
if [ -x "/opt/homebrew/Caskroom/miniconda/base/bin/conda" ]; then
    __conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
            . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
        else
            export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
        fi
    fi
    unset __conda_setup
fi

# ============================================
# Completion (daily cache for fast startup)
# ============================================
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# ============================================
# Plugins
# ============================================
# zsh-autosuggestions
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# zsh-syntax-highlighting
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# aliases & fzf-tab (must be after compinit)
source ~/dotfiles/.aliases

# ============================================
# Prompt
# ============================================
eval "$(starship init zsh)"

# ============================================
# Aliases
# ============================================

# GPU Server Shortcuts
alias h100-1='ssh-tmux H100_1'
alias h100-2='ssh-tmux H100_2'
alias x127='ssh-tmux Xeon127'
alias x128='ssh-tmux Xeon128'
alias x129='ssh-tmux Xeon129'
alias x130='ssh-tmux Xeon130'
alias aids101='ssh-tmux AIDS_101'
alias aids102='ssh-tmux AIDS_102'
alias aids103='ssh-tmux AIDS_103'
alias aids104='ssh-tmux AIDS_104'
alias aids105='ssh-tmux AIDS_105'
alias dev='ssh-tmux TanouePC'
alias dev-vgc='ssh-tmux TanouePC /home/hayatotanoue/rag-moc/VGC'
alias setup-gpu='~/.local/bin/setup-gpu-server.sh'
alias claude-multi='ssh-tmux-multi TanouePC'
