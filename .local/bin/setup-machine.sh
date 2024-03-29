#!/bin/bash
#
# Sets up environment. Can be run multiple times.

if [[ "$(</proc/version)" == *[Mm]icrosoft* ]] 2>/dev/null; then
  readonly WSL=1
else
  readonly WSL=0
fi

# Install a bunch of debian packages.
function install_packages() {
  local packages=(
    apt-transport-https
    bzip2
    ca-certificates
    command-not-found
    curl
    git
    gnome-icon-theme
    gnupg
    gzip
    htop
    inetutils-traceroute
    jsonnet
    jq
    lsb-release
    nano
    openssh-server
    p7zip-full
    p7zip-rar
    perl
    python3
    python3-pip
    tree
    unrar
    unzip
    wget
    x11-utils
    zip
    zsh
  )

  if (( WSL )); then
    packages+=(dbus-x11)
  else
    packages+=(iotop docker.io)
  fi

  sudo apt-get update
  sudo bash -c 'DEBIAN_FRONTEND=noninteractive apt-get -o DPkg::options::=--force-confdef -o DPkg::options::=--force-confold upgrade -y'
  sudo apt-get install -y "${packages[@]}"
  sudo apt-get autoremove -y
  sudo apt-get autoclean
}

function install_docker() {
  if (( WSL )); then
    local release
    release="$(lsb_release -cs)"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu
      $release
      stable"
    sudo apt-get update -y
    sudo apt-get install -y docker-ce
  else
    sudo apt-get install -y docker.io
  fi
  sudo usermod -aG docker "$USER"
  pip3 install --user docker-compose
}

function install_brew() {
  local install
  install="$(mktemp)"
  curl -fsSLo "$install" https://raw.githubusercontent.com/Homebrew/install/master/install.sh
  bash -- "$install" </dev/null
  rm -- "$install"
}

# Install Visual Studio Code.
function install_vscode() {
  (( !WSL )) || return 0
  ! command -v code &>/dev/null || return 0
  local deb
  deb="$(mktemp)"
  curl -fsSL 'https://go.microsoft.com/fwlink/?LinkID=760868' >"$deb"
  sudo dpkg -i "$deb"
  rm -- "$deb"
}

function install_exa() {
  local v="0.10.1"
  ! command -v exa &>/dev/null || [[ "$(exa --version)" != *" v$v" ]] || return 0
  local tmp
  tmp="$(mktemp -d)"
  pushd -- "$tmp"
  curl -fsSLO "https://github.com/ogham/exa/releases/download/v${v}/exa-linux-x86_64-${v}.zip"
  unzip exa-linux-x86_64-${v}.zip
  sudo install -DT ./exa-linux-x86_64 /usr/local/bin/exa
  popd
  rm -rf -- "$tmp"
}

function install_bat() {
  local v="0.19.0"
  ! command -v bat &>/dev/null || [[ "$(bat --version)" != *" $v" ]] || return 0
  local deb
  deb="$(mktemp)"
  curl -fsSL "https://github.com/sharkdp/bat/releases/download/v${v}/bat_${v}_amd64.deb" > "$deb"
  sudo dpkg -i "$deb"
  rm "$deb"
}

function install_gh() {
  local v="2.5.1"
  ! command -v gh &>/dev/null || [[ "$(gh --version)" != */v"$v" ]] || return 0
  local deb
  deb="$(mktemp)"
  curl -fsSL "https://github.com/cli/cli/releases/download/v${v}/gh_${v}_linux_amd64.deb" > "$deb"
  sudo dpkg -i "$deb"
  rm "$deb"
}

function install_nuget() {
  (( WSL )) || return 0
  local v="5.8.1"
  ! command -v nuget.exe &>/dev/null || [[ "$(nuget.exe help)" != "NuGet Version: $v."* ]] || return 0
  local tmp
  tmp="$(mktemp -- ~/bin/nuget.exe.XXXXXX)"
  curl -fsSLo "$tmp" "https://dist.nuget.org/win-x86-commandline/v${v}/nuget.exe"
  chmod +x -- "$tmp"
  mv -- "$tmp" ~/bin/nuget.exe
}

function fix_locale() {
  sudo tee /etc/default/locale >/dev/null <<<'LC_ALL="C.UTF-8"'
}

# Avoid clock snafu when dual-booting Windows and Linux.
# See https://www.howtogeek.com/323390/how-to-fix-windows-and-linux-showing-different-times-when-dual-booting/.
function fix_clock() {
  (( !WSL )) || return 0
  timedatectl set-local-rtc 1 --adjust-system-clock
}

function win_install_fonts() {
  local dst_dir
  dst_dir="$(cmd.exe /c 'echo %LOCALAPPDATA%\Microsoft\Windows\Fonts' 2>/dev/null | sed 's/\r$//')"
  dst_dir="$(wslpath "$dst_dir")"
  mkdir -p "$dst_dir"
  local src
  for src in "$@"; do
    local file="$(basename "$src")"
    if [[ ! -f "$dst_dir/$file" ]]; then
      cp -f "$src" "$dst_dir/"
    fi
    local win_path
    win_path="$(wslpath -w "$dst_dir/$file")"
    # Install font for the current user. It'll appear in "Font settings".
    reg.exe add                                                 \
      'HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' \
      /v "${file%.*} (TrueType)" /t REG_SZ /d "$win_path" /f 2>/dev/null
  done
}

# Install a decent monospace font.
function install_fonts() {
  (( WSL )) || return 0
  win_install_fonts ~/.local/share/fonts/NerdFonts/*.ttf
}

function add_to_sudoers() {
  # This is to be able to create /etc/sudoers.d/"$username".
  if [[ "$USER" == *'~' || "$USER" == *.* ]]; then
    >&2 echo "$BASH_SOURCE: invalid username: $USER"
    exit 1
  fi

  sudo usermod -aG sudo "$USER"
  sudo tee /etc/sudoers.d/"$USER" <<<"$USER ALL=(ALL) NOPASSWD:ALL" >/dev/null
  sudo chmod 440 /etc/sudoers.d/"$USER"
}

function fix_dbus() {
  (( WSL )) || return 0
  sudo dbus-uuidgen --ensure
}

function with_dbus() {
  if [[ -z "${DBUS_SESSION_BUS_ADDRESS+X}" ]]; then
    dbus-launch "$@"
  else
    "$@"
  fi
}

# Set preferences for various applications.
function set_preferences() {

  if [[ -z "${DISPLAY+X}" ]]; then
    export DISPLAY=:0
  fi
}

if [[ "$(id -u)" == 0 ]]; then
  echo "$BASH_SOURCE: please run as non-root" >&2
  exit 1
fi

umask g-w,o-w

add_to_sudoers

install_packages
install_docker
install_brew
install_vscode
install_bat
install_gh
install_exa
install_nuget
install_fonts

enable_sshd

fix_locale
fix_clock
fix_shm
fix_dbus

set_preferences

echo SUCCESS
