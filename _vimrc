set nocompatible 
set number
set relativenumber
set encoding=utf-8
set autoindent 
set cindent
set termguicolors
set nowrap


if has('gui')                " gVim specific stuff
	set guifont=Consolas:h14 " set font and font size
	set guioptions-=T        " remove toolbar
	set guioptions-=r        " remove right scrollbar
	set guioptions-=L        " remove left scrollbar
	set guioptions-=m        " remove menubar
	set guioptions+=k        " hindre vinduet i å resize når man bruker vsplit
	au GUIenter * simalt ~x  " åpne i maximized vindu
	set backspace=indent,eol,start " fikse så backspace fungerer
	cd w:\handmade\code\
	"let check_file = system(":f") | echo strtrans(check_file)  " prøvde å
	"ikke få split når man åpner en fil direkte, og ikke gjennom netrw, funka
	"ikke helt
	"if check_file == ""
	au VimEnter * topleft vsplit | e . " split screen på startup
	wincmd h " bytt til venstre vindu etter å ha splittet vindu
	"endif
endif


imap Îy <BS> 
set cursorline

function! CheckIndent()
	const indent_no = indent(line("."))
	echo indent_no
endfunction


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
	" må legge til catch til E37
	if tabpagewinnr(tabpagenr(), '$') == 1
		:topleft vsplit .
	elseif tabpagewinnr(tabpagenr(), '$') == 2
		:exe "normal \<C-w>\<C-h>"
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
		:vsplit
		:b #
		:exe "normal \<C-w>\<C-w>" 
		" call NewFileRight()
	else
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

nnoremap H 0
nnoremap L $

function! BetterInsert()
	if getline('.') =~ '^\s*$'
		call feedkeys('cc')
	else
		:startinsert
	endif
endfunction

nnoremap i :call BetterInsert()<CR>


"autocomplete med tab
inoremap <Tab> <C-n>
inoremap <S-Tab> <C-p>

nnoremap zx 0wzs
filetype plugin indent on
syntax on

set shiftwidth=4
set tabstop=4

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

function! Build()
	" legge til at outputten legges til i en log-fil som overskrides hver gang
	" jeg kjører. må også se om jeg kan få den til å kjøre raskere, er veldig
	" treg nå....
	if tabpagewinnr(tabpagenr(), '$') == 1
		:call system('del w:\build\build.log')
		:vsplit w:\build\build.log|put=system('w:\handmade\misc\shell.bat & w:\handmade\code\build.bat') | redraw
		:w
		:set wrap
		:execute "normal \<C-w>\<C-w>"
	elseif tabpagewinnr(tabpagenr(), '$') == 2
		if winnr() == winnr('$')
			:call ToggleSplits()
			:call Build()
			:call SwapSplits()
		else
			:call ToggleSplits()
			:call Build()
		endif
	endif
endfunction

" different remapped keys
nnoremap <Tab> <C-w><C-w>
" nnoremap <C-t> :!python %<CR>
nnoremap <C-t> :call Build()<CR>
"nnoremap % :source %<CR>
nnoremap <Leader>b :ls<CR>:b<Space>
nnoremap <C-J> :bnext<CR>
nnoremap <C-K> :bprev<CR>

" fjerne hjelpmenyen fra K
nnoremap K kJ
vnoremap K kJ

" typos
:command! WQ wq
:command! Wq wq
:command! W w
:command! Q q
"
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

nnoremap <A-p> vip


set ignorecase
nnoremap <Space> /
nnoremap <C-Space> ?

" for marks
nnoremap , `

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
"Plug 'rust-lang/rust.vim'
"Plug 'sirver/ultisnips'
"let g:UltiSnipsExpandTrigger = '<tab>'
"let g:UltiSnipsJumpForwardTrigger = '<tab>'
"let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
"let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']
call plug#end()
colorscheme gruvbox 
