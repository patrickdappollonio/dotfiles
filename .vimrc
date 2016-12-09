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

" Enable backspacing properly
set backspace=indent,eol,start

" Fix displaying last line
set display+=lastline

" When searching try to be smart about cases
set smartcase

" Allow to see lines below/above when navigating a file
set scrolloff=3

" Highlight search results and allow
" highlighting back and forth with F8 (toggle)
set hlsearch
map  <F8> :set hls!<CR>
imap <F8> <ESC>:set hls!<CR>a
vmap <F8> <ESC>:set hls!<CR>gv

" Reformat the indentation on a file by pressing <F7>
map <F7> mzgg=G`z

" Allows to toggle paste with F2
set pastetoggle=<F2>

" This removes the previous search when pressing / again
nmap <silent> <leader>/ :nohlsearch<CR>

" Makes search act like search in modern browsers
set incsearch

" allow to copy-paste to other apps, using the selection with "v", "V" or
" similar and Ctrl-y to copy to clipboard, and Ctrl-p to paste from it
nnoremap <C-y> "+y
vnoremap <C-y> "+y
nnoremap <C-e> "+gP
vnoremap <C-e> "+gP

" Make j and k, Up and Down move between visual lines
nnoremap k gk
nnoremap j gj
nnoremap gk k
nnoremap gj j
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk

" enable to open and reload vim settings on save
map <leader>vimrc :tabe $MYVIMRC<cr>
autocmd bufwritepost .vimrc source $MYVIMRC

" CTRL+u won't screw my code
noremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" also warns if you're leaving an unsaved buffer
set confirm

" clean colors when running inside tmux
set t_ut=
" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" Perform case-insensitive search
set ignorecase

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

" Enable indenting and deindenting visually using < and >
vnoremap < <gv
vnoremap > >gv

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" ---------- START Vundle VIM Plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'mattn/emmet-vim'
Plugin 'Shougo/neocomplete.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'mtth/scratch.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'jeetsukumaran/vim-buffergator'
Plugin 'alvan/vim-closetag'
Plugin 'eugen0329/vim-esearch'
Plugin 'airblade/vim-gitgutter'
Plugin 'fatih/vim-go'
Plugin 'vim-ruby/vim-ruby'
Plugin 'godlygeek/tabular'
Plugin 'mbbill/undotree'
Plugin 'tpope/vim-endwise'
Plugin 'wavded/vim-stylus'
Plugin 'ekalinin/dockerfile.vim'
Plugin 'henrik/vim-indexed-search'
Plugin 'yggdroot/indentline'
Plugin 't9md/vim-chef'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
" ---------- END Vundle VIM Plugins

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on

" Tabularize with <Leader>a{=,:}
nmap <Leader>a& :Tabularize /&<CR>
vmap <Leader>a& :Tabularize /&<CR>
nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
nmap <Leader>a=> :Tabularize /=><CR>
vmap <Leader>a=> :Tabularize /=><CR>
nmap <Leader>a: :Tabularize /:<CR>
vmap <Leader>a: :Tabularize /:<CR>
nmap <Leader>a:: :Tabularize /:\zs<CR>
vmap <Leader>a:: :Tabularize /:\zs<CR>
nmap <Leader>a, :Tabularize /,<CR>
vmap <Leader>a, :Tabularize /,<CR>
nmap <Leader>a,, :Tabularize /,\zs<CR>
vmap <Leader>a,, :Tabularize /,\zs<CR>
nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
vmap <Leader>a<Bar> :Tabularize /<Bar><CR>

" Vim color for tab indentation lines
let g:indentLine_color_term = 239
let g:indentLine_char = '┆'

" Enable easytags on save
let g:easytags_events = ['BufWritePost']
let g:easytags_async = 1

" Vim-Go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
" inoremap <C-Space> <C-x><C-o>

" Rename the identifier under the cursor to a new name
nmap <Leader>e <Plug>(go-rename)

" By default the mapping gd is enabled, which opens the target identifier in current buffer.
nmap <Leader>dt <Plug>(go-def-tab)

" Neocomplete
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#auto_completion_start_length = 3
let g:neocomplete#max_list = 8
let g:neocomplete#force_overwrite_completefunc = 1

" Also selects automatically the first option
" let g:neocomplete#enable_auto_select = 1

" Neocomplete keyword pattern
if !exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" ENTER closes the popup and saves indent
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
	return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

" Agressive autocompletion
if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif

" Aggresive autocompletion of the following types
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'

" Buffergator toggle
map <F5> :BuffergatorToggle<CR>

" NERDtree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Make nerdtree looks nice
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeWinSize = 30

" NERDCommenter settings
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

" UndoTree is cool to revert changes! Use it with <Leader>u
nnoremap <Leader>u :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle=1

" Better-whitespace remove empty spaces on save
autocmd BufWritePre * StripWhitespace

" Airline Setup
set laststatus=2
set ttimeoutlen=50
let g:airline_theme='luna'
let g:airline_powerline_fonts = 1

" Enable tabs to use Airline
let g:airline#extensions#tabline#enabled = 1

" allows to switch back and forth with airline buffer
" numbers easily, using \n where n is a number in the buffer
" list
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#fnametruncate = 16
let g:airline#extensions#tabline#fnamecollapse = 2
let g:airline#extensions#tabline#buffer_idx_mode = 1

" map leader (\) and a number from 1 to 9 to select buffers
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

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
let g:ctrlp_dont_split = 'NERD'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_prompt_mappings = {
			\ 'AcceptSelection("t")': ['<cr>'],
			\ }

" enable Emmet in different modes, line visual or insert
" use it by pressing CTRL+y+, (control, letter y, comma)
let g:user_emmet_mode='a'

" this also allows to toggle line numbers when working via ssh
function! NumberToggle()
	set number!
	:GitGutterToggle
endfunc
nnoremap <C-g> :call NumberToggle()<cr>

" Use Q to intelligently close a window
" (if there are multiple windows into the same buffer)
" or kill the buffer entirely if it's the last window looking into that buffer
function! CloseWindowOrKillBuffer()
	let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

	" We should never bdelete a nerd tree
	if matchstr(expand("%"), 'NERD') == 'NERD'
		wincmd c
		return
	endif

	if number_of_windows_to_this_buffer > 1
		wincmd c
	else
		bdelete
	endif
endfunction

nnoremap <silent> Q :call CloseWindowOrKillBuffer()<CR>

" Use w!! to write a file as sudo
cmap w!! w !sudo tee % >/dev/null

