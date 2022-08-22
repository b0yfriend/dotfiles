" I don't like swapfiles
set noswapfile

" Keep gutter/signcolumn open by default, so LSP's gutter icons
" don't shift text to the right
set signcolumn=yes

" 'updatetime' is also used for CursorHold timing, which LSP
" waits upon before showing the diagnostic floating window for
" the code that the cursor's on. It's typically 4000 (ms), which is
" too long
set updatetime=100

" <Space>, by default, will move the cursor 1 col right
" this prevents that default behavior (which would only
" occur if you don't provide a follow-up key to complete
" the <Space><key> shortcut
nnoremap <Space> <nop>

" Selective shortcuts for window operations
nnoremap <Space>h <C-W>h
nnoremap <Space>H <C-W>H
nnoremap <Space>j <C-W>j
nnoremap <Space>J <C-W>J
nnoremap <Space>k <C-W>k
nnoremap <Space>K <C-W>K
nnoremap <Space>l <C-W>l
nnoremap <Space>L <C-W>L

nnoremap <Space>c <C-W>c
nnoremap <Space>o <C-W>o
nnoremap <Space>T <C-W>T
nnoremap <Space>z <C-W>z

" Selective shortcuts for buffer operations
" Remapping <S-l> overwrites the behavior of ':h L'
nnoremap <silent> <S-l> :bnext<CR>
" Remapping <S-h> overwrites the behavior of ':h H'
nnoremap <silent> <S-h> :bprevious<CR>
nnoremap <Space>d :ls<CR>:bd<Space>
nnoremap <Space>D :bd<CR>
nnoremap <Space>b :ls<CR>:b<Space>
nnoremap <Space>v :ls<CR>:vert sb<Space>
nnoremap <Space>s :ls<CR>:sb<Space>
nnoremap <Space># :b#<CR>

" Omnifunc shortcut / cycle through popupmenu items
inoremap <expr> <Tab> pumvisible() ? '<C-n>' : '<Tab>'
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<C-x><C-o>'

" Netrw settings
nnoremap <silent> <Space>e :Lex 30<CR>
" let g:netrw_keepdir = 0
let g:netrw_liststyle = 3
" setting netrw_dirhistmax = 0 prevents creation of .netrwhist files
let g:netrw_dirhistmax = 0

" Hide dotfiles when starting netrw. You can toggle their visibility
" by pressing 'gh'. See the link below for why this specific regex is used.
" https://vi.stackexchange.com/questions/18650/how-to-make-netrw-start-with-dotfiles-hidden
let ghregex='\(^\|\s\s\)\zs\.\S\+'
let g:netrw_list_hide=ghregex

" Hide netrw banner. You can toggle its visibility by pressing 'I'
let g:netrw_banner = 0

" When 'put'ing text with a visual-selection, you will CHANGE the
" visual-selection's text. The old (changed) text will then appear
" in the unnamed register (:h quotequote), causing subsequent 'put'
" operations to use that vestigial text. This remapping uses the
" blackhole register (:h quote_) as the default register when
" 'put'ing text in visual modes
vnoremap p "_dP

" A single, global statusline
set laststatus=3

" Enforce 1+ line of space between cursor & top/bottom sides of window
set scrolloff=1

" Enforce 5+ columns of space between cursor & left/right sides of window
set sidescrolloff=5

" Allow mouse usage in normal mode (I use this for scrolling)
set mouse=n

" Disable highlight-search by default
set nohls

" Show the effects of a ':substitute' incrementally in the current window.
set inccommand=nosplit

" Fold based on indentation
set foldmethod=indent

" Don't auto fold everything when opening a file
set nofoldenable

" Don't create the shada file (shared data),
" which tracks command histories, marks, etc.
set shada="NONE"

" Don't wrap around when hitting to top/bottom during a search
set nowrapscan

" I don't like wrapping long text
set nowrap

" More natural split-window positions
set splitbelow
set splitright

colorscheme catppuccin
hi StatusLine guifg=#A4B9EF

" True Color support
set termguicolors

" Case-insensitive filenames
set wildignorecase

" Set locale for spell-checking
set spelllang=en_us

" Allow smart code reformatting
set smartindent

" Enable smartcase searching.
" If your search query only contains lowercase letters, it assumes
" case-INsensitive searching.
" If your search query contains some uppercase letters, it assumes
" case-sensitive searching.
set smartcase
set ignorecase

" Assume that all shell scripts are specifically bash scripts.
" Mainly, this fixes syntax highlighting for bash-specific language features.
let g:is_bash=1

" Strip Trailing-Whitespace on save
fun! <SID>StripTrailingWhitespaces()
    if &ft =~ 'diff'  " Manually editing git patches needs trailing whitespace.
      return
    endif
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Prevent comment-continuation onto the next line
" (au FileType is used because several filetype plugins
"  modify 'formatoptions' AFTER this .vimrc is loaded)
augroup Format-Options
    autocmd!
    autocmd BufEnter * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

" Use git grep as grepprg when in a git workspace
function! IsGitWorkTree()
  let l:git=1
  let l:stdout = system("git rev-parse --git-dir 2> /dev/null")
  if l:stdout =~# '\.git'
    let l:git=0
  endif
  return l:git
endfunction

function! SetGrepPrg()
  " keep default grepprg if not inside git dir, otherwise switch to git grep
  if IsGitWorkTree() == 0
    set grepprg=git\ grep\ -n\ $*
  endif
endfunction

augroup startup
  autocmd!
  autocmd VimEnter * call SetGrepPrg()
augroup END

" == SOFT TAB SETTINGS == "

set tabstop=2     " Set tab width as 2 characters
set shiftwidth=2  " Set shift/indent width as 2 characters
                  " (Some people define tabs differently from shifts/indents)

" set expandtab     " Use spaces to achieve the tab effects above.

function IsANoNameEmptyBuffer(bufNum)
	if !buflisted(a:bufNum)
		return 0
	endif

	let hasNoName = empty(bufname(a:bufNum))
	let isntOpenInAWindow = bufwinnr(a:bufNum) < 0
	let linesInBuffer = getbufline(a:bufNum, 1, '$')
	if hasNoName && isntOpenInAWindow && linesInBuffer == [""]
		return 1
	endif

	return 0
endfunction

function! CleanNoNameEmptyBuffers()
		let bufNums = range(1, bufnr('$'))
		let noNameEmptyBufNums = filter(
			\		bufNums,
			\		{_idx, val -> IsANoNameEmptyBuffer(val)}
			\	)
    if !empty(noNameEmptyBufNums)
        exe 'silent bd '.join(noNameEmptyBufNums, ' ')
    endif
endfunction

autocmd BufLeave * :call CleanNoNameEmptyBuffers()

set completeopt=menu,longest

" Default value for 'omnifunc' in case LSP doesn't apply
if has("autocmd") && exists("+omnifunc")
	autocmd Filetype *
				\	if &omnifunc == "" |
				\		setlocal omnifunc=syntaxcomplete#Complete |
				\	endif
endif

lua require('lsp_setup');
lua require('telescope_setup');
lua require('treesitter_setup');
