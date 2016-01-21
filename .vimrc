" -----------------------------------------------------------------------------
" Vundle Stuff
" -----------------------------------------------------------------------------
if &compatible
	set nocompatible              " be iMproved, required
endif

" -----------------------------------------------------------------------------
" Modify the path to prefer vim local versions of executables
" -----------------------------------------------------------------------------
let $PATH = $HOME . "/.vim/node_modules/.bin:" . $PATH

if has('lua')
	" {{{ Plugins
	if has('vim_starting')
		" set the runtime path to include Vundle and initialize
		set rtp+=~/.vim/bundle/neobundle.vim/
	endif

	call neobundle#begin(expand('~/.vim/bundle'))

	" let neobundle manage neobundle, required
	NeoBundleFetch 'Shougo/neobundle.vim'

	" -------------------------------------------------------------------------
	" Plugins
	" -------------------------------------------------------------------------
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
	NeoBundle 'Raimondi/delimitMate'
	NeoBundle 'fatih/vim-go'
	NeoBundle 'tpope/vim-fugitive'
	NeoBundle 'junegunn/vim-easy-align'
	NeoBundle 'vim-ruby/vim-ruby'
	NeoBundle 'suan/vim-instant-markdown'

	" All of your Plugins must be added before the following line
	call neobundle#end()         " required
	filetype plugin indent on    " required

	NeoBundleCheck

	" -------------------------------------------------------------------------
	" Plugin Specific Settings
	" -------------------------------------------------------------------------

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
		"" For no inserting <CR> key.
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

	" vim-easy-align
	nmap ga <Plug>(EasyAlign)
	xmap ga <Plug>(EasyAlign)

	"}}} Plugins
else
	echomsg "Has('lua') returned false, skipping plugins."
endif
" -----------------------------------------------------------------------------
" General Settings
" -----------------------------------------------------------------------------

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0

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

" Syntax enable
set background=dark
syntax on
colorscheme molokai

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

" Change color of status line when in insert mode
autocmd InsertEnter * highlight StatusLine ctermfg=Green
autocmd InsertLeave * highlight StatusLine ctermfg=LightGray

" Bottom of screen offset
set scrolloff=3

" Strip trailing white space on save
autocmd BufWritePre * :%s/\s\+$//e
" autocmd FileType python,html,coffee autocmd BufWritePre * :%s/\s\+$//e

" Enable backspace to delete past cursor
set backspace=indent,eol,start

" Colorcolumns of 79 (pep8) and 120 (github)
set colorcolumn=79,120
highlight ColorColumn ctermbg=0 ctermfg=DarkRed

" Show command in the lower right hand corner
set showcmd

" Show the cursor position all the time
set ruler

" Set color of gutter column
highlight clear SignColumn

" show title in console title bar
set title

" show matching brackets
set showmatch

" show line numbers
set number
set relativenumber

" Allow for forced write
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
autocmd FileType ruby set shiftwidth=2 tabstop=2 expandtab

" -----------------------------------------------------------------------------
" Other stuff
" -----------------------------------------------------------------------------

" I don't quite understand this
" http://stackoverflow.com/questions/102384/using-vims-tabs-like-buffers
set hidden

" Because the other wrapping is silly
set linebreak

" Smart tab completion for files in status
set wildmode=longest:full
set wildmenu

" Set proper filetype for go files on open
augroup go_files
	autocmd BufRead,BufNewFile *.go set filetype=go
	autocmd BufNewFile,BufRead *.yaml,*.yml setf yaml
augroup END

" Folding
set foldmethod=marker
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" Trim trailing whitespace
augroup trim_whitespace
	autocmd BufWritePre * :%s/\s\+$//e
augroup END

" Grepification
nnoremap gr :silent lgrep! <cword> *<CR>\| :redraw!<CR>  \| :lopen 7<CR>
