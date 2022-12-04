set nocompatible 
set number
set relativenumber
set encoding=utf-8
set autoindent 
set termguicolors

if has('gui')                    " gVim specific stuff
	set guifont=Consolas:h14 " set font and font size
	set guioptions-=T        " remove toolbar
	set guioptions-=r        " remove right toolbar
	set guioptions-=L        " remove left toolbar
	set guioptions-=m        " remove menubar
	set guioptions+=k        " hindre vinduet i å resize når man bruker vsplit
	au GUIenter * simalt ~x  " åpne i maximized vindu
	set backspace=indent,eol,start " fikse så backspace fungerer
	cd w:\
	au VimEnter * topleft vsplit | e . " split screen på startup
	wincmd h " bytt til venstre vindu etter å ha splittet vindu
endif


imap Îy <BS> 

function! SwapSplits()
	" legge til så denne ikke kjører når det ikke er kun 2 splits
	const current_buffer = bufnr("%")
	:exe "normal \<C-w>\<C-w>"
	const other_buffer = bufnr("%")

	try
		execute ":b " current_buffer
		:exe "normal \<C-w>\<C-w>"
		execute ":b" other_buffer
	catch /E37:/ " No write since last change
		:exe "normal \<C-w>\<C-w>"
		execute ":b " other_buffer
		:exe "normal \<C-w>\<C-w>"
		execute ":b" current_buffer
		:exe "normal \<C-w>\<C-w>"
	endtry
endfunction

function! NewFileLeft()
	if tabpagewinnr(tabpagenr(), '$') == 1
		:topleft vsplit .
	elseif tabpagewinnr(tabpagenr(), '$') == 2
		:exe "normal \<C-w>\<C-h>"
		:e .
	endif
endfunction

function! NewFileRight()
	if tabpagewinnr(tabpagenr(), '$') == 1
		:vsplit .
	elseif tabpagewinnr(tabpagenr(), '$') == 2
		:exe "normal \<C-w>\<C-l>" 
		try
			:e .
		catch /E37:/ " No write since last change
			echo "do you want to save the buffer? y/n "
			let l:want_to_save = Confirm()
			if l:want_to_save == 'y'
				:w
				:e .
			elseif l:want_to_save == 'n'
				:e! .
			elseif l:want_to_save == 'e' 
				redraw " for å få teksten til å forsvinne etter man avbryter
			endif
		endtry
	endif
endfunction

function! ToggleSplits()
	if tabpagewinnr(tabpagenr(), '$') == 1
		call NewFileRight()
	elseif tabpagewinnr(tabpagenr(), '$') == 2
		try
			:on
		catch /E445:/ " Other window contains changes
			echo "do you want to save the other buffer? y/n "
			let l:want_to_save = Confirm()
			if l:want_to_save == 'y'
				:exe "normal \<C-w>\<C-w>" 
				:wq
			elseif l:want_to_save == 'n'
				:exe "normal \<C-w>\<C-w>" 
				:q!
			elseif l:want_to_save == 'e'
				redraw " for å få teksten til å forsvinne etter man avbryter
			endif
		endtry
	endif
endfunction

function! Confirm()
	let l:answer = nr2char(getchar())
	if l:answer == 'y' || l:answer == 'n'
		return l:answer
	elseif l:answer == '' " avbryte med <ESC>
		return 'e'
	else
		return Confirm()
	endif
endfunction

" prøver å gjøre det smudere å åpne filer
nnoremap <A-Space> :call ToggleSplits()<CR>
nnoremap <A-m> :call NewFileRight()<CR>
nnoremap <A-n> :call NewFileLeft()<CR> 
nnoremap <A-u> :call SwapSplits()<CR>

filetype plugin indent on
syntax on

" open buffers vertically 
cabbrev vb vert sb

set hlsearch
set incsearch

set noswapfile

" search in subfolders and tabcomplete
set path +=**

" show matching files with tabcomplete
set wildmenu 

" fold settings
"set foldmethod=indent
"nnoremap <space> za
"vnoremap <space> zf
set splitright

" different remapped keys
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <Tab> <C-w><C-w>
nnoremap <C-t> :!python %<CR>
"nnoremap % :source %<CR>
nnoremap <Leader>b :ls<CR>:b<Space>
nnoremap <C-J> :bnext<CR>
nnoremap <C-K> :bprev<CR>


" typos
:command! WQ wq
:command! Wq wq
:command! W w
:command! Q q

" lettere å copypaste vanlig register
nnoremap <A-c> "+y
nnoremap <A-v> "+p

" flytte linjer opp eller ned
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

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
Plug 'morhetz/gruvbox'
" Plug 'preservim/nerdtree'
Plug 'tpope/vim-surround'
Plug 'rust-lang/rust.vim'
"Plug 'sirver/ultisnips'
"let g:UltiSnipsExpandTrigger = '<tab>'
"let g:UltiSnipsJumpForwardTrigger = '<tab>'
"let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
"let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']
call plug#end()
colorscheme gruvbox
