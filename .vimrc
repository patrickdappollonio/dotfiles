set t_Co=256

" vi is not vim
set nocompatible

" Appearance
syntax enable
colorscheme Chasing_Logic

" highlight current line
set cursorline
highlight CursorLine cterm=none

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" Always show current position
set ruler

" When searching try to be smart about cases
set smartcase

" Highlight search results and allow
" highlighting back and forth with F12 (toggle)
set hlsearch
map  <F12> :set hls!<CR>
imap <F12> <ESC>:set hls!<CR>a
vmap <F12> <ESC>:set hls!<CR>gv

" This removes the previous search when pressing / again
nmap <silent> <leader>/ :nohlsearch<CR>

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

" Making it so ; works like : for commands.
" Saves typing and eliminates :W style
" typos due to lazy holding shift.
nnoremap ; :

" Easier moving in tabs and windows
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-L> <C-W>l<C-W>_
map <C-H> <C-W>h<C-W>_
map <C-K> <C-W>k<C-W>_

" Enable Pathogen
call pathogen#infect()

" Vim-Go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
:inoremap <C-Space> <C-x><C-o>

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
let NERDTreeQuitOnOpen = 1
let NERDTreeShowHidden = 1
autocmd StdinReadPre * let s:std_in = 1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Better-whitespace remove empty spaces on save
autocmd BufWritePre * StripWhitespace

" Airline Setup
set laststatus=2
set ttimeoutlen=50
let g:airline_theme='luna'
let g:airline_powerline_fonts = 1

" Enable tabs to use Airline
let g:airline#extensions#tabline#enabled = 1

" enable Airline symbols
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" Proper unicode symbols for Airline
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''


" CtrlP settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" CTRL+u won't screw my code
noremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
