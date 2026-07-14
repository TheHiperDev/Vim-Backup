# 🧠 Vim Backup (Windows / GVim Setup)

Personal **GVim configuration for Windows** focused on:

* ⚡ Competitive Programming (C++)
* 🪶 Lightweight workflow (no heavy IDEs)
* ⌨️ Keyboard-driven editing
* 💾 Easy backup & restore via Git

This repo is a **portable Vim setup**, so if something breaks, you can restore everything instantly.

---

## ✨ Features

* 🎨 **Gruvbox color scheme**
* 🌲 **NERDTree** file explorer
* 🔍 **fzf + fzf.vim** fuzzy finder
* ⌨️ Custom keybindings (leader = `Space`)
* ⚡ **F5 compile & run system**
* 🧠 `:CP` command for competitive programming template
* 🪶 Fast and minimal (runs great on low-end machines)

---

## 📦 Plugins

Managed with **vim-plug**:

* `morhetz/gruvbox`
* `preservim/nerdtree`
* `junegunn/fzf`
* `junegunn/fzf.vim`

---

## ⚙️ Installation (Windows)

### 1. Clone the repo

```bash
git clone https://github.com/TheHiperDev/Vim-Backup.git
```

---

### 2. Copy config

Move `_vimrc` to:

```
C:\Users\YourUsername\Vim\_vimrc
```

---

### 3. Install vim-plug

Download:
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

Place it in:

```
C:\Users\YourUsername\vimfiles\autoload\plug.vim
```

(Create folders if they don’t exist)

---

### 4. Install plugins

Open **GVim**, then run:

```
:PlugInstall
```

---

## ⌨️ Keybindings

| Key               | Action                                  |
| ----------------- | --------------------------------------- |
| `Space`           | Leader key                              |
| `F5`              | Compile & run current file              |
| `:CP`             | Insert competitive programming template |
| `:NERDTreeToggle` | Toggle file explorer                    |

---

## ⚡ Compile & Run (F5)

The setup uses external scripts:

* `run_cpp.bat`
* `run_pas.bat`
* (optional) Python runner

Make sure:

* Scripts exist
* Paths inside them are correct
* Compilers (g++, fpc, python) are installed and in PATH

---

## 🧠 Competitive Programming Workflow

1. Open a `.cpp` file
2. Run `:CP` → insert template
3. Write solution
4. Press `F5` → compile & run instantly

Fast, simple, no IDE needed.

---

## 📁 Structure

```
Vim-Backup/
├── _vimrc
├── autoload/
├── plugged/
└── (plugin files)
```

---

## 🔄 Restore Setup

If your config breaks:

```bash
rm -rf %USERPROFILE%\vimfiles
del %USERPROFILE%\_vimrc
git clone https://github.com/TheHiperDev/Vim-Backup.git
```

Then repeat setup steps.

---

## 🧠 Philosophy

* Minimal > bloated IDEs
* Speed > fancy UI
* Keyboard > mouse
* Control > automation

---

## 🔒 Note

This is a **personal setup**, optimized for the author's workflow.
Feel free to adapt it to your needs.

---

## 👤 Author

**Victor (TheHiperDev)**
Competitive Programming + Vim user

---
