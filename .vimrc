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

set encoding=utf-8
set fileencoding=utf-8

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
" UNDO HISTORY
" =========================================================
set undofile
set undodir=~/.vim/undo

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
" SEARCH / SCROLL CENTERING
" =========================================================
nnoremap n nzz
nnoremap N Nzz

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap <C-f> <C-f>zz
nnoremap <C-b> <C-b>zz

" =========================================================
" CP TEMPLATE
" =========================================================
let g:cp_template = expand('~/.vim/cp_template.cpp')

command! -nargs=1 CP call CpTemplate(<q-args>)

function! CpTemplate(path) abort
    let l:file = a:path

    " Relative paths behave like the Windows version:
    " resolve relative to the current working directory.
    if l:file !~# '^/'
        let l:file = getcwd() . '/' . l:file
    endif

    execute 'edit ' . fnameescape(l:file)

    " Insert CP template into an empty file
    if line('$') == 1 && getline(1) == ''
        if filereadable(g:cp_template)
            call setline(1, readfile(g:cp_template))
        else
            echoerr 'CP template not found: ' . g:cp_template
        endif
    endif

    normal! gg
endfunction

" =========================================================
" COC / AUTOCOMPLETE
" =========================================================

" CoC is COMPLETELY OFF when Vim starts.
let g:autocomplete_enabled = 0
let g:coc_start_at_startup = 0

" Completion popup settings
set completeopt=menuone,noselect
set shortmess+=c

" ---------------------------------------------------------
" CHECK BACKSPACE
" ---------------------------------------------------------
function! CheckBackspace() abort
    let l:col = col('.') - 1

    return !l:col || getline('.')[l:col - 1] =~# '\s'
endfunction

" ---------------------------------------------------------
" ENABLE AUTOCOMPLETE
" ---------------------------------------------------------
function! CompleteOn() abort
    let g:autocomplete_enabled = 1

    " Start CoC service
    silent! CocStart

    " Enable CoC event handling
    silent! CocEnable

    echo "Autocomplete: ON"
endfunction

command! CompleteOn call CompleteOn()

" ---------------------------------------------------------
" DISABLE AUTOCOMPLETE
" ---------------------------------------------------------
function! CompleteOff() abort
    let g:autocomplete_enabled = 0

    " Close any visible completion popup
    silent! call coc#pum#stop()

    " Disable CoC event handling
    silent! CocDisable

    echo "Autocomplete: OFF"
endfunction

command! CompleteOff call CompleteOff()

" ---------------------------------------------------------
" TAB
" ---------------------------------------------------------
inoremap <silent><expr> <TAB>
\ !g:autocomplete_enabled
\ ? "\<Tab>"
\ : coc#pum#visible()
\ ? coc#pum#next(1)
\ : CheckBackspace()
\ ? "\<Tab>"
\ : coc#refresh()

" ---------------------------------------------------------
" SHIFT + TAB
" ---------------------------------------------------------
inoremap <silent><expr> <S-TAB>
\ !g:autocomplete_enabled
\ ? "\<S-TAB>"
\ : coc#pum#visible()
\ ? coc#pum#prev(1)
\ : "\<C-h>"

" ---------------------------------------------------------
" ENTER
" ---------------------------------------------------------
inoremap <silent><expr> <CR>
\ !g:autocomplete_enabled
\ ? "\<CR>"
\ : coc#pum#visible()
\ ? coc#pum#confirm()
\ : "\<CR>"

" =========================================================
" CLANGD
" =========================================================
let g:coc_clangd_path = 'clangd'

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
" WINDOW CONTROL
" =========================================================

" Move between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize windows
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Equalize windows
nnoremap <silent> <leader>= <C-w>=

" =========================================================
" TERMINAL
" =========================================================
nnoremap <silent> <leader>tt :terminal<CR>

" Escape terminal mode
tnoremap <Esc> <C-\><C-n>

" =========================================================
" QUICK SAVE
" =========================================================
nnoremap <leader>w :w<CR>

" =========================================================
" WHITESPACE
" =========================================================
set listchars=tab:→\ ,trail:·

nnoremap <leader>l :set list!<CR>

" =========================================================
" RELOAD VIMRC
" =========================================================
nnoremap <leader>v :source $MYVIMRC<CR>

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
    \ "/pattern → search forward",
    \ "?pattern → search backward",
    \ "n → next search result",
    \ "N → previous search result",
    \ "* → search word under cursor",
    \ "# → search word backward",
    \ "",
    \ "==============================",
    \ "🚀 Compiler",
    \ "==============================",
    \ "F5 → compile & run",
    \ "",
    \ "==============================",
    \ "💻 CP Function",
    \ "==============================",
    \ ":CP <filename.cpp>",
    \ "",
    \ "==============================",
    \ "🧠 AUTOCOMPLETE",
    \ "==============================",
    \ ":CompleteOn → enable",
    \ ":CompleteOff → disable",
    \ "",
    \ "==============================",
    \ "🪟 WINDOW CONTROL",
    \ "==============================",
    \ "Ctrl+w s → horizontal split",
    \ "Ctrl+w v → vertical split",
    \ "Ctrl+w h/j/k/l → move between splits",
    \ "Ctrl+w H/J/K/L → move split position",
    \ "Ctrl+w w → cycle splits",
    \ "Ctrl+w q → close current split",
    \ "Ctrl+w = → equalize split sizes",
    \ "",
    \ "Ctrl+↑ → increase height",
    \ "Ctrl+↓ → decrease height",
    \ "Ctrl+← → decrease width",
    \ "Ctrl+→ → increase width",
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
    \ "📂 FILES / BUFFERS",
    \ "==============================",
    \ ":e <file> → open file",
    \ ":w → save",
    \ ":wa → save all",
    \ ":q → quit",
    \ ":q! → quit without saving",
    \ ":wq → save and quit",
    \ ":x → save and quit",
    \ ":bd → close buffer",
    \ ":ls → list buffers",
    \ ":bn → next buffer",
    \ ":bp → previous buffer",
    \ ":b <name> → switch buffer",
    \ "",
    \ "==============================",
    \ "💻 TERMINAL",
    \ "==============================",
    \ "<leader>tt → open terminal",
    \ ":terminal → open terminal",
    \ ":term → open terminal",
    \ ":!<command> → run shell command",
    \ "Esc → leave terminal mode",
    \ "",
    \ "Examples:",
    \ ":!ls → list files",
    \ ":!git status → git status",
    \ ":!g++ main.cpp → compile",
    \ "",
    \ "==============================",
    \ "✏️ EDITING",
    \ "==============================",
    \ "i → insert before cursor",
    \ "a → insert after cursor",
    \ "I → insert at line start",
    \ "A → insert at line end",
    \ "o → new line below",
    \ "O → new line above",
    \ "x → delete character",
    \ "dd → delete line",
    \ "D → delete to line end",
    \ "cc → change entire line",
    \ "C → change to line end",
    \ "r → replace character",
    \ "R → replace mode",
    \ "",
    \ "==============================",
    \ "📋 COPY / PASTE",
    \ "==============================",
    \ "yy → copy line",
    \ "yw → copy word",
    \ "p → paste after cursor",
    \ "P → paste before cursor",
    \ "dd → cut line",
    \ "",
    \ "==============================",
    \ "↩️ UNDO / REDO",
    \ "==============================",
    \ "u → undo",
    \ "Ctrl+r → redo",
    \ ". → repeat last change",
    \ "",
    \ "==============================",
    \ "🎯 VISUAL MODE",
    \ "==============================",
    \ "v → character selection",
    \ "V → line selection",
    \ "Ctrl+v → block selection",
    \ "y → copy selection",
    \ "d → delete selection",
    \ "c → change selection",
    \ "> → indent",
    \ "< → unindent",
    \ "",
    \ "==============================",
    \ "🧭 BASIC MOVEMENT",
    \ "==============================",
    \ "h j k l → move cursor",
    \ "w → next word",
    \ "b → previous word",
    \ "e → end of word",
    \ "0 → beginning of line",
    \ "^ → first non-space character",
    \ "$ → end of line",
    \ "gg → top of file",
    \ "G → bottom of file",
    \ "{ / } → previous / next paragraph",
    \ "Ctrl+d → half page down",
    \ "Ctrl+u → half page up",
    \ "Ctrl+f → full page down",
    \ "Ctrl+b → full page up",
    \ "",
    \ "==============================",
    \ "🔢 GOTO",
    \ "==============================",
    \ ":<line> → go to line",
    \ "gg → first line",
    \ "G → last line",
    \ "",
    \ "==============================",
    \ "🔧 COMMANDS",
    \ "==============================",
    \ ":help <topic> → Vim help",
    \ ":set number → enable line numbers",
    \ ":set nonumber → disable line numbers",
    \ ":syntax on → enable syntax highlighting",
    \ ":set paste → paste mode",
    \ ":set nopaste → disable paste mode",
    \ ":messages → show messages",
    \ ":version → Vim version",
    \ ":echo $PATH → show environment variable",
    \ ":pwd → show current directory",
    \ ":cd <dir> → change directory",
    \ "",
    \ "==============================",
    \ "🔍 ZOOM",
    \ "==============================",
    \ "+ / = → zoom in",
    \ "- → zoom out",
    \ "0 → reset zoom (12 default)",
    \ "",
    \ "==============================",
    \ "🧠 MACROS",
    \ "==============================",
    \ "q<register> → start recording",
    \ "q → stop recording",
    \ "@<register> → play macro",
    \ "@@ → repeat last macro",
    \ "",
    \ "Example:",
    \ "qa → record into register a",
    \ "q → stop recording",
    \ "@a → run macro",
    \ "",
    \ "==============================",
    \ "📌 MARKS",
    \ "==============================",
    \ "m<letter> → create mark",
    \ "'<letter> → jump to mark",
    \ "'' → jump to previous position",
    \ "",
    \ "==============================",
    \ "🧠 BASIC MODE CONTROL",
    \ "==============================",
    \ "Esc → Normal mode",
    \ "i → Insert mode",
    \ "v → Visual mode",
    \ ": → Command mode",
    \ "Ctrl+o → temporary Normal command from Insert",
    \ "",
    \ "==============================",
    \ "🔥 USEFUL",
    \ "==============================",
    \ "% → jump between matching brackets",
    \ "zz → center cursor on screen",
    \ "zt → cursor line to top",
    \ "zb → cursor line to bottom",
    \ ":noh → clear search highlighting",
    \ ":pwd → show current directory",
    \ ":cd <dir> → change directory",
    \ "",
    \ "==============================",
    \ "🛠️ VIM INFO",
    \ "==============================",
    \ ":checkhealth → check Vim setup",
    \ ":scriptnames → show loaded scripts",
    \ ":verbose map <key> → find key mapping",
    \ ":imap <key> → inspect Insert mapping",
    \ ":nmap <key> → inspect Normal mapping",
    \ "",
    \ "==============================",
    \ "⌨️ LEADER",
    \ "==============================",
    \ "Leader key = Space",
    \ "",
    \ "Space + e → NERDTree",
    \ "Space + n → focus file",
    \ "Space + r → reset tree",
    \ "Space + p → fzf files",
    \ "Space + b → buffers",
    \ "Space + s → search",
    \ "Space + j/k → next/previous search result",
    \ "Space + q → close search",
    \ "Space + w → save",
    \ "Space + tt → terminal",
    \ "Space + l → toggle whitespace",
    \ "Space + v → reload vimrc",
    \ "Space + tn → new tab",
    \ "Space + tx → close tab",
    \ "Space + tl/th → next/previous tab",
    \ "Space + to → close other tabs",
    \ "Space + 1-5 → jump tab",
    \ "Space + tf → open file in new tab",
    \ "Space + ts → split into tab",
    \ "Space + = → equalize windows",
    \ "",
    \ "==============================",
    \ "💡 REMEMBER",
    \ "==============================",
    \ "Most Vim commands start from Normal mode.",
    \ "Ctrl+w controls windows.",
    \ ": runs Ex commands.",
    \ ":! runs shell commands.",
    \ "Space is the Leader key."
    \ ]

    call writefile(l:lines, l:file)
    execute "edit " . l:file

endfunction

command! Keybinds call OpenKeybinds()
