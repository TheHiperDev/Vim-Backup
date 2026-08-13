" =========================================================
" LEADER KEY
" =========================================================
let mapleader=" "

" =========================================================
" PLUGINS
" =========================================================
call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'clangd/coc-clangd'

call plug#end()

" =========================================================
" BASIC SETTINGS
" =========================================================
syntax on
filetype plugin indent on

set number
set cursorline
set showmatch
set termguicolors
set background=dark

" Linux clipboard
set clipboard=unnamedplus

set hidden
set updatetime=200

set scrolloff=5
set sidescrolloff=5

set nowrap
set mouse=a

set wildmenu
set incsearch
set ignorecase
set smartcase

set backspace=indent,eol,start

" =========================================================
" INDENTATION
" =========================================================
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set smartindent

" =========================================================
" THEME
" =========================================================
let g:gruvbox_contrast_dark = "hard"
colorscheme gruvbox

" =========================================================
" ZOOM SYSTEM
" =========================================================
" GUI Vim only.
" Terminal Vim cannot change the terminal font itself.

if has('gui_running')

    set guifont=JetBrainsMono\ 12
    let s:zoom = 12

    function! Zoom(delta)
        let s:zoom += a:delta

        if s:zoom < 6
            let s:zoom = 6
        endif

        if s:zoom > 200
            let s:zoom = 200
        endif

        execute "set guifont=JetBrainsMono\\ " . s:zoom
    endfunction

    function! ZoomReset()
        let s:zoom = 12
        set guifont=JetBrainsMono\ 12
    endfunction

    nnoremap <silent> + :call Zoom(1)<CR>
    nnoremap <silent> - :call Zoom(-1)<CR>
    nnoremap <silent> 0 :call ZoomReset()<CR>
    nnoremap <silent> = :call Zoom(1)<CR>

endif

" =========================================================
" BRACKETS
" =========================================================
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap { {<CR>}<Esc>O

" =========================================================
" PROJECT ROOT
" =========================================================
function! FindRoot()
    let l:git = finddir('.git', expand('%:p:h') . ';')

    if !empty(l:git)
        return fnamemodify(l:git, ':h')
    endif

    return getcwd()
endfunction

" =========================================================
" NERDTree
" =========================================================
let NERDTreeShowHidden=0
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let NERDTreeQuitOnOpen=1

nnoremap <silent> <leader>e :NERDTreeToggle<CR>
nnoremap <silent> <leader>n :NERDTreeFind<CR>

function! NERDTreeReset()
    silent! NERDTreeClose
    execute 'NERDTree ' . fnameescape(expand('%:p:h'))
endfunction

nnoremap <silent> <leader>r :call NERDTreeReset()<CR>

" =========================================================
" FZF
" =========================================================
nnoremap <silent> <leader>p :execute 'Files ' . FindRoot()<CR>
nnoremap <silent> <leader>b :Buffers<CR>

" =========================================================
" SEARCH ENGINE
" =========================================================
function! FileSearch(query)
    let g:search_term = a:query

    silent! cclose

    let l:escaped = escape(a:query, '/\.*$^~[]')

    execute 'vimgrep /' . l:escaped . '/gj %'

    copen

    execute 'match Search /\V' . l:escaped . '/'

    if !empty(getqflist())
        cfirst
    endif
endfunction

command! -nargs=+ S call FileSearch(<q-args>)

nnoremap <silent> <leader>s :S 
nnoremap <silent> <leader>j :cnext<CR>
nnoremap <silent> <leader>k :cprev<CR>
nnoremap <silent> <leader>q :cclose<CR>:match none<CR>

" =========================================================
" CP TEMPLATE
" =========================================================
" Put your template here:
" ~/.vim/cp_template.cpp

let g:cp_template = expand('~/.vim/cp_template.cpp')

command! -nargs=1 CP call CpTemplate(<q-args>)

function! CpTemplate(path)
    let l:file = a:path

    " If the argument is not an absolute path,
    " open it relative to the current directory.
    if l:file !~# '^/'
        let l:file = getcwd() . '/' . l:file
    endif

    execute 'edit ' . fnameescape(l:file)

    " Insert CP template into an empty file
    if line('$') == 1 && getline(1) == ''
        if filereadable(g:cp_template)
            call append(0, readfile(g:cp_template))
        else
            echoerr 'CP template not found: ' . g:cp_template
        endif
    endif

    normal! gg
endfunction

" =========================================================
" COC / AUTOCOMPLETE TOGGLE
" =========================================================

" 0 = OFF by default
" 1 = ON
let g:autocomplete_enabled = 0

set completeopt=menuone,noselect
set shortmess+=c

function! CheckBackspace() abort
    let l:col = col('.') - 1

    return !l:col || getline('.')[l:col - 1] =~# '\s'
endfunction

" ---------------------------------------------------------
" ENABLE AUTOCOMPLETE
" ---------------------------------------------------------
function! CompleteOn() abort
    let g:autocomplete_enabled = 1

    silent! CocEnable

    echo "Autocomplete: ON"
endfunction

command! CompleteOn call CompleteOn()

" ---------------------------------------------------------
" DISABLE AUTOCOMPLETE
" ---------------------------------------------------------
function! CompleteOff() abort
    let g:autocomplete_enabled = 0

    silent! CocDisable

    echo "Autocomplete: OFF"
endfunction

command! CompleteOff call CompleteOff()

" ---------------------------------------------------------
" TAB
" ---------------------------------------------------------
inoremap <silent><expr> <TAB>
\ !g:autocomplete_enabled
\ ? "<Tab>"
\ : coc#pum#visible()
\ ? coc#pum#next(1)
\ : CheckBackspace()
\ ? "<Tab>"
\ : coc#refresh()

" ---------------------------------------------------------
" SHIFT + TAB
" ---------------------------------------------------------
inoremap <silent><expr> <S-TAB>
\ !g:autocomplete_enabled
\ ? "<S-TAB>"
\ : coc#pum#visible()
\ ? coc#pum#prev(1)
\ : "<C-h>"

" ---------------------------------------------------------
" ENTER
" ---------------------------------------------------------
inoremap <silent><expr> <CR>
\ !g:autocomplete_enabled
\ ? "<CR>"
\ : coc#pum#visible()
\ ? coc#pum#confirm()
\ : "<CR>"

" =========================================================
" CLANGD
" =========================================================
let g:coc_clangd_path = 'clangd'

" Linux g++ needs no MinGW query-driver.
let g:coc_clangd_args = [
\ '--background-index'
\ ]

" =========================================================
" TABS
" =========================================================
set showtabline=2
set guitablabel=%t%m

nnoremap <silent> <leader>tn :tabnew<CR>
nnoremap <silent> <leader>tx :tabclose<CR>
nnoremap <silent> <leader>tl :tabnext<CR>
nnoremap <silent> <leader>th :tabprevious<CR>
nnoremap <silent> <leader>to :tabonly<CR>

nnoremap <Tab> :tabnext<CR>
nnoremap <S-Tab> :tabprevious<CR>

nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt

nnoremap <leader>tf :tabedit
nnoremap <leader>ts :tab split<CR>

" =========================================================
" COMPILE
" =========================================================
nnoremap <silent> <F5> :w<CR>:call CompileRun()<CR>

function! CompileRun()
    write

    let l:file = expand("%:p")
    let l:ext = expand("%:e")
    let l:name = expand("%:r")

    if l:ext ==# "cpp"

        execute '!g++ -std=c++17 -O2 -pipe "' . l:file .
            \ '" -o "' . l:name . '" && "' . l:name . '"'

    elseif l:ext ==# "pas"

        execute '!fpc "' . l:file . '"'

    elseif l:ext ==# "py"

        execute '!python3 "' . l:file . '"'

    else

        echo "No compiler for ." . l:ext

    endif
endfunction

" =========================================================
" KEYBINDS HELP PAGE
" =========================================================
function! OpenKeybinds()

    let l:file = expand("~/.vim/KEYBINDS.md")

    let l:lines = [
    \ "# 🧠 VIM SETUP KEYBINDS",
    \ "",
    \ "==============================",
    \ "🌳 NERDTree",
    \ "==============================",
    \ "<leader>e → toggle tree",
    \ "<leader>n → focus file",
    \ "<leader>r → reset tree",
    \ "",
    \ "==============================",
    \ "⚡ fzf",
    \ "==============================",
    \ "<leader>p → files",
    \ "<leader>b → buffers",
    \ "",
    \ "==============================",
    \ "🔍 SEARCH",
    \ "==============================",
    \ "<leader>s → search in current file",
    \ "<leader>j → next match",
    \ "<leader>k → previous match",
    \ "<leader>q → close search",
    \ "",
    \ "==============================",
    \ "🚀 Compiler",
    \ "==============================",
    \ "F5 → compile & run",
    \ "",
    \ "==============================",
    \ "🧠 AUTOCOMPLETE",
    \ "==============================",
    \ ":CompleteOn → enable",
    \ ":CompleteOff → disable",
    \ "",
    \ "==============================",
    \ "⌨️ WINDOW CONTROL",
    \ "==============================",
    \ "Ctrl+w h/j/k/l → splits",
    \ "",
    \ "==============================",
    \ "📑 TABS",
    \ "==============================",
    \ "<leader>tn → new tab",
    \ "<leader>tx → close tab",
    \ "<leader>tl → next tab",
    \ "<leader>th → previous tab",
    \ "<leader>to → close other tabs",
    \ "",
    \ "<Tab> → next tab",
    \ "<Shift+Tab> → previous tab",
    \ "",
    \ "<leader>1-5 → jump tab number",
    \ "<leader>tf → open file in new tab",
    \ "<leader>ts → split into tab",
    \ "",
    \ "==============================",
    \ "🔍 ZOOM",
    \ "==============================",
    \ "+ / = → zoom in (GUI Vim)",
    \ "- → zoom out (GUI Vim)",
    \ "0 → reset zoom",
    \ "",
    \ "==============================",
    \ "🧠 BASIC MOVEMENT",
    \ "==============================",
    \ "h j k l → move cursor",
    \ "gg → top of file",
    \ "G → bottom of file",
    \ "w / b / e → word movement",
    \ "",
    \ "dd / yy / p → edit",
    \ "u → undo"
    \ ]

    call writefile(l:lines, l:file)
    execute "edit " . l:file

endfunction

command! Keybinds call OpenKeybinds()
