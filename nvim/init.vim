" General configuration settings
syntax on
set t_Co=256 					" Enable 256-mode
set nowrap						" Disable word wrapping and line wrapping
set autoread					" Reload file if it has changed on disk
set ruler						" Shows position info at the bottom right
set display+=lastline			" Show as much data from the last line of the file, instead of @ symbol
set scrolloff=4					" When scrolling through text, show 4 lines below the cursor line
set smartcase					" If searching with upper case letters, then make the search sensitive
set hlsearch					" Highlights the search term (down below we can disable highlight with <F8>
set incsearch					" Show search hits while typing it
set ignorecase					" Ignore case sensitivity in searches, unless you use case sensitive search
set wildmenu					" On the command bar, when typing a command, autocomplete shows a list
set splitbelow					" When creating a horizontal split buffer, the new buffer shows below
set splitright					" When creating a vertical split buffer, the new buffer shows to the right
set number						" Show line numbers
set laststatus=2				" Show status bar on all opened files
set showtabline=2				" Also show tablines (currently opened tabs at the top)
set backspace=indent,eol,start 	" Makes backspace to behave the same way other editors do
set confirm						" Confirm on exit

" Emulate set pastetoggle=<F2>
nnoremap <silent> <f2> :set paste!<cr>
inoremap <silent> <f2> <esc>:set paste!<cr>i

" App-wide tabulation settings
set tabstop=4 shiftwidth=4 autoindent smartindent

" Enable to use semicolon to quickly launch
" commands, rather than pressing shift on every
" action.
nnoremap ; :

" Fix typo when exiting if the command
" was submitted with uppercase letters
command! WQ wq
command! Wq wq
command! Wqa wqa
command! W w
command! Q q

" Reindent a file using F7
noremap <F7> mzgg=G`z
inoremap <F7> <ESC>mzgg=G`z<ESC>a

" Toggle higlhighting current word with F8
" (requires hlsearch to be enabled)
noremap  <F8> :let @/=""<cr>:<backspace>
inoremap <F8> <ESC>:let @/=""<cr>:<backspace>a
vnoremap <F8> <ESC>:let @/=""<cr>:<backspace>gv

" When navigating lines, make jk move between visual
" lines, not just lines
nnoremap k gk
nnoremap j gj
nnoremap gk k
nnoremap gj j
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk

" When indenting and deindenting lines, don't deselect
" them after the action
vnoremap < <gv
vnoremap > >gv

" Easy buffer splitting and handling:
" \wh - splits horizontally
" \wv - splits vertically
" \w= - makes all splits evenly sized
" \wa - increase size of split
" \wz - decrease size of split
nnoremap <Leader>wh :<C-u>new<cr>
nnoremap <Leader>wv :<C-u>vnew<cr>
nnoremap <Leader>w= <C-W>=
nnoremap <Leader>wa <C-W>+
nnoremap <Leader>wz <C-W>-

" Easy buffer iteration than CTRL+w+w
nnoremap <Tab> <C-w>w

" When preview buffer splits are displayed, use
" \z to hide them.
nnoremap <Leader>z :<C-u>pc!<CR>
vnoremap <Leader>z :<C-u>pc!<CR>

" Enable updating Neovim settings on save
augroup UpdateVimOnSave
	autocmd!
	autocmd bufwritepost init.vim source $MYVIMRC
augroup END

" Properly indent and configure certain files
augroup IndentConfigs
	autocmd!
	autocmd FileType yaml,yml setlocal ts=2 sts=2 sw=2 expandtab
	autocmd FileType tf,tfvars setlocal ts=2 sts=2 sw=2 expandtab
	autocmd FileType js setlocal ts=2 sts=2 sw=2 expandtab
	autocmd FileType vue setlocal ts=2 sts=2 sw=2 expandtab
	autocmd FileType markdown setlocal wrap linebreak nolist
augroup END

" Quick function to use Q to intelligently close buffers or windows if shown.
" This function reads if the current place is a buffer split or a full window
" and on either case, it'll close them.
function! CloseIntelligently() abort
	let nbuffs = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))
	if matchstr(expand("%"), 'NERD') == 'NERD'
		wincmd c
		return
	endif
	if nbuffs > 1
		wincmd c
	else
		bdelete
	endif
endfunction
nnoremap <silent> Q :<C-u>call CloseIntelligently()<CR>

" Changes how some registers work in order to copy/paste code
" and other elements. This basically deletes the common behavior
" of the " register.
nnoremap d "_d
vnoremap d "_d
nnoremap D "_D
vnoremap D "_D
nnoremap c "_c
vnoremap c "_c
nnoremap C "_C
vnoremap C "_C

" ===========================================================
"                    VIM PLUGIN SETTINGS
" ===========================================================

" Set the runtime path to include Vundle and initialize.
" All plugins will be installed in ~/.config/nvim-plug
call plug#begin('~/.config/nvim-plug')

" Themes
Plug 'mhartington/oceanic-next'

" Generic plugins for any language, makes Vim life easier
Plug 'vim-airline/vim-airline' 																" Airline is a great plugin to show better information in Vim status bar
Plug 'vim-airline/vim-airline-themes'														" Themes for Airline
Plug 'ntpeters/vim-better-whitespace'														" Great plugin to delete whitespaces
Plug 'jiangmiao/auto-pairs'																	" Auto close pairs: when adding an opening bracket, this will add a closing one
Plug 'kien/ctrlp.vim'																		" Make vim behave a bit more like VSCode or Sublime Text
Plug 'preservim/nerdtree'																	" NERDTree, a tree explorer for Vim
Plug 'preservim/nerdcommenter'																" Easy commenting of lines and blocks
Plug 'airblade/vim-gitgutter'																" Show Git file changes in the gutter

" Add autocompletions
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Add vsnip plugin for autocompletion
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" Configure language servers
Plug 'hrsh7th/nvim-cmp'
Plug 'prabirshrestha/vim-lsp'
Plug 'dmitmel/cmp-vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'zbirenbaum/copilot-cmp'

" Specific plugins
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }
Plug 'ray-x/go.nvim'

" Language-specific plugins
Plug 'fatih/vim-go'                        	" Go development plugin with support for Language Server
Plug 'mattn/emmet-vim' 						" Emmet autocompletion on Vim (with CTRL+e, as configured below)
Plug 'alvan/vim-closetag'					" Adds a close tag automatically upon completion
Plug 'ekalinin/dockerfile.vim'				" Handle Dockerfiles
Plug 'hashivim/vim-terraform'				" Handle Terraform resources
Plug 'stephpy/vim-yaml'						" Handle YAML resources
Plug 'Einenlum/yaml-revealer'				" Adds a breadcrumb navigation to YAML files
Plug 'sheerun/vim-polyglot'					" Support for a plethora of Languages
Plug 'itspriddle/vim-shellcheck'			" Support for shellcheck

" Other plugins that must be loaded last
Plug 'ryanoasis/vim-devicons'					" Dev icons for multiple plugins
Plug 'nvim-tree/nvim-web-devicons'              " Dev icons for other plugins
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'	" Dev icon colors for Neovim

" Replacing GitHub Copilot with this custom plugin
Plug 'zbirenbaum/copilot.lua'

" Wrap-up vundle plugins
call plug#end()

" Autodetect file type being handled
" WARNING: This line must go after all the plugins are loaded
" so if plugins configure custom filetypes, these can be loaded
" here.
filetype plugin indent on

" Configure terminal GUI colors
if (has("termguicolors"))
	set termguicolors
endif

" Enable colorscheme
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
colorscheme OceanicNext
hi Normal guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE

" ===========================================================
"                  PLUGIN-RELATED SETTINGS
" ===========================================================

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Toggle line numbers, git gutter and indent lines
function! ToggleVisuals() abort
	set number!
	:GitGutterToggle
endfunc
nnoremap <C-g> :<C-u>call ToggleVisuals()<cr>

" ntpeters/vim-better-whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

" nvim-telecope/telescope.nvim
nnoremap <C-f> :<C-u>Telescope live_grep prompt_prefix=🔍 <CR>

" kien/ctrlp.vim
let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_dont_split = 'NERD'

" mattn/emmet-vim
let g:user_emmet_install_global = 0
augroup EmmetInstall
	autocmd!
	autocmd FileType html,css EmmetInstall
augroup END
inoremap <C-e> <Esc>:call emmet#expandAbbr(3, "")<cr>i

" vim-airline/vim-airline
let g:airline_theme = 'oceanicnext'
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline_left_sep = '»'
let g:airline_left_sep = ''
let g:airline_right_sep = '«'
let g:airline_right_sep = ''

" vim-airline/vim-airline tab switching
nmap <Leader>1 <Plug>AirlineSelectTab1
nmap <Leader>2 <Plug>AirlineSelectTab2
nmap <Leader>3 <Plug>AirlineSelectTab3
nmap <Leader>4 <Plug>AirlineSelectTab4
nmap <Leader>5 <Plug>AirlineSelectTab5
nmap <Leader>6 <Plug>AirlineSelectTab6
nmap <Leader>7 <Plug>AirlineSelectTab7
nmap <Leader>8 <Plug>AirlineSelectTab8
nmap <Leader>9 <Plug>AirlineSelectTab9
nmap <Leader>- <Plug>AirlineSelectPrevTab
nmap <Leader>= <Plug>AirlineSelectNextTab

" preservim/nerdtree
noremap <C-n> :<C-u>NERDTreeToggle<CR>
let NERDTreeShowHidden = 1
let NERDTreeQuitOnOpen = 0
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeWinSize = 40

augroup NerdtreeDetect
	autocmd!
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

" Start NERDTree when Vim starts with a directory argument.
augroup OpenDrawerWhenNerdTreeOpensWithFolder
	autocmd!
	autocmd StdinReadPre * let s:std_in=1
	autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    	\ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
augroup END

" preservim/nerdcommenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 0
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

" fatih/vim-go
let g:go_gopls_enabled = 0
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_space_tab_error = 1
let g:go_play_open_browser = 0
let g:go_gorename_prefill = 0
let g:go_auto_sameids = 0
let g:go_fmt_command = "gofumpt"
let g:go_metalinter_autosave_enabled = ['vet', 'golint']
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']

" alvan/vim-closetag
let g:closetag_filetypes = 'html,xhtml,phtml,vue,handlebars,gohtmltmpl'

" iamcco/markdown-preview.nvim
let g:mkdp_echo_preview_url = 1
let g:mkdp_open_to_the_world = 1

" ===========================================================
"                    LUA PLUGIN SETTINGS
" ===========================================================
lua <<EOL
	local kind_icons = {
		Text = "",
		Method = "m",
		Function = "",
		Constructor = "",
		Field = "",
		Variable = "",
		Class = "",
		Interface = "",
		Module = "",
		Property = "",
		Unit = "",
		Value = "",
		Enum = "",
		Keyword = "",
		Snippet = "",
		Color = "",
		File = "",
		Reference = "",
		Folder = "",
		EnumMember = "",
		Constant = "",
		Struct = "",
		Event = "",
		Operator = "",
		TypeParameter = "",
		Copilot = "",
	}

	-- Copilot configuration
	require('copilot').setup({
	  panel = {
		enabled = false,
	  },
	  suggestion = {
			enabled = false,
	  },
	  filetypes = {
		gitcommit = false,
		gitrebase = false,
		hgcommit = false,
		svn = false,
		cvs = false,
		["."] = false,
	  },
	  copilot_node_command = 'node', -- Node.js version must be > 18.x
	  server_opts_overrides = {},
	})

	-- Copilot completion
	require("copilot_cmp").setup()

	-- Set up nvim-cmp.
	local cmp = require'cmp'
	cmp.setup({
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
			end,
		},

		mapping = cmp.mapping.preset.insert({
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.abort(),
			['<CR>'] = cmp.mapping.confirm({ select = true }),
		}),

		sources = cmp.config.sources({
			{ name = 'copilot' },
			{ name = 'nvim_lsp' },
			{ name = 'vsnip' },
			{ name = 'vim_lsp' },
			{ name = 'buffer' },
		}),

		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				-- kind icons
				vim_item.kind = string.format("%s", kind_icons[vim_item.kind])

				vim_item.menu = ({
					nvim_lsp = "[LSP]",
					buffer = "[Buffer]",
					path = "[Path]",
					copilot = "[Copilot]",
					vsnip = "[VSnip]",
					vim_lsp = "[VimLSP]",
					copilot = "[Copilot]",
				})[entry.source.name]
				return vim_item
			end,
		},

		confirm_opts = {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		},

		window = {
			completion = {
				border = "rounded",
				winhighlight = "Normal:CmpNormal",
			},
			documentation = {
				border = "rounded",
				winhighlight = "Normal:CmpDocNormal",
			}
		}
	})


	-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline({ '/', '?' }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'buffer' }
		}
	})

	-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'path' }
		}, {
			{ name = 'cmdline' }
		}),
		matching = { disallow_symbol_nonprefix_matching = false }
	})

	-- Set up lspconfig.
	local capabilities = require('cmp_nvim_lsp').default_capabilities()

EOL

