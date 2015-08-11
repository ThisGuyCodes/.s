" -----------------------------------------------------------------------------
" Vundle Stuff
" -----------------------------------------------------------------------------

if has('vim_starting')
  if &compatible
    set nocompatible              " be iMproved, required
  endif
  " set the runtime path to include Vundle and initialize
  set rtp+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

" let neobundle manage neobundle, required
NeoBundleFetch 'Shougo/neobundle.vim'

" -----------------------------------------------------------------------------
" Plugins
" -----------------------------------------------------------------------------
NeoBundle 'Shougo/vimproc.vim', {
			\ 'build' : {
			\     'windows' : 'tools\\update-dll-mingw',
			\     'cygwin' : 'make -f make_cygwin.mak',
			\     'mac' : 'make -f make_mac.mak',
			\     'linux' : 'make',
			\     'unix' : 'gmake',
			\    },
			\ }
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'fatih/vim-go'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'Xuyuanp/nerdtree-git-plugin'

" All of your Plugins must be added before the following line
call neobundle#end()         " required
filetype plugin indent on    " required

NeoBundleCheck

" -----------------------------------------------------------------------------
" General Settings
" -----------------------------------------------------------------------------

" Disable AutoComplPop.
 let g:acp_enableAtStartup = 0
 " Use neocomplete.
 let g:neocomplete#enable_at_startup = 1
 " Use smartcase.
 let g:neocomplete#enable_smart_case = 1
 " Set minimum syntax keyword length.
 let g:neocomplete#sources#syntax#min_keyword_length = 3
 " Plugin key-mappings.
 inoremap <expr><C-g>     neocomplete#undo_completion()
 inoremap <expr><C-l>     neocomplete#complete_common_string()
" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"
" Use the OS clipboard by default
set clipboard=unnamed

" Large undo/history
set undolevels=1000
set history=1000

" Setup undo tree
set undofile
set undodir=/tmp

" Set encoding
set encoding=utf8

syntax on
colorscheme molokai

"syntax enable
set background=dark

" Disable error bells
set noerrorbells
set visualbell
set t_vb=

" -----------------------------------------------------------------------------
" Search and Replace
" -----------------------------------------------------------------------------

set incsearch                     " Show partial matches as search is entered.
set hlsearch                      " Highlight search patterns.
set ignorecase                    " Enable case insensitive search.
set smartcase                     " Disable case insensitivity if mixed case.
set wrapscan                      " Wrap to top of buffer when searching.
"set gdefault                      " Make search and replace global by default

" 256 colors
set t_Co=256

" taller command bar
set cmdheight=2

" always show the statusline
set laststatus=2

" change color of status line when in insert mode
autocmd InsertEnter * highlight StatusLine ctermfg=Green
autocmd InsertLeave * highlight StatusLine ctermfg=LightGray

" bottom of screen offset
set scrolloff=3

" strip trailing white space on save
autocmd BufWritePre * :%s/\s\+$//e
" autocmd FileType python,html,coffee autocmd BufWritePre * :%s/\s\+$//e

" enable backspace to delete past cursor
set backspace=indent,eol,start

" colorcolumn of 80 characters
set colorcolumn=79,120
highlight ColorColumn ctermbg=0 ctermfg=DarkRed

" show command in the lower right hand corner
set showcmd

" show the cursor position all the time
set ruler

" set color of gutter column
highlight clear SignColumn

" show title in console title bar
set title

" show matching brackets
set showmatch

" show line numbers
set number
set relativenumber

" show title in console title bar
set title

" allow for forced write
cmap w!! w !sudo tee %

" -----------------------------------------------------------------------------
" Whitespace
" -----------------------------------------------------------------------------

set autoindent
set smarttab
set shiftwidth=4
set tabstop=4
"set expandtab
set shiftround

" -----------------------------------------------------------------------------
" Type-specific whitespace
" -----------------------------------------------------------------------------

autocmd FileType html set tabstop=4 shiftwidth=4 noexpandtab syntax=htmljinja
autocmd FileType python set shiftwidth=4 tabstop=4 expandtab
autocmd FileType css set shiftwidth=4 tabstop=4 expandtab
autocmd FileType coffee set shiftwidth=2 tabstop=2 expandtab
autocmd FileType go set tabstop=4 noexpandtab
autocmd FileType yaml set shiftwidth=2 tabstop=2 expandtab
autocmd FileType yml set shiftwidth=2 tabstop=2 expandtab

" -----------------------------------------------------------------------------
" Other stuff
" -----------------------------------------------------------------------------

" I don't quite understand this
" http://stackoverflow.com/questions/102384/using-vims-tabs-like-buffers
set hidden

" Because the other wrapping is silly
set linebreak

" smart tab completion for files in status
set wildmode=longest:full
set wildmenu

" set proper filetype for go files on open
autocmd BufRead,BufNewFile *.go set filetype=go
autocmd BufNewFile,BufRead *.yaml,*.yml setf yaml

" NERDTree
augroup Nerdtree
  autocmd vimenter * NERDTree
  autocmd VimEnter * wincmd p
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
augroup END
