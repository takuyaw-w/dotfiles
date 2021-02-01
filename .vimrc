" vimのバッファやレジスタ内などで使用する文字コード
set encoding=utf-8
" スクリプトで使われている文字コードを宣言
" vimがスクリプトを処理するとき、scriptencodingで指定した文字コードから
" encodigで指定した文字コードに変換される
scriptencoding utf-8
" 既存のファイルを開くとき、Vimが使用する文字コードを判定する順番
" 先頭か順に試される
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
" シンタックスハイライトを有効にする
syntax enable

filetype plugin indent on

" カーソルラインを表示
set cursorline

" 行番号
set number

" 検索結果をハイライトする
set hlsearch
" 検索時大文字小文字を区別しない
set ignorecase
" 検索時、大文字を入力した場合大文字小文字を区別する
set smartcase

" 文字を入力するたびに、その時点でパターンマッチしたテキストをハイライト
set incsearch

" Undoの永続化
if has('persistent_undo')
	let undo_path = expand('~/.vim/undo')
	" ディレクトリが存在しない場合は作成
	if !isdirectory(undo_path)
		call mkdir(undo_path, 'p')
	endif
	let &undodir = undo_path
	set undofile
endif

" 展開するスペースの個数
set tabstop=4
" タブをスペースに展開
set expandtab

" インデントを考慮して改行
set smartindent
" インデントのスペースの数
set shiftwidth=4

" クリップボードの同期
set clipboard+=unnamed

set showtabline=2
set laststatus=2

" 矩形選択
set virtualedit=block

" コマンドライン補完
set wildmenu

" CTRL + s 保存
nnoremap <C-s> :w<CR>

" プレフィックスキー
let g:mapleader = "\<Space>"

" カーソル下の単語をあと置換後の文字を入力するだけの状態にする
nnoremap <Leader>re :%s;\<<C-R><C-W>\>;g<Left><Left>;

" 検索のハイライトを除去
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" vimrcを開く
nnoremap <Leader>. :new ~/.vimrc<CR>

" 行頭、行末の移動
nnoremap H ^
nnoremap L $

" アプリランチャーを実行
nnoremap <silent> <Leader>l :bo term ++close gol -f<CR>

" 段落の移動
nnoremap <C-j> }
nnoremap <C-k> {

" ターミナルを垂直で開く
nnoremap <C-s>\ :vert term ++close

" ターミナルを水平で開く
nnoremap <C-s>- :bo term ++close

" ターミナルを新しいタブページで開く
nnoremap <C-s>^ :tab term ++close

" オペレータ待機モードのマッピング
onoremap 8 i(
onoremap 2 i"
onoremap 7 i'
onoremap @ i`
onoremap [ i[
onoremap { i{

onoremap a8 a(
onoremap a2 a"
onoremap a7 a'
onoremap a@ a`
onoremap a[ a[
onoremap a{ a{

" dein.vim settings {{{
" install dir {{{
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" }}}

" dein installation check {{{
if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . s:dein_repo_dir
endif
" }}}

" begin settings {{{
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    " .toml file
    let s:rc_dir = expand('~/.vim')
    if !isdirectory(s:rc_dir)
        call mkdir(s:rc_dir, 'p')
    endif
    let s:toml = s:rc_dir . '/dein.toml'

    " read toml and cache
    call dein#load_toml(s:toml, {'lazy': 0})

    " end settings
    call dein#end()
    call dein#save_state()
endif
" }}}

" plugin installation check {{{
if dein#check_install()
    call dein#install()
endif
" }}}

" plugin remove check {{{
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
    call map(s:removed_plugins, "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
endif
" }}}

" }}}

set helplang=ja

