set t_Co=256

" vi is not vim
set nocompatible

" enable fast tty network
set ttyfast

" disable word wrapping
set nowrap

" Appearance
syntax enable
colorscheme Chasing_Logic

" highlight current line
" set cursorline
" highlight CursorLine cterm=none
set nocursorline

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" Always show current position
set ruler

" Enable backspacing properly
set backspace=indent,eol,start

" To avoid slow lines when lines in a file
" are too big, disable syntax color for lines
" longer than 120 characters
set synmaxcol=300

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
imap <F7> <ESC>mzgg=G`z<ESC>a

" Allows to toggle paste with F2
set pastetoggle=<F2>

" This removes the previous search when pressing / again
nnoremap <silent> <leader>/ :nohlsearch<CR>

" Makes search act like search in modern browsers
set incsearch

" Delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
	set formatoptions+=j
endif

" Vim Typo Fixes
command! WQ wq
command! Wq wq
command! Wqa wqa
command! W w
command! Q q

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
set noexpandtab
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Enable line numbers
set number

" Making it so ; works like : for commands.
" Saves typing and eliminates :W style
" typos due to lazy holding shift.
nnoremap ; :

" Enable indenting and deindenting visually using < and >
vnoremap < <gv
vnoremap > >gv

" Split windows in Vim
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Divide windows with leader
nnoremap <Leader>wh :new<cr>
nnoremap <Leader>wv :vnew<cr>
nnoremap <Leader>w= <C-W>=
nnoremap <Leader>wa <C-W>+
nnoremap <Leader>wz <C-W>-
nnoremap <Leader>s :split<cr>

" Iterate between all open splits
nnoremap <Tab> <C-w>w

" Open new split panes to right and bottom
set splitbelow
set splitright

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" ---------- START Vundle VIM Plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'xolox/vim-misc'
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
Plugin 'airblade/vim-gitgutter'
Plugin 'fatih/vim-go'
Plugin 'vim-ruby/vim-ruby'
Plugin 'godlygeek/tabular'
Plugin 'mbbill/undotree'
Plugin 'tpope/vim-endwise'
Plugin 'wavded/vim-stylus'
Plugin 'plasticscafe/vim-stylus-autocompile'
Plugin 'ekalinin/dockerfile.vim'
Plugin 'henrik/vim-indexed-search'
Plugin 't9md/vim-chef'
Plugin 'xolox/vim-easytags'
Plugin 'ryanoasis/vim-devicons'
Plugin 'hashivim/vim-terraform'
Plugin 'hashivim/vim-packer'
Plugin 'hashivim/vim-vaultproject'
Plugin 'hashivim/vim-consul'
Plugin 'avakhov/vim-yaml'
Plugin 'chase/vim-ansible-yaml'
Plugin 'elzr/vim-json'
Plugin 'sdanielf/vim-stdtabs'
Plugin 'sickill/vim-pasta'
Plugin 'tpope/vim-surround'
Plugin 'mattn/gist-vim'
Plugin 'mattn/webapi-vim'
Plugin 'sheerun/vim-polyglot'
Plugin 'Valloric/MatchTagAlways'
Plugin 'tpope/vim-obsession'
Plugin 'dhruvasagar/vim-prosession'
Plugin 'pearofducks/ansible-vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'rking/ag.vim'
Plugin 'joukevandermaas/vim-ember-hbs'
Plugin 'plasticboy/vim-markdown'
Plugin 'matze/vim-move'
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

" Close preview buffer with Leader-z
nmap <Leader>z :pc!<CR>
vmap <Leader>z :pc!<CR>

" Indent guides
let g:indentLine_color_term=238
let g:indentLine_char = '┆'

" Enable easytags on save
let g:easytags_events = ['BufWritePost']
let g:easytags_async = 1

" Enable closetags
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.hbs"

" Conceal Level for vim-json
let g:vim_json_syntax_conceal = 0

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
nnoremap <Leader>e <Plug>(go-rename)

" Gists are private by default
let g:gist_post_private = 1

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

" Fixing certain file types
au FileType yaml setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2
au FileType javascript setlocal autoindent expandtab tabstop=4 softtabstop=0 shiftwidth=4 smarttab
au FileType handlebars setlocal autoindent expandtab tabstop=4 softtabstop=0 shiftwidth=4 smarttab
au FileType stylus setlocal autoindent noexpandtab tabstop=2 softtabstop=0 shiftwidth=2 smarttab

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
let g:NERDCompactSexyComs = 0
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
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#fnametruncate = 16
let g:airline#extensions#tabline#fnamecollapse = 1
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
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>= <Plug>AirlineSelectNextTab

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

" Vim-move settings
let g:move_key_modifier = 'C'

" CtrlP settings
nnoremap <Leader>o :CtrlPMRUFiles<CR>
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_dont_split = 'NERD'
let g:ctrlp_prompt_mappings = {
			\ 'AcceptSelection("t")': ['<cr>'],
			\ }
let g:ctrlp_abbrev = {
			\ 'gmode': 'i',
			\ 'abbrevs': [
			\ {
			\ 'pattern': ' ',
			\ 'expanded': '',
			\ 'mode': 'pfrz',
			\ },
			\ ]
			\ }
let g:ctrlp_max_files = 200000
" let g:ctrlp_custom_ignore = '\v[\/](node_modules|vendor|git)|(\.(swp|ico|git|svn))$'
let g:ctrlp_show_hidden = 1

" Enable Emmet in different modes, line visual or insert
" use it by pressing CTRL+y+, (control, letter y, comma)
let g:user_emmet_mode='a'

" :call emmet#expandAbbr(3,"")
inoremap <C-e> <Esc>:call emmet#expandAbbr(3, "")<cr>i

" Terraform format on save
let g:terraform_fmt_on_save=1
au BufRead,BufNewFile *.tf setlocal filetype=terraform tabstop=2 softtabstop=2 shiftwidth=2
au BufRead,BufNewFile *.tfvars setlocal filetype=terraform tabstop=2 softtabstop=2 shiftwidth=2

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

" These are to cancel the default behavior of d, D, c, C
" to put the text they delete in the default register.
" Note that this means e.g. "ad won't copy the text into
" register a anymore.  You have to explicitly yank it.
nnoremap d "_d
vnoremap d "_d
nnoremap D "_D
vnoremap D "_D
nnoremap c "_c
vnoremap c "_c
nnoremap C "_C
vnoremap C "_C

" Vim folding
if has("folding")
	set foldenable        " enable folding
	set foldmethod=syntax " fold based on syntax highlighting
	set foldlevelstart=99 " start editing with all folds open

	" toggle folds
	nnoremap <Space> za
	vnoremap <Space> za

	set foldtext=FoldText()
	function! FoldText()
		let l:lpadding = &fdc
		redir => l:signs
		execute 'silent sign place buffer='.bufnr('%')
		redir End
		let l:lpadding += l:signs =~ 'id=' ? 2 : 0

		if exists("+relativenumber")
			if (&number)
				let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
			elseif (&relativenumber)
				let l:lpadding += max([&numberwidth, strlen(v:foldstart - line('w0')), strlen(line('w$') - v:foldstart), strlen(v:foldstart)]) + 1
			endif
		else
			if (&number)
				let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
			endif
		endif

		" expand tabs
		let l:start = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
		let l:end = substitute(substitute(getline(v:foldend), '\t', repeat(' ', &tabstop), 'g'), '^\s*', '', 'g')

		let l:info = ' (' . (v:foldend - v:foldstart) . ')'
		let l:infolen = strlen(substitute(l:info, '.', 'x', 'g'))
		let l:width = winwidth(0) - l:lpadding - l:infolen

		let l:separator = ' … '
		let l:separatorlen = strlen(substitute(l:separator, '.', 'x', 'g'))
		let l:start = strpart(l:start , 0, l:width - strlen(substitute(l:end, '.', 'x', 'g')) - l:separatorlen)
		let l:text = l:start . ' … ' . l:end

		return l:text . repeat(' ', l:width - strlen(substitute(l:text, ".", "x", "g"))) . l:info
	endfunction
endif

" Escape special characters in a string for exact matching.
" This is useful to copying strings from the file to the search tool
" Based on this - http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
function! EscapeString (string)
	let string = a:string
	" Escape regex characters
	let string = escape(string, '^$.*\/~[]')
	" Escape the line endings
	let string = substitute(string, '\n', '\\n', 'g')
	return string
endfunction

" Replace current word below cursor
xnoremap <leader>r :<C-u>%s/<C-r>=GetVisualSelection()<CR>/

function! GetVisualSelection()
	let old_reg = @v
	normal! gv"vy
	let raw_search = @v
	let @v = old_reg
	return EscapeString(raw_search)
endfunction

" Perform replacements with \x and \X
nnoremap <leader>x *``cgn
nnoremap <leader>X #``cgN

" Find visually selected text
vnoremap <expr> // 'y/\V'.escape(@",'\').'<CR>'

" Setup matching tag plugin
let g:mta_use_matchparen_group = 0
let g:mta_set_default_matchtag_color = 0
highlight MatchTag ctermfg=black ctermbg=lightgreen guifg=black guibg=lightgreen

" More thoroughful detection of ansible
function! s:isAnsible()
	let filepath = expand("%:p")
	let filename = expand("%:t")
	if filepath =~ '\v/(tasks|roles|handlers|playbooks)/.*\.ya?ml$' | return 1 | en
	if filepath =~ '\v/(group|host)_vars/' | return 1 | en
	if filename =~ '\v(playbook|site|main|local)\.ya?ml$' | return 1 | en

	let shebang = getline(1)
	if shebang =~# '^#!.*/bin/env\s\+ansible-playbook\>' | return 1 | en
	if shebang =~# '^#!.*/bin/ansible-playbook\>' | return 1 | en

	return 0
endfunction

" More thoroughful detection of ansible host files
function! s:isAnsibleHosts()
	let filepath = expand("%:p")
	let filename = expand("%:t")
	if filename =~ '\v(hosts)$' | return 1 | en
endfunction

autocmd BufNewFile,BufRead * if s:isAnsible() | set ft=ansible | en
autocmd BufNewFile,BufRead * if s:isAnsibleHosts() | set ft=ansible_hosts | en
autocmd BufNewFile,BufRead *.j2 set ft=ansible_template

" Fix tab indentation in yaml files
autocmd FileType ansible setlocal expandtab
autocmd BufWritePre *.yaml :retab

" Set format for specific file types
autocmd BufNewFile,BufRead *.hbs set ft=handlebars
autocmd BufNewFile,BufRead *.styl set filetype=stylus
autocmd BufNewFile,BufRead *.stylus set filetype=stylus

" Save temporary/backup files not in the local directory, but in your ~/.vim
" directory, to keep them out of git repos.
" But first mkdir backup, swap, and undo first to make this work
call system('mkdir ~/.vim')
call system('mkdir ~/.vim/backup')
call system('mkdir ~/.vim/swap')
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
	call system('mkdir ~/.vim/undo')
	set undodir=~/.vim/undo//
	set undofile
	set undolevels=1000
	set undoreload=10000
endif

" Vim Markdown conceal
let g:vim_markdown_conceal = 0

" Return indent (all whitespace at start of a line), converted from
" tabs to spaces if what = 1, or from spaces to tabs otherwise.
" When converting to tabs, result has no redundant spaces.
function! Indenting(indent, what, cols)
	let spccol = repeat(' ', a:cols)
	let result = substitute(a:indent, spccol, '\t', 'g')
	let result = substitute(result, ' \+\ze\t', '', 'g')
	if a:what == 1
		let result = substitute(result, '\t', spccol, 'g')
	endif
	return result
endfunction

" Convert whitespace used for indenting (before first non-whitespace).
" what = 0 (convert spaces to tabs), or 1 (convert tabs to spaces).
" cols = string with number of columns per tab, or empty to use 'tabstop'.
" The cursor position is restored, but the cursor will be in a different
" column when the number of characters in the indent of the line is changed.
function! IndentConvert(line1, line2, what, cols)
	let savepos = getpos('.')
	let cols = empty(a:cols) ? &tabstop : a:cols
	execute a:line1 . ',' . a:line2 . 's/^\s\+/\=Indenting(submatch(0), a:what, cols)/e'
	call histdel('search', -1)
	call setpos('.', savepos)
endfunction
command! -nargs=? -range=% Space2Tab call IndentConvert(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space call IndentConvert(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent call IndentConvert(<line1>,<line2>,&et,<q-args>)
