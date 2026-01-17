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
- tmux, tmuxinator
- Alacritty

### サーバー (Linux)

```bash
curl -sL https://raw.githubusercontent.com/HayatoTanoue/dotfiles/main/install-server.sh | bash
```

または:
```bash
git clone https://github.com/HayatoTanoue/dotfiles.git ~/dotfiles
~/dotfiles/install-server.sh
```

## 使い方

### SSH接続

```bash
ssht myserver    # SSH先のtmuxに3ペイン分割で接続
```

- 初回: 3ペイン分割でセッション作成
- 再接続: 既存セッションにアタッチ

### tmux操作

| キー | 操作 |
|------|------|
| `C-a \|` | 縦分割 |
| `C-a -` | 横分割 |
| `C-a h/j/k/l` | ペイン移動 |
| `C-a d` | デタッチ |
| `C-a c` | 新しいウィンドウ |
| `Shift+←/→` | ウィンドウ切り替え |

詳細: `cat ~/.config/alacritty/cheatsheet.txt`

## 構成

```
~/dotfiles/
├── .config/
│   ├── alacritty/
│   │   ├── alacritty.toml
│   │   └── cheatsheet.txt
│   └── tmuxinator/
│       ├── dev.yml
│       └── ssh.yml
├── bin/
│   └── ssht
├── .tmux.conf
├── install.sh          # macOS用
└── install-server.sh   # Linux用
```
