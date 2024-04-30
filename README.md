[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

# :house: dotfiles-yadm

source: https://github.com/techie2000/dotfiles-yadm

## :information_source: About
My dotfiles as managed by yadm - https://yadm.io/

This dotfile repo uses the yadm tool (https://thelocehiliosan.github.io/yadm/docs/overview) in order to provision and configure dotfiles on a system.

## :floppy_disk: Usage/Installation

Prerequisite: yadm installation (https://yadm.io/docs/install)

### Get the Dotfiles onto the system
```
yadm clone git@github.com:techie2000/dotfiles-yadm.git
```

### If the clone results in warnings because of pre-existing dotfiles, overwrite the existing files.
```
yadm reset --hard HEAD
```

### Check for changes in your local dotfiles
As you use use system, you will ineevitably make changes that you may want back in the future; ID them with 
```
yadm diff
```

### Commit changes back to the repo
and  keep them under source control with
```
yadm add -u :/
yadm commit -m "The description of changes"
yadm push
```

## :star: Features

### XDG Base Directory Compliance

Dotfiles are organized to comply with [**XDG base directory specification**](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) as much as possible.

For more information, see [this](https://wiki.archlinux.org/index.php/XDG_Base_Directory) page on the [Arch Wiki](https://wiki.archlinux.org/).

### Bootstrap Script

[yadm](https://yadm.io/) has a built-in [**bootstrap**](https://yadm.io/docs/bootstrap) feature which enables further configuration of dotfiles.

The included bootstrap [script](../.config/yadm/bootstrap) will perform the following tasks:

* Install [applications](#applications-application).
  * If [**Xorg**](https://www.x.org/wiki/) is installed on the system, offer to install **GVim** instead.
  * If using Debian/Ubuntu, install [thefuck](https://github.com/nvbn/thefuck) using [`pip`](https://pip.pypa.io/) instead.
* Bootstrap [Zsh](#zsh).
  * Prepare Zsh configuration files and directory.
  * Make Zsh the default shell.
  * Add system-wide configuration of `$ZDOTDIR` in `/etc/zsh/zshenv`.
* Bootstrap [Vim](#vim).
  * Prepare Vim configuration files and directory.
  * Automatically install Vim [plugins](#plugin-manager-vim-plug).
* Install [fonts](#fonts) (optional).
* [Cleanup](#cleanup-home-directory) home directory (optional).

### Fonts

Fonts that include glyphs (icons) must be installed on the system to take full advantage of the [themed](#theme) Zsh prompt. Bootstrap script will therefor offer installation of the excellent [**Nerd Fonts**](https://github.com/ryanoasis/nerd-fonts).

Choose between the following font installatoin options:

1. **None**. Do not install any fonts.
2. **Basic**. Install only the [Source Code Pro](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/SourceCodePro.zip) font family.
3. **Complete**. Install the complete collection of **Nerd Fonts**.

Fonts will be installed in the `~/.local/share/fonts` directory.

### Cleanup Home Directory

Bootstrap script will scan the root of the home directory (`~/`) for known dotfiles. If any are found, script will prompt them for removal. See [XDG base directory compliance](#xdg-base-directory-compliance) for more information.

## :package: Applications
#to do: put this in a table and add in links descriptions 
* [**cargo**]:
* [**duf**]:
* [**flatpak**]: 
* [**git**](https://git-scm.com): Version control system (VCS).
* [**fzf**](https://github.com/junegunn/fzf): Command-line fuzzy finder.
* [**htop**]:
* [**iftop**]:
* [**iotop**]:
* [**mc**](https://github.com/MidnightCommander/mc): Terminal file manager.
* [**node-js-beautify**]:
* [**nq**]:
* [**postgresql**]:
* [**postgresql-client**]:
* [**postgresql-client-common**]:
* [**postgresql-contrib**]:
* [**ranger**](https://ranger.github.io/): Terminal file manager.
* [**The Fuck**](https://github.com/nvbn/thefuck): Corrects previous console command.
* [**tidy**]:
* [**Vim**](https://github.com/vim/vim): Terminal text editor.
* [**yamllint**]:
* [**Zsh**](http://zsh.sourceforge.net/Intro/intro_1.html): Preferred shell.

## :heart: Credits

Various files are based on, heavily influenced by, or down-right lifted from [pwyde's](https://github.com/pwyde/dotfiles)
