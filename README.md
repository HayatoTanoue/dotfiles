# dotfiles

Ghostty + tmux の開発環境設定

## セットアップ

### macOS

```bash
git clone https://github.com/HayatoTanoue/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

### サーバー (Linux)

```bash
curl -sL https://raw.githubusercontent.com/HayatoTanoue/dotfiles/main/install-server.sh | bash
```

### アップデート

```bash
# macOS
cd ~/dotfiles && git pull && ./install.sh

# サーバー
cd ~/dotfiles && git pull && ./install-server.sh
```

## インストールされるソフトウェア

### 共通（macOS / Linux）

| カテゴリ | ツール | 説明 |
|---|---|---|
| シェル | zsh, starship, fzf, fzf-tab, zsh-autosuggestions | シェル環境 + プロンプト + 補完 |
| tmux | tmux, tmuxinator, TPM | ターミナルマルチプレクサ + レイアウト管理 |
| ファイル | yazi, filetree (ft) | ファイルマネージャ + ツリー表示 |
| Git | lazygit, tig | Git TUI + ログビューア |
| CLI | eza, bat, fzf, cheat, glow, btop | ls/cat 代替、ファジーファインダー、チートシート、Markdown ビューア、システムモニタ |
| 開発 | Node.js (nvm), Rust (cargo), OpenAI Codex | ランタイム + ツールチェーン |
| AI | Claude Code | AI コーディングアシスタント（Linux のみ自動インストール） |

### macOS のみ

| ツール | 説明 |
|---|---|
| Homebrew | パッケージマネージャ（未インストール時に自動導入） |
| Ghostty | ターミナルエミュレータ (cask) |
| Hack Nerd Font | Nerd Font (cask) |
| poppler | PDF レンダリング（yazi プレビュー用） |

### Linux のみ

| ツール | 説明 |
|---|---|
| nvtop | GPU モニタ |
| Claude Code | AI コーディングアシスタント（自動インストール） |

## bin スクリプト

| コマンド | 用途 |
|---|---|
| `ssht` | SSH 先で tmux セッションを開始（3ペイン / dev 構成） |
| `dev` | ローカルで tmuxinator の dev 構成を起動 |
| `multi-claude` | 複数 Claude Code + モニタリングの tmux レイアウト |
| `git-summary` | ブランチ・コミット・変更ファイルの要約表示 |
| `tmux-status-color` | セッション名に応じたステータスバー配色 |

## 使い方

```bash
ssht myserver              # SSH先のtmuxに3ペイン分割で接続
ssht myserver dev ~/proj   # SSH先でdev構成を起動

dev                        # カレントディレクトリでdev構成
dev ~/project              # 指定ディレクトリでdev構成

multi-claude 3             # Claude Code 3並列 + yazi/btop/nvtop
```

## チートシート

```bash
cheat tmux       # tmux操作
cheat ssht       # SSH接続
cheat dev        # dev構成
cheat yazi       # yazi操作
cheat lazygit    # lazygit操作
cheat tig        # tig操作
cheat filetree   # filetree操作
cheat alacritty  # Alacritty操作（旧環境用）
```

## ディレクトリ構成

```
~/dotfiles/
├── .config/
│   ├── ghostty/config
│   ├── alacritty/alacritty.toml
│   ├── btop/btop.conf
│   ├── cheat/
│   │   ├── conf.yml
│   │   └── cheatsheets/personal/
│   ├── ssht/paths
│   ├── starship.toml
│   ├── tmuxinator/
│   │   ├── dev.yml
│   │   └── ssh.yml
│   └── yazi/
│       ├── yazi.toml
│       └── theme.toml
├── bin/
│   ├── ssht
│   ├── dev
│   ├── multi-claude
│   ├── git-summary
│   └── tmux-status-color
├── .claude/
│   └── agents/
├── .tmux.conf
├── .zshrc / .zshrc.server
├── .vimrc
├── .aliases
├── install.sh          # macOS用
└── install-server.sh   # Linux用
```
