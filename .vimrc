set encoding=utf-8
scriptencoding utf-8
" ↑1行目は読み込み時の文字コードの設定
" ↑2行目はVim Script内でマルチバイトを使う場合の設定
" Vim scritptにvimrcも含まれるので、日本語でコメントを書く場合は先頭にこの設定が必要になる

"----------------------------------------------------------
" vim-plug
" :PlugInstall と叩くとプラグインのインストールが始まります。
"----------------------------------------------------------
" vim-plug 自体を自動インストール
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" check the specified plugin is installed
function s:is_plugged(name)
    if exists('g:plugs') && has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name].dir)
        return 1
    else
        return 0
    endif
endfunction


" vim-plugの開始
call plug#begin('~/.vim/plugged')

" インストールするVimプラグインを以下に記述
" カラースキームmolokai
Plug 'tomasr/molokai'
" ステータスラインの表示内容強化
Plug 'itchyny/lightline.vim'
" インデントの可視化
Plug 'Yggdroot/indentLine'
" 末尾の全角半角空白文字を赤くハイライト
Plug 'bronson/vim-trailing-whitespace'
" 構文エラーチェック
Plug 'vim-syntastic/syntastic'

" Vuejs 開発用
Plug 'posva/vim-vue'
" TypeScript 入力補完 定義箇所にジャンプ
Plug 'Quramy/tsuquyomi'

" NERDTreeでディレクトリをツリー表示する
Plug 'scrooloose/nerdtree'
augroup NERDTreeSetting
    autocmd!
    autocmd StdinReadPre * let s:std_in = 1
    if (argc() == 0 || argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in"))
        autocmd vimenter * NERDTreeToggle
    else
        autocmd vimenter * NERDTreeToggle | wincmd p
    endif
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END
" 隠しファイルをデフォルト表示
let NERDTreeShowHidden = 1

" Unite.vim でコードを保管する
" ag をインストールする
" macの場合
" $ brew install ag
" linux の場合
" $ apt-get install software-properties-common # (if required)
" $ apt-add-repository ppa:mizuno-as/silversearcher-ag
" $ apt-get update
" $ apt-get install silversearcher-ag
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200
" unite.vimの設定
" Ctrl-U→Ctrl+Fでファイル一覧を開く
noremap <C-U><C-F> :Unite -buffer-name=file file<CR>
" Ctrl-U→Ctrl+Rでファイルの閲覧履歴を開く
noremap <C-U><C-R> :Unite file_mru buffer<CR>
" 移動したいファイルにカーソルを合わせてをCtrl+iで開く
"au FileType unite nnoremap <silent> <buffer> <expr> <C-i> unite#do_action('split')
au FileType unite nnoremap <silent> <buffer> <expr> <C-i> unite#do_action('preview')
"au FileType unite inoremap <silent> <buffer> <expr> <C-i> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-i> unite#do_action('preview')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q


" git管理されているファイルの場合に、差分がある行に記号を表示してくれる
Plug 'airblade/vim-gitgutter'

" VimからGitを呼べるようにする
" ,bl でBlameを表示、さらに、o を打つとコミット内容まで開く
Plug 'tpope/vim-fugitive'
noremap ,st :Gstatus<CR>
noremap ,df :Gdiff<CR>
noremap ,bl :Gblame<CR>


""" ここから、入力補完にdeopleteを利用する場合
""" Macの場合
""" $ brew install python3
""" $ pip3 install --upgrade neovim
""if has('nvim')
""  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
""else
""  Plug 'Shougo/deoplete.nvim'
""  Plug 'roxma/nvim-yarp'
""  Plug 'roxma/vim-hug-neovim-rpc'
""endif
""let g:deoplete#enable_at_startup = 1
""set completeopt+=noinsert
""" ここまで、入力補完にdeopleteを利用する場合


" タグを自動で閉じる
Plug 'alvan/vim-closetag'
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.erb,*.php,*.vue'


" vim-plugの終了
call plug#end()


"----------------------------------------------------------
" カラースキーム
"----------------------------------------------------------
if s:is_plugged("molokai")
	" コメントを濃い緑にする
	autocmd ColorScheme * highlight Comment ctermfg=22 guifg=#008800
	autocmd ColorScheme * highlight Visual ctermfg=8 guifg=#EEEEEE
    colorscheme molokai " カラースキームにmolokaiを設定する
endif

set t_Co=256 " iTerm2など既に256色環境なら無くても良い
syntax enable " 構文に色を付ける

"----------------------------------------------------------
" 文字
"----------------------------------------------------------
set fileencoding=utf-8 " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
set ambiwidth=double " □や○文字が崩れる問題を解決

"----------------------------------------------------------
" ステータスライン
"----------------------------------------------------------
set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
set ruler " ステータスラインの右側にカーソルの位置を表示する

"----------------------------------------------------------
" コマンドモード
"----------------------------------------------------------
set wildmenu " コマンドモードの補完
set history=5000 " 保存するコマンド履歴の数

"----------------------------------------------------------
" タブ・インデント
"----------------------------------------------------------
set expandtab " タブ入力を複数の空白入力に置き換える
set tabstop=4 " 画面上でタブ文字が占める幅
set softtabstop=4 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent " 改行時に前の行のインデントを継続する
set smartindent " 改行時に前の行の構文をチェックし次の行のインデントを増減する
set shiftwidth=4 " smartindentで増減する幅
set noautoindent " vim pasteのインテンドズレ防止
"set paste " コピペした際のインデントのズレを防止 (但しこれがあるとdeopleteやclosetagなど動かない)

"----------------------------------------------------------
" 文字列検索
"----------------------------------------------------------
set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト

" ESCキー2度押しでハイライトの切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

"----------------------------------------------------------
" カーソル
"----------------------------------------------------------
set number " 行番号を表示
set cursorline " カーソルラインをハイライト

" バックスペースキーの有効化
set backspace=indent,eol,start

" 閉じ括弧を保管する
"Plug 'cohama/lexima.vim'
inoremap { {}<Left><CR><ESC><S-o>
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap [ []<Left>
inoremap ( ()<Left>


