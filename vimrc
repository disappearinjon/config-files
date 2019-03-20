set nocompatible
set nu
syntax on
map K dG
map  {!}fmt -w 72
set textwidth=72	" will override below for Python
set autoindent
set shell=bash

" Auto-install vim-plug package manager
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" vim-plug Plugins
call plug#begin('~/.vim/plugged')
Plug 'vim-syntastic/syntastic'
Plug 'fatih/vim-go'
Plug 'liuchengxu/graphviz.vim'
call plug#end()

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

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
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

let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']

" Open go doc in vertical window, horizontal, or tab
au Filetype go nnoremap <leader>v :vsp <CR>:exe "GoDef" <CR>
au Filetype go nnoremap <leader>s :sp <CR>:exe "GoDef"<CR>
au Filetype go nnoremap <leader>t :tab split <CR>:exe "GoDef"<CR>
