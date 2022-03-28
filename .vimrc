set nocompatible 
set number

set relativenumber
set encoding=utf-8
set autoindent 


filetype plugin indent on
syntax enable 

" open buffers vertically 
set splitright
cabbrev vb vert sb


" search in subfolders and tabcomplete
set path +=**

" show matching files with tabcomplete
set wildmenu 

" fold settings
set foldmethod=indent
nnoremap <space> za
vnoremap <space> zf

" different remapped keys
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <Tab> <C-w><C-w>
nnoremap <C-t> :!python3 %<CR>
"nnoremap % :source %<CR>
nnoremap <Leader>b :ls<CR>:b<Space>
map <C-J> :bnext<CR>
map <C-K> :bprev<CR>



" plugins 
call plug#begin('~/.vim/plugged')
Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmgs'
let g:vimtex_compiler_method = 'latexmk'
let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-pdf',
    \   '-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}


Plug 'arcticicestudio/nord-vim'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-surround'
Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']
call plug#end()
