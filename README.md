# 🧠 Arch i3 + Vim Setup (ASUS N56VJ Edition)

Minimal, fast, and personal Linux setup focused on productivity, low resource usage, and full control.

This configuration is designed for:

* ⚡ Performance (low RAM / lightweight tools)
* 🧩 Simplicity (manual Arch, no bloated frameworks)
* 🎯 Productivity (keyboard-driven workflow)
* 💻 Development (C++, competitive programming, scripting)

---

## 📦 Overview

Main components:

* **WM:** i3
* **Terminal:** kitty
* **Editor:** GVim / Vim
* **Launcher:** rofi
* **File Manager:** thunar
* **Notifications:** dunst
* **Compositor:** picom
* **Shell tools:** fastfetch, git, pamixer

---

## ✨ Vim Configuration

This repo includes a custom Vim setup focused on speed and usability.

### 🔌 Plugins

* `gruvbox` — color scheme
* `NERDTree` — file explorer
* `fzf` + `fzf.vim` — fuzzy finder

### ⌨️ Keybinds

| Key         | Action                                |
| ----------- | ------------------------------------- |
| `<Space>`   | Leader key                            |
| `F5`        | Compile & run current file            |
| `:CP`       | Open competitive programming template |
| `:Keybinds` | Show custom keybindings               |

### ⚙️ Features

* Minimal UI
* Fast startup
* Manual workflow (no heavy autocomplete)
* C++ / Pascal / Python support via custom scripts

---

## ▶️ Compile & Run (F5)

Vim is configured to use external scripts:

* `run_cpp.bat`
* `run_pas.bat`

Make sure these exist and are in your PATH or configured correctly.

---

## 🖥️ i3 Setup

Key bindings:

| Key           | Action                |
| ------------- | --------------------- |
| `Mod + Enter` | Open terminal (kitty) |
| `Mod + D`     | Rofi launcher         |
| `Mod + E`     | Thunar                |
| `Mod + B`     | Firefox               |

### Startup Services

* `dex` (autostart)
* `xsettingsd`
* `blueman-applet`
* `nm-applet`
* `xfce4-power-manager`
* `dunst`
* `picom`

---

## 🎨 UI / Appearance

* Font: `JetBrainsMono Nerd Font`
* Theme: Dark minimal
* Rofi: custom theme with fuzzy matching
* Notifications: clean `dunst` setup
* Wallpaper system: dynamic via `feh + rofi`

---

## 🖱️ Input Configuration

* Touchpad (Elantech):

  * Natural scrolling enabled
* Mouse:

  * Acceleration disabled (raw input feel)

---

## 💾 Installation

Clone repo:

```bash
git clone https://github.com/TheHiperDev/arch-i3.git ~/.config
```

(Optional backup first)

```bash
mv ~/.config ~/.config.backup
```

---

## 🔄 Workflow

This setup is built around Git:

* Save config:

  ```bash
  git add .
  git commit -m "Update config"
  git push
  ```

* Restore config:

  ```bash
  rm -rf ~/.config
  git clone https://github.com/TheHiperDev/arch-i3.git ~/.config
  ```

---

## ⚠️ Notes

* This setup is **personal**, not plug-and-play.
* Some paths/scripts may need adjustment.
* Designed for Arch Linux (manual install).

---

## 🚀 Philosophy

> Keep it simple. Keep it fast. Keep it yours.

No bloated desktop environments.
No unnecessary abstractions.
Just a clean system you fully control.

---

## 📌 TODO

* [ ] Add `.gitignore`
* [ ] Document scripts (`run_cpp`, `run_pas`)
* [ ] Add screenshots
* [ ] Improve install script (optional)

---

## 👤 Author

Victor (TheHiperDev)

---

## ⭐ If you like it

Use it, modify it, break it, rebuild it.

That’s the point.

