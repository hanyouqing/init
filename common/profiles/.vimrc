""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @filename: ~/.vimrc
" @filepath:
"       system vimrc file: "$VIM/vimrc"
"       user vimrc file: "$HOME/.vimrc"
"       user exrc file: "$HOME/.exrc"
"       system gvimrc file: "$VIM/gvimrc"
"       user gvimrc file: "$HOME/.gvimrc"
" @reference:
"       http://www.vim.org/
"       https://github.com/yangyangwithgnu/use_vim_as_ide
"       http://www.cnblogs.com/ma6174/archive/2011/12/10/2283393.html
"       https://unknwon.io/posts/140704_setup-vim-for-go-development/
" @commands4vim:
"       help [subcmd], set all
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shortmess=atI                   " no uganda
set noeb                            " no error bell
set vb t_vb=						"
set nocompatible                    " nocompatible with vi, compatible mode "tab" would not be "space"


"""""""""""""""
" Vim Setting "
"""""""""""""""
"colorscheme murphy                 " color scheme
"color asmanian2                    " set background theme
"set guifont=Courier_New:h10:cANSI  " set font family
set guifont=YaHei\ Consolas\ Hybrid\ 11.5
set go=                             " hide graphic button
syntax enable                       " enable syntax highlight
syntax on                           " enable to replace default color theme
set hlsearch                        " highlight search word
set incsearch                       " highlight current search
set showmatch                       " hightlight matched bracket
set matchtime=1                     " hightlight matched time
set ruler                           " highlight curruent position of cursor
set cursorline                      " highlight current line of cursor
"set cursorcolumn                    " highlight current column of cursor
"hi CursorLine term=reverse cterm=NONE   ctermbg=darkblue ctermfg=darkgreen
"hi CursorColumn cterm=NONE ctermbg=darkblue ctermfg=white
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
"highlight CursorLine guibg=#EE000 ctermbg=234
highlight CursorLine guibg=#EE000 ctermbg=234 ctermfg=darkgreen

" golang
let g:go_disable_autoinstall = 0
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

set scrolloff=3                     "
set number                          " show line number
set wildmenu                        " vim cmd auto-complete
set history=1000                    " set cmd history
set showmode                        " show left bottom status bar

set nolist                          " show print character
set wrap                            " show line feed
set nopaste                         " turn on paste mode

"set autoindent                      " autoindent
"set cindent                         " autoindent
"set smartindent                     " autoindent for C

set tabstop=4                       " tab size
set softtabstop=4                   " set indent as 4 character
set shiftwidth=4                    " set indent as 4 character

set smarttab                        "
"set noexpandtab                     " do not replace tab by space
set expandtab                       " do not replace tab by space
set backspace=indent,eol,start		" indent: enable backspace when set "indent" or "ai"
                                    " eol: use backspace to combine to line
                                    "      on the beginning of line
                                    "	   under "insert" mode.
                                    " start: use backspace to delete what just
                                    "		 insert.

"set term=xterm                     " clear screen when exit vim
set t_ti= t_te=                     " keep content when exit vim

""""""""""""""""
" File Setting "
""""""""""""""""
set autochdir                       "
set fileformats=unix,dos            "
set nocp                            "
filetype on                         "
filetype plugin on                  "
filetype indent on                  "

"""""""""""""""""""
" Codding Setting "
"""""""""""""""""""
set foldmethod=indent               "
set foldmethod=syntax               "
set nofoldenable                    "


""""""""""""""""""""
" Encoding Setting "
""""""""""""""""""""
set enc=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileencoding=utf-8
set langmenu=en_CN.utf-8


"""""""
" FZF "
"""""""
set rtp+=~/.fzf

""""""""""""""""""""""""""""""""" End """""""""""""""""""""""""""""""""
