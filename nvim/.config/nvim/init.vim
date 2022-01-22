" -- Neovim configuration --

" General configuration
let mapleader = ","             " Set leader key
set termguicolors
set mouse=n
set number
set relativenumber
set title                       " Show filename on terminal's header
set expandtab                   " Use spaces instead of tabs
set shiftwidth=4                " 1 tab = 4 spaces
set ignorecase
set showmatch
set splitbelow                  " Split direction
set splitright                  " Vertical split direction
set wildignorecase              " Ignore case for filenames and directories
set linebreak
if empty(glob('~/.cache/nvim/undodir'))
    silent !mkdir -p ~/.cache/nvim/undodir
endif
set undodir=~/.cache/nvim/undodir      " Undo directory
set undofile

" Specific vim config
if !has('nvim')
    syntax on              
    set background=dark
    set hlsearch                    " Enable search highlighting
    set autoindent
    set encoding=utf-8      
    set viminfo+=n~/.config/nvim/viminfo
    " https://medium.com/@dubistkomisch/how-to-actually-get-italics-and-true-colour-to-work-in-iterm-tmux-vim-9ebe55ebc2be
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
endif

" Copy to clipboard with Ctrl + C
map <C-c> "+y

" Close buffers with Ctrl + W
nmap <silent> <C-w> :bd<CR>

" Move between splits
nmap <silent> <A-k> :wincmd k<CR>
nmap <silent> <A-j> :wincmd j<CR>
nmap <silent> <A-h> :wincmd h<CR>
nmap <silent> <A-l> :wincmd l<CR>

" Key remap for wrapped lines
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> <Down> gj
nnoremap <silent> <Up> gk

" Move between tabs and buffers
nnoremap <silent> t <Esc>:tabe<CR>
nnoremap <silent><tab> gt<CR>
nnoremap <silent> <s-tab> :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>

" Easy indentation
nnoremap > >>
nnoremap < <<
vnoremap > >gv
vnoremap < <gv

" Install vim-plug if not found
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

" Plug configuration
call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))

    Plug 'gruvbox-community/gruvbox'
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'   " Git wrapper
    Plug 'romainl/vim-cool'     " Disables search highlighting when you are done
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
        let g:airline#extensions#tabline#enabled = 1
        let g:airline_theme='gruvbox'
        let g:airline#extensions#tabline#formatter = 'unique_tail'
        let g:airline_powerline_fonts = 1
    
    Plug 'neoclide/coc.nvim', {'branch': 'release'} 
        " Install node.js when necessary
        if !executable('node')
            silent !echo "Installing 'node.js'..."
            silent !curl -sL install-node.now.sh/lts | sudo -k bash 
        endif

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
        nnoremap <space> :Files<cr>
        let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
        let $FZF_DEFAULT_OPTS='--reverse'
        if has('nvim') && !exists('g:fzf_layout')
          autocmd! FileType fzf
          autocmd  FileType fzf set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
        endif
    
    Plug 'vitalk/vim-simple-todo'
        let g:simple_todo_tick_symbol = '✓'

    Plug 'akinsho/toggleterm.nvim'
        nnoremap <silent> <Leader>t :ToggleTerm<CR>

call plug#end()

" Colorscheme configuration
let g:gruvbox_contrast_dark = "medium"
let g:gruvbox_italic = "1"
let g:gruvbox_underline = "1"
let g:gruvbox_italicize_comments = "1"
set cursorline
colorscheme gruvbox

" Coc extensions
let g:coc_global_extensions = [
    \ 'coc-calc',
    \ 'coc-css',
    \ 'coc-html',
    \ 'coc-markdownlint',
    \ 'coc-phpls',
    \ 'coc-powershell',
    \ 'coc-python',
    \ 'coc-sh',
    \ 'coc-snippets',
    \ 'coc-sql',
    \ 'coc-vimlsp',
    \ 'coc-xml',
    \ ]

" Keep cursor centered vertically
" https://vim.fandom.com/wiki/Keep_your_cursor_centered_vertically_on_the_screen
augroup VCenterCursor
  au!
  au BufEnter,WinEnter,WinNew,VimResized *,*.*
        \ let &scrolloff=winheight(win_getid())/2
augroup END

