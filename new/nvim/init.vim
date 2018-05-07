if &compatible
	set nocompatible
endif
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein/repos/github.com/Shougo/dein.vim')
	call dein#begin('~/.cache/dein')
	call dein#add('Shougo/dein.vim')

	call dein#add('/usr/local/opt/fzf')
	call dein#add('junegunn/fzf.vim')

	call dein#add('fatih/vim-go')

	call dein#add('Shougo/deoplete.nvim')
	call dein#add('zchee/deoplete-go')
	call dein#add('zchee/deoplete-jedi')
	call dein#add('vim-ruby/vim-ruby')
"	call dein#add('mhartington/nvim-typescript')
"	call dein#add('leafgarland/typescript-vim')
"	call dein#add('ianks/vim-tsx')

	call dein#add('davidhalter/jedi-vim')

	call dein#add('hashivim/vim-terraform')
	call dein#add('vim-syntastic/syntastic')
	call dein#add('juliosueiras/vim-terraform-completion')

	call dein#add('tpope/vim-markdown')
	call dein#add('tpope/vim-vinegar')

"	call dein#add('Shougo/neosnippet.vim')
"	call dein#add('Shougo/neosnippet-snippets')

	call dein#add('majutsushi/tagbar')

	call dein#end()
	call dein#save_state()
endif

" Global configs
let g:python_host_prog = $HOME.'/.pyenv/versions/nvim2/bin/python'
let g:python3_host_prog = $HOME.'/.pyenv/versions/nvim/bin/python'

" Deoplete
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.terraform = '[^ *\t"{=$]\w*'
let g:deoplete#enable_at_startup = 1
call deoplete#initialize()

" Terraform
let g:terraform_align = 1
let g:terraform_fmt_on_save = 1

" Syntastic Config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" (Optional)Remove Info(Preview) window
set completeopt-=preview

" (Optional)Hide Info(Preview) window after completions
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" (Optional) Enable terraform plan to be include in filter
let g:syntastic_terraform_tffilter_plan = 1

" (Optional) Default: 0, enable(1)/disable(0) plugin's keymapping
let g:terraform_completion_keys = 1

" (Optional) Default: 1, enable(1)/disable(0) terraform module registry completion
let g:terraform_registry_module_completion = 1

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

" jedi
" I have deoplete-jedi, so disable jedi completions
let g:jedi#completions_enabled = 0
autocmd BufWinEnter '__doc__' setlocal bufhidden=delete

" fzf
let g:fzf_buffers_jump = 1
let g:fzf_commits_log_options = '--graph --color=always'
let g:fzf_commands_expect = 'alt-enter,ctrl-x'
autocmd! FileType fzf
autocmd FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" netrw
let g:netrw_bufsettings = 'nomodifiable nomodified nobuflisted nowrap readonly'
let g:netrw_banner = 0
let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
let g:netrw_altv = 1
"let g:netrw_winsize = 15
"augroup ProjectDrawer
"	autocmd!
"	autocmd VimEnter * :Vexplore
"augroup END

" markdown
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'hcl=tf']

set statusline+=%F

filetype plugin indent on
syntax enable
colorscheme molokai
set clipboard+=unnamedplus

set relativenumber
set number

autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
autocmd FileType yml setlocal shiftwidth=2 tabstop=2
autocmd FileType typescript.jsx setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType typescript setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType js setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType css setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2 expandtab
