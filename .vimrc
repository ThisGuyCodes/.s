" ------------------------------------------------------------------------------
" General Settings
" ------------------------------------------------------------------------------

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

" ------------------------------------------------------------------------------
" Search and Replace
" ------------------------------------------------------------------------------

set incsearch                     " Show partial matches as search is entered.
set hlsearch                      " Highlight search patterns.
set ignorecase                    " Enable case insensitive search.
set smartcase                     " Disable case insensitivity if mixed case.
set wrapscan                      " Wrap to top of buffer when searching.
"set gdefault                      " Make search and replace global by default.

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
set colorcolumn=80
highlight ColorColumn ctermbg=DarkBlue ctermfg=DarkRed

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

" show title in console title bar
set title

" allow for forced write
cmap w!! w !sudo tee %

" ------------------------------------------------------------------------------
" Whitespace
" ------------------------------------------------------------------------------

set autoindent
set smarttab
set shiftwidth=4
set tabstop=4
"set expandtab
set shiftround

" ------------------------------------------------------------------------------
" Type-specific whitespace
" ------------------------------------------------------------------------------

autocmd FileType html set tabstop=4 shiftwidth=4 noexpandtab syntax=htmljinja
autocmd FileType python set shiftwidth=4 tabstop=4 expandtab
autocmd FileType css set shiftwidth=4 tabstop=4 expandtab
autocmd FileType coffee set shiftwidth=2 tabstop=2 expandtab
autocmd FileType go set tabstop=4 noexpandtab
autocmd FileType yaml set shiftwidth=2 tabstop=2 expandtab
autocmd FileType yml set shiftwidth=2 tabstop=2 expandtab

" ------------------------------------------------------------------------------
" Other stuff
" ------------------------------------------------------------------------------

" smart tab completion for files in status
set wildmode=longest:full
set wildmenu

" set proper filetype for go files on open
autocmd BufRead,BufNewFile *.go set filetype=go
au BufNewFile,BufRead *.yaml,*.yml setf yaml
