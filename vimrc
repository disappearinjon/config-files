set nocompatible
set nu
syntax on
map K dG
map <c-x> {!}fmt -w 72
map <c-a> 1G!Gfmt -w 72
set textwidth=72	" will override below for Python
set autoindent
set shell=bash

" Manage window splits (Ctrl-W hjkl remapping)
map <silent> <c-k> :wincmd k<CR>
map <silent> <c-j> :wincmd j<CR>
map <silent> <c-h> :wincmd h<CR>
map <silent> <c-l> :wincmd l<CR>

" New vertical window (non-split)
map <silent> <c-e> :vne<CR>

" Auto-install vim-plug package manager
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" vim-plug Plugins
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'vim-syntastic/syntastic'
Plug 'fatih/vim-go'
Plug 'liuchengxu/graphviz.vim'
Plug 'nathanaelkane/vim-indent-guides'
call plug#end()

" NerdTree things
" Next two: open NERDTree automatically if no files specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Open NerdTree when VIM starts on opening a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
" Open NerdTree with Ctrl-n
map <C-n> :NERDTreeToggle<CR>
" Close vim if only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Dotty/Graphviz recommend file extension now .gv instead of .dot
au BufNewFile,BufRead *.gv set filetype=dot

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Below is for graphviz
let g:graphviz_viewer = 'open'
let g:graphviz_output_format = 'svg'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Below is for syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Syntastic configuration for Go
" use goimports for formatting
" let g:go_fmt_command = "goimports"

" turn highlighting on
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" automatically show Go function signatures
let g:go_auto_type_info = 1
set updatetime=100

let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']

let g:syntastic_python_python_exec = '/usr/bin/python3'
let g:syntastic_python_checker = 'pycodestyle'

" Open go doc in vertical window, horizontal, or tab
au Filetype go nnoremap <leader>v :vsp <CR>:exe "GoDef" <CR>
au Filetype go nnoremap <leader>s :sp <CR>:exe "GoDef"<CR>
au Filetype go nnoremap <leader>t :tab split <CR>:exe "GoDef"<CR>

" Status Line configuration
set laststatus=2	"always display
set statusline=%t       "tail of the filename
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=\ %y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
