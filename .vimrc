syntax on

set nocompatible

set guifont=Courier\ 14
set ignorecase
set noerrorbells
set number
set expandtab
set tabstop=2 
set shiftwidth=2 
set scrolloff=10
set showbreak= 
set history=5000
set wmw=0
set t_BE=
nmap <silent> <Left> :tabprev<CR>
nmap <silent> <Right> :tabnext<CR>
nmap <silent> <A-Left> :tabprev<CR>
nmap <silent> <A-Right> :tabnext<CR>

set whichwrap+=<,>,h,l,[,]

if has('gui_running')
  set smarttab
  nmap <silent> <A-Up> :wincmd k<CR>
  nmap <silent> <A-Down> :wincmd j<CR>
endif

let s:pattern = '^\(.* \)\([1-9][0-9]*\)$'
let s:minfontsize = 6
let s:maxfontsize = 16
function! AdjustFontSize(amount)
  if has("gui_gtk2") && has("gui_running")
    let fontname = substitute(&guifont, s:pattern, '\1', '')
    let cursize = substitute(&guifont, s:pattern, '\2', '')
    let newsize = cursize + a:amount
    if (newsize >= s:minfontsize) && (newsize <= s:maxfontsize)
      let newfont = fontname . newsize
      let &guifont = newfont
    endif
  else
    echoerr "You need to run the GTK2 version of Vim to use this function."
  endif
endfunction

function! LargerFont()
  call AdjustFontSize(1)
endfunction
command! LargerFont call LargerFont()

function! SmallerFont()
  call AdjustFontSize(-1)
endfunction
command! SmallerFont call SmallerFont()

colorscheme distinguished

set backupdir=~/vim_backups,.
set directory=~/vim_backups,.

let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

set visualbell

"pathogen configuration
silent! execute pathogen#infect()  "silent! keeps vim from complaining 
silent! filetype plugin indent on

"nerdtree config
silent! nmap <silent> <special> <F2> :NERDTreeToggle<RETURN>
silent! nmap <silent> <special> <F3> \ig <RETURN>
silent! let NERDTreeShowHidden=1

" Ctrl-arrows navigate splits
nnoremap <silent> <C-Up>    <C-w>k
nnoremap <silent> <C-Down>  <C-w>j
nnoremap <silent> <C-Left>  <C-w>h
nnoremap <silent> <C-Right> <C-w>l
" Ctrl-arrows in PuttySSH terminal:
nnoremap <silent> [A <C-w>k
nnoremap <silent> [B <C-w>j
nnoremap <silent> [D <C-w>h
nnoremap <silent> [C <C-w>l

"Vim indent Guides:
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=242
hi IndentGuidesEven ctermbg=236
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size  = 1

if has("autocmd")
  " Restore cursor position
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
endif

" Using ALE now
let g:ale_sign_error = "⚠"
let g:ale_linters = {'perl': ['perlcritic', 'perl'], 'ruby': ['rubocop']}
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_insert_leave = 0

"Remove trailing whitspace from typical programming language files
autocmd BufWritePre *.rb %s/\s\+$//e
autocmd BufWritePre *.py %s/\s\+$//e
" autocmd BufWritePre *.js %s/\s\+$//e
autocmd BufWritePre *.pl %s/\s\+$//e
autocmd BufWritePre *.pm %s/\s\+$//e
autocmd BufWritePre *.haml %s/\s\+$//e
autocmd BufWritePre *.erb %s/\s\+$//e

" Load plugins and setup helptags
packloadall
silent! helptags ALL

