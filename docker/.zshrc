# Language
export LANG=ja_JP.UTF-8           # 日本語環境

#
# Coloring
#
autoload -Uz colors
colors
RESET="%{${reset_color}%}"
GREEN="%{${fg[green]}%}"
BLUE="%{${fg[blue]}%}"
RED="%{${fg[red]}%}"
REDBOLD="%{${fg_bold[red]}%}"
CYAN="%{${fg[cyan]}%}"
YELLOW="%{${fg[yellow]}%}"
MAGENTA="%{${fg[magenta]}%}"
WHITE="%{${fg[white]}%}"
BGBLUE="%{${bg[blue]}%}"

# molokai をしっかり使うための設定
export TERM=xterm-256color

# 履歴
HISTFILE=~/.zsh_history           # historyファイル
HISTSIZE=10000                    # ファイルサイズ
SAVEHIST=10000                    # saveする量
setopt hist_ignore_dups           # 重複を記録しない
setopt hist_reduce_blanks         # スペース排除
setopt share_history              # 履歴ファイルを共有
setopt EXTENDED_HISTORY           # zshの開始終了を記録

# Emacs ライクな操作を有効にする（文字入力中に Ctrl-F,B でカーソル移動など）
# Vi ライクな操作が好みであれば `bindkey -v` とする
bindkey -e

# 自動補完を有効にする
# コマンドの引数やパス名を途中まで入力して <Tab> を押すといい感じに補完してくれる
# 例： `cd path/to/<Tab>`, `ls -<Tab>`
autoload -U compinit; compinit

# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリに cd する
# 例： /usr/bin と入力すると /usr/bin ディレクトリに移動
setopt auto_cd

# ↑を設定すると、 .. とだけ入力したら1つ上のディレクトリに移動できるので……
# 2つ上、3つ上にも移動できるようにする
alias ...='cd ../..'
alias ....='cd ../../..'

# "~hoge" が特定のパス名に展開されるようにする（ブックマークのようなもの）
# 例： cd ~hoge と入力すると /long/path/to/hogehoge ディレクトリに移動
#hash -d hoge=/long/path/to/hogehoge
hash -d mw=~/github/mynaviwedding/source

# cd した先のディレクトリをディレクトリスタックに追加する
# ディレクトリスタックとは今までに行ったディレクトリの履歴のこと
# `cd +<Tab>` でディレクトリの履歴が表示され、そこに移動できる
setopt auto_pushd

# pushd したとき、ディレクトリがすでにスタックに含まれていればスタックに追加しない
setopt pushd_ignore_dups

# コマンドのスペルミスを指摘
setopt correct

# cdを入力しなくてもディレクトリ名のみで移動できる
#setopt auto_cd

# 補完候補表示時にビープ音を鳴らさない
setopt nolistbeep

# 候補が多い場合は詰めて表示
setopt list_packed

# コマンドラインの引数でも補完を有効にする（--prefix=/userなど）
setopt magic_equal_subst

# エイリアス設定
alias ll='ls -alG'

# Node.js のバージョン管理（nodebrew）
export PATH=$HOME/.nodebrew/current/bin:$PATH



#### ここからプラグイン

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node
### End of Zinit's installer chunk

# 履歴から補完
zinit light zsh-users/zsh-autosuggestions

# シンタックスハイライト
zinit light zdharma/fast-syntax-highlighting

# Ctrl+r でコマンド履歴を検索
zinit light zdharma/history-search-multi-word

# クローンしたGit作業ディレクトリで、コマンド `git open` を実行するとブラウザでGitHubが開く
zinit light paulirish/git-open

# 移動系強化プラグイン 
# 利用するためには以下をインストールする必要があります。
# Macの場合
# $ brew tap jhawthorn/fzy
# $ brew install fzy ccat
# Linuxの場合
# $ git clone https://github.com/jhawthorn/fzy.git
# $ cd fzy
# $ make && sudo make install
# $ go get -u github.com/jingweno/ccat
zinit light b4b4r07/enhancd

# プロンプトにgitのブランチ状態やステータスを表示してくれる
# gitのバージョンが、v2.11 以上であることが必要
zinit light woefe/git-prompt.zsh
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=") "
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
# WSLの場合はカーソル位置がずれるので変更する
	ZSH_THEME_GIT_PROMPT_PREFIX="["
	ZSH_THEME_GIT_PROMPT_SUFFIX=" ]"
	ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[white]%}"
	ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}%{ %G%}"
	ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[magenta]%}%{x%G%}"
	ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[red]%}%{+%G%}"
	ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[red]%}%{-%G%}"
	ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[green]%}%{+%G%}"
	ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}%{✔%G%}"
fi
PROMPT="%(?.${GREEN}.${YELLOW})% %# %B${RESET}"
SPROMPT="${RED}%{$suggest%} %B %r is correct? [n,y,a,e]:${RESET}%b "
RPROMPT='%B%40<..<%1~ %b$(gitprompt)'
#RPROMPT+='%*'
# 右プロンプトの表示を再就業だけにする
setopt transient_rprompt


# 時間のかかるコマンドを打ったあとに終わったよ！と表示してくれる
zinit light t413/zsh-background-notify

# コマンド処理が終わったあとに処理時間を表示してくれる。
zinit light popstas/zsh-command-time

#### ここまでプラグイン

alias vi='/usr/bin/vim'

