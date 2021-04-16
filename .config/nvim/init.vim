" ==================================== "
" === IN ADDITION TO sensible.vim: === "
" ==================================== "

" Easier split navigations

" Allow mouse usage in normal mode (I use this for scrolling)
set mouse=n

" Switch between buffers w/o writing
set hidden

" Disable highlight-search by default
set nohls

" Show the effects of a ':substitute' incrementally in the current window.
set inccommand=nosplit

" Fold based on indentation
set foldmethod=indent

" Don't auto fold everything when opening a file
set nofoldenable

" More natural split-window positions
set splitbelow
set splitright

" Easier split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

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

" Enable fzf for vim. (If installed on Debian via `apt install fzf`)
" source /usr/share/doc/fzf/examples/fzf.vim

" Enable fzf for vim. (If installed using Homebrew)
" set rtp+=/usr/local/opt/fzf

" Enable fzf for vim. (If installed using git)
" set rtp+=~/.fzf

" Run fzf's `:Buffers` Ex-command using `\b`
nnoremap <leader>b :Buffers<CR>

" Run fzf's `:Lines` Ex-command using `\l`
nnoremap <leader>l :Lines<CR>

" Run fzf's `:Files` Ex-command using `\f`
nnoremap <leader>f :Files<CR>

" == SOFT TAB SETTINGS == "

set tabstop=2     " Set tab width as 2 characters
set shiftwidth=2  " Set shift/indent width as 2 characters
                  " (Some people define tabs differently from shifts/indents)

" set expandtab     " Use spaces to achieve the tab effects above.
