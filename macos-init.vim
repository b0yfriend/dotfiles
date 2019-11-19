" ==================================== "
" === IN ADDITION TO sensible.vim: === "
" ==================================== "

" Switch between buffers w/o writing
set hidden

" Disable highlight-search by default
set nohls

" Show the effects of a ':substitute' incrementally in the current window.
set inccommand=nosplit

" Fold based on indentation
set foldmethod=indent

" Disable autofolding upon opening a file.
" By default, foldlevel=0, which means that vim will
" autofold everything with 1 level of indentation.
" (0 does not mean fold everything with 0+ level of indentation
" because that would fold everything in the file which is stupid.)
" Therefore, setting foldlevel=99, technically causes vim to relegate the
" autofolding to text with 100 levels of indentation, which functionally
" disables all autofolding upon opening a file. If you have 100 levels
" of indentation, that's a bigger problem in itself.
set foldlevel=99

" Gruvbox Colorscheme
colorscheme gruvbox
set background=dark
let g:gruvbox_guisp_fallback='fg'
let g:gruvbox_improved_warnings=1
let g:gruvbox_sign_column='bg0'

" True Color support
set termguicolors

" Case-insensitive filenames
set wildignorecase

" Set locale for spell-checking
set spelllang=en_us

" Allow smart code reformatting
" Should always be used with 'autoindent'.
" I don't 'set autoindent' here because sensible.vim
" does it for me.
set smartindent

" Enable smartcase searching.
" If your search query only contains lowercase letters, it assumes
" case-insensitive searching.
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

" (By default, <leader> is mapped to \)
set rtp+=~/.fzf

" Run fzf's `:Buffers` Ex-command using `\b`
nnoremap <leader>b :Buffers<CR>

" Run fzf's `:Lines` Ex-command using `\l`
nnoremap <leader>l :Lines<CR>

" Use myc for searching files
set rtp+=/usr/local/share/myc/vim
nnoremap <leader>f :MYC<CR>

" == SOFT TAB SETTINGS == "

set tabstop=2     " Set tab width as 2 characters
set shiftwidth=2  " Set shift/indent width as 2 characters
                  " (Some people define tabs differently from shifts/indents)

set expandtab     " Use spaces to achieve the tab effects above.

" ALE settings
let g:ale_linters = {
\  'javascript': ['flow-language-server']
\}

let g:ale_fixers = {
\  'javascript': ['prettier']
\}

let g:javascript_plugin_flow = 1
let g:ale_fix_on_save = 1

" Use <C-Space> to manually trigger ALE autocompletion
inoremap <silent> <C-Space> <C-\><C-O>:ALEComplete<CR>

set signcolumn=yes
nnoremap gd :ALEGoToDefinition<CR>
nnoremap gh :ALEHover<CR>

" Goyo setings
let g:goyo_width = 100
