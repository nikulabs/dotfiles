set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Other Plugins
"Plugin 'Valloric/YouCompleteMe'
Plugin 'godlygeek/tabular'
Plugin 'tpope/vim-dispatch'
Plugin 'majutsushi/tagbar'
Plugin 'ericcurtin/CurtineIncSw.vim'
Plugin 'lyuts/vim-rtags'
"Plugin 'tpope/tpope-vim-abolish'
"Launch vim and run :PluginInstall

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

syntax on
let g:load_doxygen_syntax=1
set cinoptions+=(0
set background=dark
set cindent
set confirm "confirms leaving a buffer
set diffopt+=iwhite
set expandtab
set hlsearch
set incsearch
set ignorecase smartcase " Case insensitive searches, unless it's mixed-case
set lazyredraw "< No redraw when executing macros
"set mouse=a
set nowrap
set ruler
set pastetoggle=<F9>
set showmatch           " display the matching (, {, or [
set smartindent
set sw=2
set tabstop=8
set softtabstop=2
set backspace=indent,eol,start
set vb t_vb= "< Screen flash instead of beeps
"set virtualedit=all "< Free cursor
set wildmode=longest:list,full
set wildmenu

" My shortcuts
let mapleader=","
nmap <silent> <leader>w :w <CR>

" mapping for cycling through tabs
map <F2> :tabp<cr>
map <F3> :tabn<cr>

" Replaced by plugin
" mapping for switching between *.h and *.cpp
"map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
map <F4> :call CurtineIncSw()<CR>

" mapping for turning on spell check
map <F5> <Esc>:setlocal spell! spelllang=en_us<CR>

" mapping for adding beginning and end of function comments
" Note: this will not work for C-style functions(Functions must have namespace)
map <F7> :Dox<return>kk=%%jh=%jA<esc>
map <F8> 0%?::.*(by3w/{%A /* End pA() */:w

function! FindMakefile()
  let dir = getcwd()
  while ! filereadable(dir . '/Makefile') && dir != ''
    let dir = substitute(dir, '/[^/]*$', '', '')
  return dir
endfunction

function! MyMake()
  let makeLoc = FindMakefile()
  :make
endfunction

map <F9> :w \| make -j8<CR>
"map <F9> :call MyMake()<CR>
map <F12> :e ~/.notes<CR>
map <C-F12> :e ~/LabDayTopics<CR>
map <C-K> :cp<CR>
map <C-J> :cn<CR>


"Allow switching between files without saving
set hidden

set undofile 
set undodir=$HOME/.vim/undodir

"Press Space to turn off highlighting and clear any message already displayed.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Allows writing to files with root priviledges
cmap w!! w !sudo tee % > /dev/null

" Use ack for searching
set grepprg=ack\ --cpp

" Xml formatting
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null

" rtags
let g:rtagsUseLocationList = 0
let g:rtagsJumpStackMaxSize = 0

" ctags!
let dir = getcwd()
while ! filereadable(dir . '/tags') && dir != ''
  let dir = substitute(dir, '/[^/]*$', '', '')
endwhile
nnoremap <silent> <Leader>b :TagbarToggle<CR>
"g:ctags_statusline=1
"g:ctags_regenerate=0

if filereadable(dir . '/tags')
  let &tags = dir . '/tags'
endif

" cscope!
let dir = getcwd()
while ! filereadable(dir . '/cscope.out') && dir != ''
  let dir = substitute(dir, '/[^/]*$', '', '')
endwhile

"" Omnicompletion
"set nocp
"filetype plugin indent on
set ofu=syntaxcomplete#Complete
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave  * if pumvisible() == 0|pclose|endif

" Use the current directory
autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif

" Add highlighting for function definition in C++
function! EnhanceCppSyntax()
  syn match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?$"
  hi def link cppFuncDef Special
endfunction
autocmd Syntax cpp call EnhanceCppSyntax()

" Highlight misspelled words in silver
hi SpellBad ctermbg=7


" Highlighting after column 80
"if exists('+colorcolumn')
"  set colorcolumn=80
"else
"  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
"    endif

command! -complete=file -nargs=* Svn call s:ExecuteInShell('svn '.<q-args>, '<bang>')
command! -complete=shellcmd -nargs=* -bang Shell call s:ExecuteInShell(<q-args>, '<bang>')
cabbrev shell Shell

" Spelling?
" syn match AcronymNoSpell '\<\(\u\|\d\)\{3,}s\?\>' contains=@NoSpell
syn match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell
syn match CapitalWordsNoSpell +\<\w*[A-Z]\K*\>+ contains=@NoSpell

source ~/.vim/doxygen.vim
