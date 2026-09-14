" ==============================
" general
" ==============================

set nocompatible
set encoding=utf-8
scriptencoding utf-8
set backspace=indent,eol,start
set autoindent
set expandtab shiftwidth=4 tabstop=4
set nowrap
set belloff=all
set cursorline
set noswapfile
set nohidden
set confirm
set path+=**
set wildmenu wildcharm=<C-z>
set splitright
set hlsearch incsearch
let @/ = ''

let g:netrw_banner = 0
let g:netrw_use_errorwindow = 0

filetype plugin indent on
syntax enable

augroup vimrc
    autocmd!
augroup END

" home computer has the w: drive (subst w: c:\work), work computer does not
let s:home = isdirectory('w:\')

" ==============================
" gui
" ==============================

if has('gui_running')
    if has('win32')
        set guifont=Liberation\ Mono:h12,Consolas:h12
        autocmd vimrc GUIEnter * simalt ~x
    else
        set guifont=Liberation\ Mono\ 12
    endif
    set guioptions-=T guioptions-=r guioptions-=L guioptions-=m guioptions+=k
    if s:home
        cd w:\
    endif
endif

autocmd vimrc VimEnter * if argc() == 0 | call timer_start(100, {-> execute('topleft vsplit | Explore')}) | endif

" ==============================
" colors
" ==============================

if has('termguicolors')
    set termguicolors
endif

hi Normal          guifg=#ffe599 guibg=#222222
hi CursorLine      guibg=#2a2a2a gui=NONE cterm=NONE
hi Cursor          guibg=#6ab26a
hi lCursor         guifg=#b26a6a
hi MatchParen      guifg=#b26a6a guibg=#222222
hi VertSplit       guifg=#555555 guibg=#222222 gui=NONE cterm=NONE
hi StatusLine      guifg=#6ab26a guibg=#555555 gui=bold cterm=bold
hi StatusLineNC    guifg=#6ab26a guibg=#333333 gui=NONE cterm=NONE
hi Pmenu           guifg=#6ab26a guibg=#333333
hi PmenuSel        guifg=#b26a6a guibg=#555555
hi Comment         guifg=#954d95
hi EndOfBuffer     guifg=#954d95
hi Constant        guifg=#6a6ab2
hi Identifier      guifg=#6a6ab2
hi Statement       guifg=#b26a6a
hi PreProc         guifg=#b26a6a
hi Type            guifg=#6ab26a
hi NoteMarker      guifg=DarkGreen gui=bold
hi TodoMarker      guifg=DarkRed gui=bold
hi ImportantMarker guifg=Yellow gui=bold
hi ErrorFiles      gui=bold

autocmd vimrc Syntax c,cpp,cs syntax keyword NoteMarker NOTE containedin=.*Comment,cCommentL
autocmd vimrc Syntax c,cpp,cs syntax keyword TodoMarker TODO containedin=.*Comment,cCommentL
autocmd vimrc Syntax c,cpp,cs syntax keyword ImportantMarker IMPORTANT containedin=.*Comment,cCommentL

" ==============================
" filetypes & indentation
" ==============================

autocmd vimrc FileType * setlocal formatoptions-=cro
autocmd vimrc FileType c,cpp setlocal cinoptions==0,+2s,(0,t0,N-s
autocmd vimrc BufNewFile,BufRead *.glsl,*.vert,*.frag,*.geom,*.comp,*.tesc,*.tese setlocal filetype=cpp

" ==============================
" navigation
" ==============================

nnoremap <Tab> <C-w><C-w>
nnoremap <S-Tab> <C-w>W
nnoremap <C-p> <C-i>

nnoremap <C-j> }
nnoremap <C-k> {
nnoremap H ^
nnoremap L $
nnoremap <C-h> :call GoLeft()<CR>
nnoremap <C-l> :call GoRight()<CR>
nnoremap zx 0wzs

nnoremap <Space> /
nnoremap <C-Space> ?
nnoremap , `
nnoremap d, d`
nnoremap c, c`
nnoremap y, y`
nnoremap g, g`

nnoremap <C-f> :find ./**/*
nnoremap <Leader>b :ls<CR>:b<Space>
nnoremap <C-Tab> :b <C-z>
nnoremap <C-S-Tab> :b <C-z>
cabbrev vb vert sb

nnoremap <A-]> :call ShowBlockStart()<CR>
nnoremap <A-Space> :call ToggleSplits()<CR>
nnoremap <A-m> :call OpenExplorer('l')<CR>
nnoremap <A-n> :call OpenExplorer('h')<CR>
nnoremap <A-u> <C-w>x
nnoremap <C-q> :call ToggleHFile()<CR>
nnoremap gf :call GotoFileRight()<CR>
nnoremap - :silent! update<CR>:call ExploreHere()<CR>

" terminals send alt as <Esc>
if !has('gui_running')
    nnoremap <Esc>] :call ShowBlockStart()<CR>
    nnoremap <Esc>m :call OpenExplorer('l')<CR>
    nnoremap <Esc>n :call OpenExplorer('h')<CR>
    nnoremap <Esc>u <C-w>x
endif

" move to previous/next part of a snake_case name
function! GoLeft()
    normal! h
    let pos = getpos('.')
    normal! T_
    if pos == getpos('.')
        normal! b
    endif
endfunction

function! GoRight()
    let pos = getpos('.')
    normal! f_l
    if pos == getpos('.')
        normal! w
    endif
endfunction

" ==============================
" editing
" ==============================

nnoremap > >>
nnoremap < <<
nnoremap K kJ
vnoremap K kJ
nnoremap <A-p> vip
nnoremap i :call BetterInsert()<CR>
nnoremap <Leader>p :call PasteMenu()<CR>
inoremap <expr> <Tab> col('.') > 1 && getline('.')[col('.') - 2] !~ '\s' ? "\<C-n>" : "\<Tab>"
inoremap <S-Tab> <C-p>

nnoremap <A-c> "+y
nnoremap <A-v> "+p
vnoremap <A-c> "+y
vnoremap <A-v> "+p

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

autocmd vimrc CmdlineEnter /,\? set hlsearch
autocmd vimrc CmdlineLeave /,\? set nohlsearch
nnoremap <Leader>h <Cmd>set hlsearch!<CR>
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" on a closing bracket: echo the line that opens the block
function! ShowBlockStart()
    if getline('.')[col('.') - 1] !~ '[)\]}]'
        redraw!
        return
    endif
    let pos = getpos('.')
    normal! %
    let text = getline('.')
    if text =~ '^\s*[(\[{]'
        let text = getline(line('.') - 1)
    endif
    call setpos('.', pos)
    echo trim(text)
endfunction

function! BetterInsert()
    if getline('.') =~ '^\s*$'
        call feedkeys('cc', 'n')
    else
        startinsert
    endif
endfunction

let s:paste_regs = split('"0123456789abcdefghijklmnopqrstuvwxyz-.:%+', '\zs')

function! PasteMenu()
    let items = map(copy(s:paste_regs), {_, r -> r . ' ' . substitute(getreg(r), '\n', '\\n', 'g')})
    call popup_menu(items, #{wrap: 0, maxwidth: 100, callback: 'PasteMenuHandler'})
endfunction

function! PasteMenuHandler(id, result)
    if a:result > 0 && getreg(s:paste_regs[a:result - 1]) !=# ''
        execute 'normal! "' . s:paste_regs[a:result - 1] . 'P'
    endif
endfunction

" ==============================
" windows & files
" ==============================

function! ToggleSplits()
    if winnr('$') == 1
        vsplit
        silent! buffer #
        wincmd p
    else
        only
    endif
endfunction

" netrw in the current window, in the directory of the current file
function! ExploreHere()
    let dir = substitute(expand('%:p'), '[^/\\]*$', '', '')
    execute 'edit' fnameescape(dir ==# '' ? '.' : dir)
endfunction

" side is 'h' or 'l'
function! OpenExplorer(side)
    if winnr('$') == 1
        execute (a:side ==# 'h' ? 'topleft' : 'botright') 'vsplit .'
    elseif winnr('$') == 2
        execute 'wincmd' a:side
        call ExploreHere()
    endif
endfunction

function! GotoFileRight()
    let file = expand('<cfile>')
    if file ==# ''
        return
    endif
    if winnr('$') == 1
        vsplit
    else
        wincmd l
    endif
    try
        execute 'find' fnameescape(file)
    catch /E345:/
        execute 'edit' fnameescape(file)
    endtry
endfunction

function! ToggleHFile()
    let base = expand('%:r')
    if expand('%:e') =~# '^\%(h\|hpp\)$'
        let candidates = [base . '.cpp', base . '.c']
    elseif expand('%:e') =~# '^\%(c\|cpp\)$'
        let candidates = [base . '.h', base . '.hpp']
    else
        return
    endif
    for file in candidates
        if filereadable(file)
            update
            execute 'edit' fnameescape(file)
            return
        endif
    endfor
endfunction

autocmd vimrc FileType netrw nnoremap <buffer> <Esc> :Rex<CR>

command! -nargs=1 -complete=file Rename saveas <args> | call delete(expand('#:p')) | bwipeout #
command! Scratch vnew | setlocal buftype=nofile bufhidden=hide noswapfile
command! WQ wq
command! Wq wq
command! W w
command! Q q
command! WQA wqa
command! WQa wqa
command! Wqa wqa

" ==============================
" build & search
" ==============================

" output goes to a scratch split; <CR> on a "file(line)" or "file:line:" jumps there
let s:log_pattern = '^\(.\{-}\)(\(\d\+\)\%(,\d\+\)\?)'
let s:search_pattern = '^\(.\{-}\):\(\d\+\):'
let s:search_globs = '*.h *.c *.hpp *.cpp *.cs *.glsl *.vert *.frag'
let s:jobs = {}

nnoremap <C-t> :call Build()<CR>
command! -nargs=1 SearchFiles call SearchFiles(<q-args>)
command! -nargs=+ Grep cexpr system(s:SearchCmd(<q-args>)) | copen
autocmd vimrc BufNewFile,BufRead *.log call s:SetupJumpBuffer(s:log_pattern)

function! Build()
    if &filetype ==# 'c' || &filetype ==# 'cpp'
        let cmd = (s:home ? 'w:\dotfiles\shell.bat & ' : '') . 'build.bat'
    elseif &filetype ==# 'cs'
        let cmd = 'dotnet build'
    elseif &filetype ==# 'tex' && s:home
        let cmd = 'w:\kompendium\build.bat'
    else
        return
    endif
    silent! update
    call s:RunInSplit('[build.log]', cmd, s:log_pattern)
endfunction

function! SearchFiles(pattern)
    call s:RunInSplit('[search]', s:SearchCmd(a:pattern), s:search_pattern)
endfunction

function! s:SearchCmd(pattern)
    if has('win32')
        return 'findstr -s -n -i ' . a:pattern . ' ' . s:search_globs
    endif
    return 'grep -rniI ' . shellescape(a:pattern) . ' ' . join(map(split(s:search_globs), {_, g -> shellescape('--include=' . g)})) . ' .'
endfunction

function! s:ShellCmd(cmd)
    return has('win32') ? 'cmd.exe /c "' . a:cmd . '"' : ['sh', '-c', a:cmd]
endfunction

" runs cmd async in a scratch split, keeping the layout at two windows
function! s:RunInSplit(name, cmd, pattern)
    if winnr('$') > 2
        return
    endif
    let keep_right = winnr('$') == 2 && winnr() == winnr('$')
    if winnr('$') == 2
        only
    endif
    let old = get(s:jobs, a:name, {})
    if has_key(old, 'job') && job_status(old.job) ==# 'run'
        call job_stop(old.job)
    endif
    if has_key(old, 'buf') && bufexists(old.buf)
        execute 'silent! bwipeout!' old.buf
    endif
    vnew
    setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted
    execute 'silent! file' a:name
    call s:SetupJumpBuffer(a:pattern)
    let s:jobs[a:name] = #{buf: bufnr('%'), job: job_start(s:ShellCmd(a:cmd), #{
                \ out_io: 'buffer', out_buf: bufnr('%'), out_msg: 0,
                \ err_io: 'buffer', err_buf: bufnr('%'), err_msg: 0})}
    if keep_right
        wincmd x
    endif
endfunction

function! s:SetupJumpBuffer(pattern)
    let b:jump_pattern = a:pattern
    execute 'syntax match ErrorFiles /' . a:pattern . '/'
    nnoremap <buffer> <CR> :call <SID>JumpToTarget()<CR>
endfunction

function! s:JumpToTarget()
    let m = matchlist(getline('.'), b:jump_pattern)
    if empty(m) || !filereadable(m[1])
        echohl WarningMsg | echo 'no jump target on this line' | echohl None
        return
    endif
    wincmd p
    silent! update
    execute 'edit' fnameescape(m[1])
    execute m[2]
endfunction

" ==============================
" misc
" ==============================

inoremap Îy <BS>
