set t_Co=256

set nocompatible
filetype off
colorscheme Chasing_Logic

" Appearance
syntax enable

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" Always show current position
set ruler

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" Tab management
set tabstop=3
set smarttab
set shiftwidth=3
set expandtab
set autoindent

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Enable line numbers and set them to be dark
set number
highlight LineNr ctermfg=DarkGrey ctermbg=236

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

" Enable a multipurpose tab key, if we're at the
" beginning of a line, then indent, else do autocomplete
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" NERDtree
map <C-n> :NERDTreeToggle<CR>

" Better-whitespace remove empty spaces on save
autocmd BufWritePre * StripWhitespace

" AirlineTheme
set laststatus=2
set ttimeoutlen=50
let g:airline_theme='simple'
