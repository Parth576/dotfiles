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
syntax enable
if (has("termguicolors"))
 set termguicolors
endif
":set autochdir
autocmd BufEnter * silent! lcd %:p:h

" Stuff for CoC-Nvim
:set encoding=utf-8
:set nobackup
:set nowritebackup
:set cmdheight=2
:set updatetime=300
:set shortmess+=c
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Neovide settings
let g:neovide_transparency=1.0
:set guifont=FiraCode\ Nerd\ Font:h13

" Keybindings
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
"let g:NERDTreeChDirMode = 2
"inoremap " ""<left>
"inoremap ' ''<left>
"inoremap ( ()<left>
"inoremap [ []<left>
"inoremap { {}<left>
"inoremap {<CR> {<CR>}<ESC>O
"inoremap {;<CR> {<CR>};<ESC>O

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
"Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'vim-airline/vim-airline-themes'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'luochen1990/rainbow'
Plug 'ryanoasis/vim-devicons'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
"---Themes---
"Plug 'joshdick/onedark.vim'
"Plug 'haishanh/night-owl.vim'
"Plug 'morhetz/gruvbox'
"Plug 'arcticicestudio/nord-vim'
Plug 'rakr/vim-one'
Plug 'morhetz/gruvbox'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
"Plug 'folke/tokyonight.nvim'
"Plug 'whatyouhide/vim-gotham'

call plug#end()

"autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif

"let g:tokyonight_style = "night"
"silent! colorscheme onedark
"silent! colorscheme gotham256
"silent! colorscheme gruvbox
silent! colorscheme one
"silent! colorscheme tokyonight
set background=dark

let NERDTreeShowHidden=1
let g:NERDTreeIgnore = ['^node_modules$']

let g:coc_global_extensions = ['coc-pairs','coc-python','coc-tsserver','coc-json']

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
"let g:airline_left_sep='>'
"let g:airline_right_sep='<'
let g:airline_detect_modified=1
let g:airline_detect_paste=1
"let g:airline_powerline_fonts = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
"let g:airline_theme='tokyonight'
let g:airline_theme='onedark'
"let g:airline_theme='gotham256'
"let g:airline_theme='nord'
let g:airline#extensions#tabline#ignore_bufadd_pat = 'defx|gundo|nerd_tree|startify|tagbar|undotree|vimfiler'
