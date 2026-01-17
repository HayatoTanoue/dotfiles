# dotfiles

Alacritty + tmux の開発環境設定

## セットアップ

### macOS

```bash
git clone https://github.com/HayatoTanoue/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

インストールされるもの:
- Homebrew（未インストールの場合）
- tmux, tmuxinator, cheat
- Alacritty

### サーバー (Linux)

```bash
curl -sL https://raw.githubusercontent.com/HayatoTanoue/dotfiles/main/install-server.sh | bash
```

## 使い方

### SSH接続

```bash
ssht myserver    # SSH先のtmuxに3ペイン分割で接続
```

### チートシート

```bash
cheat tmux       # tmux操作
cheat ssht       # SSH接続
cheat alacritty  # Alacritty操作
```

## 構成

```
~/dotfiles/
├── .config/
│   ├── alacritty/
│   │   └── alacritty.toml
│   ├── cheat/
│   │   ├── conf.yml
│   │   └── cheatsheets/personal/
│   │       ├── tmux
│   │       ├── ssht
│   │       └── alacritty
│   └── tmuxinator/
│       ├── dev.yml
│       └── ssh.yml
├── bin/
│   └── ssht
├── .tmux.conf
├── install.sh          # macOS用
└── install-server.sh   # Linux用
```
