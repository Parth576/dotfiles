:set number relativenumber 
:set ruler
:set incsearch
:set clipboard+=unnamedplus
:set splitbelow
:set splitright
:set expandtab
:set tabstop=4
:set shiftwidth=4
:set hidden
:set nocompatible
:set t_Co=256

:tnoremap <Esc> <C-\><C-n>
:tnoremap <A-h> <C-\><C-N><C-w>h
:tnoremap <A-j> <C-\><C-N><C-w>j
:tnoremap <A-k> <C-\><C-N><C-w>k
:tnoremap <A-l> <C-\><C-N><C-w>l
:inoremap <A-h> <C-\><C-N><C-w>h
:inoremap <A-j> <C-\><C-N><C-w>j
:inoremap <A-k> <C-\><C-N><C-w>k
:inoremap <A-l> <C-\><C-N><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l

let g:rainbow_active = 1

"inoremap " ""<left>
"inoremap ' ''<left>
"inoremap ( ()<left>
"inoremap [ []<left>
"inoremap { {}<left>
"inoremap {<CR> {<CR>}<ESC>O
"inoremap {;<CR> {<CR>};<ESC>O

"inoremap <expr> ) strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
map <C-n> :NERDTreeToggle<CR>
map <A-s> :split new<CR>
map <A-;> :vsplit new<CR>
map <A-w> :close<CR>
map <C-h> :bprev<CR>
map <C-l> :bnext<CR>
map <A-d> :bd<CR>
"map <C-d> :bd<CR>
map <C-p> :FZF<CR>

call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'morhetz/gruvbox'
Plug 'luochen1990/rainbow'

call plug#end()

"silent! colorscheme onedark
silent! colorscheme gruvbox

let g:airline#extensions#tabline#enabled = 1
"let g:airline_left_sep='>'
"let g:airline_right_sep='<'
let g:airline_detect_modified=1
let g:airline_detect_paste=1
"let g:airline_powerline_fonts = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
"let g:airline_theme='onedark'
let g:airline_theme='gruvbox'
let g:airline#extensions#tabline#ignore_bufadd_pat = 'defx|gundo|nerd_tree|startify|tagbar|undotree|vimfiler'
