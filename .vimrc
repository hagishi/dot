set tabstop=2
set expandtab
set shiftwidth=2
set softtabstop=2
set notitle
set nobackup
set autoread
set noswapfile
set hidden "編集中でも他のファイルを開けるようにする
set backspace=indent,eol,start
set browsedir=buffer
set number
" set showmatch "括弧の対応をハイライト
set autoindent
set smartindent
set termencoding=utf-8
set fileencodings=iso-2022-jp,utf-8,cp931,euc-jp
set fenc=utf-8
set fencs=utf-8,euc-jp,cp932
set incsearch
set nrformats=
set hlsearch "search result heightlist
set nobomb
set previewheight=30
set clipboard=unnamed
set splitright "縦分割時は右
set splitbelow
set lazyredraw
set noundofile
set ambiwidth=double
set conceallevel=0
set updatetime=50

filetype off
" set backspace=0

"default keymap
nnoremap <c-e> $
cnoremap <c-a> <HOME>
cnoremap <c-e> <END>
inoremap <c-a> <ESC>^i
inoremap <c-e> <ESC>$a
" inoremap ' ''<Left>
" inoremap " ""<left>
inoremap { {}<Left>
" inoremap [ []<left>
" inoremap ( ()<left>
" exit
"
inoremap jj <Esc><Esc>
inoremap jk <Esc><Esc>
inoremap jl <Esc><Esc>
inoremap <C-G> <Esc><Esc>
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
" inner line
inoremap <c-o> <esc>o
" delete line
inoremap <C-D> <esc>ddi

" inoremap <C-x><C-c> <C-x><C-]> 

noremap ; :
nnoremap 0 ^
nnoremap 9 <C-^>
vnoremap v i"
nnoremap <C-]> g<C-]> 
nnoremap + <C-a>
nnoremap - <C-x>
nnoremap Y y$
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap <Down> gj
nnoremap <Up>   gk


nnoremap <Del> <C-T>

inoremap <C-j> <Down>
inoremap <C-k> <Up>
" inoremap <C-h> <Left>
inoremap <C-l> <Right>

set directory+=~/dots/dict/vue-dictionary
set complete+=k

"set command mode
if has('nvim')
  command! Ev edit ~/.config/nvim/init.vim
  command! Rv source ~/.config/nvim/init.vim
  " nmap <BS> <C-W>h
else
  command! Ev edit ~/.vimrc
  command! Rv source ~/.vimrc
endif

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
vnoremap 9 $

set nofoldenable      
set foldmethod=indent   "fold based on indent
set foldlevel=5        "this is just what i use


" vim plugin start
call plug#begin('~/.vim/plugged')
" depend on ctrlp
Plug 'Shougo/vimfiler'
Plug 'Shougo/unite.vim'
" utility
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'
" color
Plug 'hagishi/sahara'

call plug#end()

filetype plugin indent on 
syntax on

set cursorline
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine guibg=#303000 ctermbg=234

" set color
colorscheme sahara

" search
noremap <ESC><ESC> :nohlsearch<CR>
autocmd FileType help nnoremap <buffer> q <C-w>c

" "set matcher
source $VIMRUNTIME/macros/matchit.vim
let b:match_words = '<:>,<\@<=tag>:<\@<=/tag>'


nnoremap  [unite]   <Nop>
nmap    f [unite]

" vimfiler
nnoremap [unite]r :<C-u>VimFilerCurrentDir -toggle -find<Cr>
nnoremap [unite]e :<c-u>VimFilerBufferDir -toggle -find<cr>
nnoremap [unite]p :<c-u>VimFiler -toggle -project<cr>

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_tree_leaf_icon = ' '
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_file_icon = '-'
let g:vimfiler_marked_file_icon = '*'

autocmd! FileType vimfiler call s:my_vimfiler_settings()
function! s:my_vimfiler_settings()
    nnoremap <silent><buffer><expr> p vimfiler#do_action('project_cd')
    nmap <buffer><expr><CR> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
    nmap <buffer><expr> o vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
    nmap <buffer><expr> s vimfiler#smart_cursor_map("\<Plug>(vimfiler_select_sort_type)", "\<Plug>(vimfiler_expand_tree)")
endfunction

nnoremap <silent> <c-f> :<C-u>FZF<cr>


" surround bindings
xmap " S"
xmap ' S'
xmap [ S[
xmap ( S(
xmap { S{

