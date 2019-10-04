" Automated vim-plug install

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Some plugins!
" ============================================
call plug#begin('~/.local/share/nvim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
	let g:airline_theme='cobalt2' 
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'https://github.com/alok/notational-fzf-vim'
	let g:nv_search_paths = [ '~/Documents/notes/memory', '~/Documents/notes/memory/quicknotes/Scratchpad.md']
call plug#end()

" Commands to automatically highlight unnecessary whitespace
" ============================================

autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Some standard settings
" ============================================

set hlsearch 
set number relativenumber
set nu rnu
syntax on
color getafe

" Some keybindings
" Ged rid of search result highlights after pressing escape
nnoremap <esc> :noh<return><esc>
nnoremap <silent> <c-s> :NV<CR>
