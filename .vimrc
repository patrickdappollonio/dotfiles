set t_Co=256

colorscheme molokai

syntax enable
filetype plugin on
set number

" Enable Pathogen
call pathogen#infect()

" Vim-Go
let g:go_disable_autoinstall = 0
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1  
let g:go_highlight_structs = 1  
let g:go_highlight_operators = 1  
let g:go_highlight_build_constraints = 1

" Neocomplete
let g:neocomplete#enable_at_startup = 1

" NERDtree
map <C-n> :NERDTreeToggle<CR>
