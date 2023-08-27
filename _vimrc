set nocompatible 
"set number
"set relativenumber
set encoding=utf-8
set autoindent 
set cindent
set termguicolors
set nowrap
set belloff=all



if has('gui')                " gVim specific stuff
	set guifont=Consolas:h14 " set font and font size
	set guioptions-=T        " remove toolbar
	set guioptions-=r        " remove right scrollbar
	set guioptions-=L        " remove left scrollbar
	set guioptions-=m        " remove menubar
	set guioptions+=k        " hindre vinduet i å resize når man bruker vsplit
	au GUIenter * simalt ~x  " åpne i maximized vindu
	set backspace=indent,eol,start " fikse så backspace fungerer
	if isdirectory('w:')
	cd w:\handmade\code\
endif
	au VimEnter * if argc() == 0 | topleft vsplit | e . " split screen på startup (hvis man ikke åpner en spesifikk fil)
	wincmd h " bytt til venstre vindu etter å ha splittet vindu
endif

filetype plugin indent on
syntax on

" fjerner autokommentering når man går til neste linje
autocmd FileType * set formatoptions-=cro

imap Îy <BS> 
set cursorline

function! CheckBrace()
	"veldig janky, men match() returnerer tydeligvis -1 hvis den
	"ikke finner en match og 0 hvis det matcher. må derfor plusse 
	"på 1 for å få if til å fungere riktig.
	"regexen sjekker om det er en høyre-parantes av noe slag
	if match(getline(".")[col(".")-1], ')\|]\|}') +1
		:exe 'normal %"byy%'
		if match(@b,'^[ \t^I]*\((\|[\|{\)') +1
			:exe 'normal %k"byyj%"'
		endif
	:echomsg trim(@b)
	else
		:redraw!
	endif
endfunction


nnoremap <A-]> :call CheckBrace()<CR>

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
			:E
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
			:E  
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

function! ToggleHFile()
    let l:filename = @%
    if match(l:filename, '.*\.cpp') + 1
        let l:file = matchstr(l:filename, '\zs.*\.\zecpp') 
        let l:hfile = l:file . 'h'
        :w
        :execute(':edit '. expand(l:hfile))
    endif
    if match(l:filename, '.*\.h') + 1
        let l:file = matchstr(l:filename, '\zs.*\.\zeh') 
        let l:cppfile = l:file . 'cpp'
        :w
        :execute(':edit '. expand(l:cppfile))
    endif
endfunction

" prøver å gjøre det smudere å åpne filer
nnoremap <A-Space> :call ToggleSplits()<CR>
nnoremap <A-m> :call NewFileRight()<CR>
nnoremap <A-n> :call NewFileLeft()<CR> 
nnoremap <A-u> :call SwapSplits()<CR>
nnoremap <C-q> :call ToggleHFile()<CR>

"NETRW greier

"set hidden ødelegger build.bat filen, orker ikke deale med det
" får heller bare være litt jævlig med netrw
set nohidden
let g:netrw_banner = 0
let g:netrw_browse_split = 0



function! MoveLeft()
	:exe "normal 0"
	if getline(".")[col(".")-1] == " "
		:exe "normal w"
	endif
endfunction

nnoremap H :call MoveLeft()<CR>
nnoremap L $
nnoremap <C-h> b
nnoremap <C-l> w

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

"sentrer skjermen på teksten horisontalt
nnoremap zx 0wzs


set expandtab
set shiftwidth=4
set tabstop=4

" open buffers vertically 
cabbrev vb vert sb

set hlsearch
let @/ = "" " fjerner forrige søk når jeg resourcer vimrc
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

autocmd Syntax cpp syntax keyword NoteMarker NOTE containedin=.*Comment,vimCommentTitle,cCommentL
autocmd Syntax cpp syntax keyword TodoMarker TODO containedin=.*Comment,vimCommentTitle,cCommentL
autocmd Syntax cpp syntax keyword ImportantMarker IMPORTANT containedin=.*Comment,vimCommentTitle,cCommentL

autocmd Syntax cpp hi NoteMarker gui=bold guifg=DarkGreen
autocmd Syntax cpp hi TodoMarker gui=bold guifg=DarkRed
autocmd Syntax cpp hi ImportantMarker gui=bold guifg=Yellow

autocmd BufRead,BufNewFile *.log :call ReadLogFile()
function! ReadLogFile()
	nnoremap <buffer> <CR> :call GotoError()<CR>
	highlight ErrorFiles gui=bold,undercurl
	:match ErrorFiles /^.:\(\\.*\\\)\zs.*\..*\ze(\d*)/
endfunction

function! GotoError()
	try
		" filnavn til feil i f-register
		:redir @f> |.g/^.:\(\\.*\\\).*\..*\ze(\d*)/echon matchstr(getline('.'),@/)|redir END | redraw

		"linjenr til feil i l-register
		:redir @l> |.g/^.:\(\\.*\\\).*\..*(\zs\d.*\ze):/echon matchstr(getline('.'),@/)|redir END
		:call clearmatches()
		:winc p
		:w
		:execute 'edit' @f
		:execute @l
	catch /E492:/
	endtry
endfunction

if isdirectory('w:')
function! Build()
	if tabpagewinnr(tabpagenr(), '$') == 1
		:call system('del w:\build\build.log')
		:vsplit w:\build\build.log|put=system('w:\handmade\misc\shell.bat & w:\handmade\code\build.bat') | redraw
		":setlocal wrap
		:w
		":let l:buildoutput = system('w:\handmade\misc\shell.bat & w:\handmade\code\build.bat')
		":call writefile(split(l:buildoutput, "\n", 1),'w:\build\build.log')

		":cg w:\build\build.log | redraw
		":botright cwindow
		":vert copen
		":let g:errors=len(filter(getqflist(), 'v:val.valid'))
		":setlocal statusline=\ \ %f%=%{g:errors}\ errors\ 
		":exe "normal \<C-w>="
		":setlocal wrap
		":winc w "flytter cursor tilbake
		
		"gamle løsningen under:
		":copen
		":w
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
endif

" mister ctrl-i for å hoppe i jumplist når jeg remapper <tab>
"går ikke å bare remappe til ctrl-i på nytt, så må ta noe annet
nnoremap <C-p> <C-i> 

"enklere navigering mellom vinduer
nnoremap <Tab> <C-w><C-w>
nnoremap <S-Tab> <C-w>W


" nnoremap <C-t> :!python %<CR>
nnoremap <C-t> :call Build()<CR>
"nnoremap % :source %<CR>
nnoremap <Leader>b :ls<CR>:b<Space>
nnoremap <C-J> :bnext<CR>
nnoremap <C-K> :bprev<CR>


"noe med det verste jeg har vært med på:
"function! Awful(string)
"	return fnamemodify(a:string.name,":t")
"endfunction
"function! NextBuf()
"	setlocal statusline=
"	for buf in getbufinfo({'buflisted':1})
"		echo fnamemodify(buf.name,":t")
"		"let @f = fnamemodify(buf.name,":t")
"		setlocal statusline+=%{Awful(buf)}\ 	
"	endfor
"endfunction


" fjerne hjelpmenyen fra K
nnoremap K kJ
vnoremap K kJ

" typos
:command! WQ wq
:command! Wq wq
:command! W w
:command! Q q
:command! WQA wqa
:command! WQa wqa
:command! Wqa wqa
"
" lettere å copypaste vanlig register
nnoremap <A-c> "+y
nnoremap <A-v> "+p
vnoremap <A-c> "+y
vnoremap <A-v> "+p

" flytte linjer opp eller ned
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

nnoremap <A-p> vip


"set ignorecase
nnoremap <Space> /
nnoremap <C-Space> ?

" for marks
nnoremap , `
nnoremap d, d`
nnoremap c, c`
nnoremap y, y`
nnoremap g, g`

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
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-surround'
Plug 'yssl/QFEnter'
call plug#end()
colorscheme gruvbox 
set bg=dark
