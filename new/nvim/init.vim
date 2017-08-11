if &compatible
	set nocompatible
endif
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein/repos/github.com/Shougo/dein.vim')
	call dein#begin('~/.cache/dein')
	call dein#add('Shougo/dein.vim')

	call dein#add('/usr/local/opt/fzf')
	call dein#add('junegunn/fzf.vim')
	call dein#add('hashivim/vim-terraform')

	call dein#add('fatih/vim-go')

	call dein#add('Shougo/deoplete.nvim')
	call dein#add('Shougo/neco-vim')
	call dein#add('zchee/deoplete-go')
	call dein#add('zchee/deoplete-jedi')
	call dein#add('vim-ruby/vim-ruby')

	call dein#add('Shougo/neosnippet.vim')
	call dein#add('Shougo/neosnippet-snippets')

	call dein#add('majutsushi/tagbar')
	call dein#add('sbdchd/vim-run')

	"call dein#add('slashmili/alchemist.vim')
	call dein#add('elixir-lang/vim-elixir')
	call dein#add('thinca/vim-ref')
	"call dein#add('awetzel/elixir.nvim', {'build': 'yes | ./install.sh'})

	call dein#end()
	call dein#save_state()
endif

" Global configs
let g:python_host_prog = '/Users/thisguy/.pyenv/versions/nvim2/bin/python'
let g:python3_host_prog = '/Users/thisguy/.pyenv/versions/nvim/bin/python'

" Deoplete
let g:deoplete#enable_at_startup = 1

" Terraform
let g:terraform_align = 1
let g:terraform_fmt_on_save = 1

" vim-go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:go_fmt_command = 'goimports'
let g:go_fmt_fail_silently = 1
let g:go_fmt_autosave = 1
let g:go_play_open_browser = 1

filetype plugin indent on
syntax enable
colorscheme molokai
set clipboard+=unnamedplus

set relativenumber
set number

autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
autocmd FileType yml setlocal shiftwidth=2 tabstop=2
