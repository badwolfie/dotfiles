set nocompatible              " be iMproved, required
filetype off                  " required

" Set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle/')
" Alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" Plugin: Vundle
Plugin 'VundleVim/Vundle.vim'

" Plugin: Ag.vim
Plugin 'rking/ag.vim'

" Plugin: NERD Tree
Plugin 'scrooloose/nerdtree'

" Plugin: YouCompleteMe
Plugin 'Valloric/YouCompleteMe'

" Plugin: Vim-markdown
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" Plugin: delimitMate
Plugin 'Raimondi/delimitMate'

" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" See :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Config: Colors
set background=dark
colorscheme molokai
syntax enable
set t_Co=256

" Config: Editor
set tabstop=4
set shiftwidth=4
set colorcolumn=80
set cursorline
set number

" Config: Vim-airline
"if !exists('g:airline_symbols')
"  let g:airline_symbols = {}
"endif
"let g:airline_theme='tmuxline'
"let g:airline_powerline_fonts = 0
"let g:airline_left_sep = '▶'
"let g:airline_left_alt_sep = '❯'
"let g:airline_right_sep = '◀'
"let g:airline_right_alt_sep = '❮'
"let g:airline_symbols.readonly = '✘'
"let g:airline_symbols.branch = '⎇'

" Config: Ag.vim
let g:ag_working_path_mode="r"

" Config: NERD Tree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
map <C-n> :NERDTreeToggle<CR>

" Config: Vim-markdown
let g:vim_markdown_math=1


" Funtion: Tab_Or_Complete()
" Use TAB to complete when typing words, else inserts TABs as usual.
" Uses dictionary and source files to find matching words to complete.

" See help completion for source,
" Note: usual completion is on <C-n> but more trouble to press all the time.
" Never type the same word twice and maybe learn a new spellings!
" Use the Linux dictionary when spelling is in doubt.
" Window users can copy the file to their machine.
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
set dictionary="/usr/dict/words"
