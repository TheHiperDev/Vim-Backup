# HiperVim

Personal Vim configuration for Windows GVim and Linux.

The setup is mainly built around competitive programming, C++, and a simple keyboard-driven workflow. No IDE required, although there is nothing wrong with using one.

The goal is simple: keep the configuration in Git so it can be restored without having to rebuild everything from scratch.

## Features

- Gruvbox
- NERDTree
- fzf and fzf.vim
- CoC and clangd
- C++17 compile and run with F5
- Pascal and Python support
- `:CP` for the competitive programming template
- `:Keybinds` for the keybinding reference
- File search with `:S`
- Tab management
- GUI font zoom
- Git project root detection
- Autocomplete can be enabled or disabled

## Plugins

Managed with vim-plug:

- `morhetz/gruvbox`
- `preservim/nerdtree`
- `junegunn/fzf`
- `junegunn/fzf.vim`
- `neoclide/coc.nvim`
- `clangd/coc-clangd`

## Installation

### Linux

Clone the repository:

```bash
git clone https://github.com/TheHiperDev/Vim-Backup.git
cd Vim-Backup
```

Copy the Vim configuration:

```bash
cp .vimrc ~/.vimrc
```

Create the Vim directory if needed:

```bash
mkdir -p ~/.vim
```

Copy the competitive programming template:

```bash
cp cp_template.cpp ~/.vim/cp_template.cpp
```

Install vim-plug:

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Start Vim:

```bash
vim
```

Then install the plugins:

```vim
:PlugInstall
```

For C++ support, make sure `g++` and `clangd` are installed and available in `PATH`.

For Pascal and Python support, install `fpc` and `python3` if you need them.

### Windows

Clone the repository:

```cmd
git clone https://github.com/TheHiperDev/Vim-Backup.git
cd Vim-Backup
```

Copy `_vimrc` to the Vim configuration directory:

```cmd
copy _vimrc "%USERPROFILE%\_vimrc"
```

Install vim-plug:

```cmd
curl -fLo "%USERPROFILE%\vimfiles\autoload\plug.vim" --create-dirs ^
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Then open GVim and run:

```vim
:PlugInstall
```

The Windows configuration uses the existing `run_cpp.bat` and `run_pas.bat` scripts for compilation.

## Competitive Programming

The intended workflow is straightforward:

```text
open file
    |
    v
:CP
    |
    v
write solution
    |
    v
F5
    |
    v
compile and run
```

The Linux configuration uses:

```text
g++ -std=c++17 -O2 -pipe
```

The Windows configuration uses the local compiler scripts.

## Useful Commands

```text
:CP <file>          Open a file and insert the CP template if empty
:Keybinds           Open the keybinding reference
:CompleteOn         Enable autocomplete
:CompleteOff        Disable autocomplete
:S <text>           Search the current file
```

## Main Keybindings

```text
Space               Leader

F5                  Compile and run

<leader>e           Toggle NERDTree
<leader>n           Find current file in NERDTree
<leader>r           Reset NERDTree

<leader>p           Find files with fzf
<leader>b           Find buffers with fzf

<leader>s           Search
<leader>j           Next search result
<leader>k           Previous search result
<leader>q           Close search

<leader>tn          New tab
<leader>tx          Close tab
<leader>tl          Next tab
<leader>th          Previous tab
<leader>to          Close other tabs

<leader>1-5         Jump to tab

<Tab>               Next tab
<S-Tab>             Previous tab
```

Run `:Keybinds` inside Vim for the full list.

## Repository Structure

```text
Vim-Backup/
├── .vimrc              Linux configuration
├── _vimrc              Windows GVim configuration
├── cp_template.cpp     Competitive programming template
└── README.md
```

The plugin files themselves are not stored in the repository. Vim-plug downloads them when `:PlugInstall` is run.

## Restore

If the configuration gets messed up, remove the local configuration and copy it from the repository again.

### Linux

```bash
rm -f ~/.vimrc
cp .vimrc ~/.vimrc
```

### Windows

```cmd
del "%USERPROFILE%\_vimrc"
copy _vimrc "%USERPROFILE%\_vimrc"
```

Then run:

```vim
:PlugInstall
```

## Philosophy

Keep it simple.

Vim does the editing.  
The compiler does the compiling.  
Git keeps the configuration backed up.

There is no need to turn a text editor into an operating system.

## Author
 
TheHiperDev
