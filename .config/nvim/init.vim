set wildmenu
set wildmode=longest,list,full
set wrapscan
set ignorecase
set smartcase
set incsearch
set hlsearch
set autoread
set noswapfile
set hidden
set number
set clipboard&
set clipboard^=unnamedplus,unnamed
set backspace=indent,eol,start
set formatoptions+=m
set tabstop=2
set shiftwidth=2
set softtabstop=0
set expandtab
set list
set listchars=tab:»-,space:·
set history=10000
set display=lastline
set showmatch
set matchtime=1
set showcmd
" set relativenumber
set wrap
set notitle
set completeopt=menuone,noinsert
set autoindent
set smartindent

let g:mapleader = "\<Space>"
" space + w = save file
nnoremap <Leader>w :w<CR>
nnoremap <Leader>re :%s;\<<C-R><C-W>\>;g<Left><Left>;
nnoremap <Esc><Esc> :nohlsearch<CR>
inoremap <silent> jj <ESC>
inoremap <expr><CR> pumvisible() ? "<C-y>" : "<CR>"
inoremap <expr><C-n> pumvisible() ? "<Down>" : "<C-n>"
inoremap <expr><C-p> pumvisible() ? "<Up>" : "<C-p>"

" Split window
nmap ss :split<Return><C-w>w
nmap sv :vsplit<Return><C-w>w
" Move window
map sh <C-w>h
map sk <C-w>k
map sj <C-w>j
map sl <C-w>l
" Switch tab
nmap <S-Tab> :tabprev<Return>
nmap <Tab> :tabnext<Return>
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
  let s:rc_dir = expand('~/.config/nvim/plugin')
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

