#!/bin/bash
#
# Sets up environment. Can be run multiple times.

#####
##### reusable functions 
#####
function info() {
  tput setaf 4
  echo -n "$@"
  tput sgr0
}

function warning() {
  tput setaf 3
  tput bold
  echo -n "$@"
  tput sgr0
  sleep 0.5
}

function success() {
  tput setaf 2
  echo -n "$@"
  tput sgr0
}
#####
##### reusable functions ends
#####


if [[ "$(</proc/version)" == *[Mm]icrosoft* ]] 2>/dev/null; then
  readonly WSL=1
else
  readonly WSL=0
fi

# Install a bunch of debian packages.
function install_packages() {
  local packages=(
    apt-transport-https
    build-essential
    bzip2
    ca-certificates
    command-not-found
    curl
    git
    gnome-icon-theme
    gnupg
    gpg
    gzip
    htop
    inetutils-traceroute
    jsonnet
    jq
    lsb-release
    nano
    nodejs
    npm
    openssh-server
    p7zip-full
    p7zip-rar
    perl
    python3
    python3-pip
    qemu-guest-agent
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

  echo
  info "Updating apt...\n"
  sudo apt-get update
  echo
  sudo bash -c 'DEBIAN_FRONTEND=noninteractive apt-get -o DPkg::options::=--force-confdef -o DPkg::options::=--force-confold upgrade -y'

  for package in "${packages[@]}"; do
    
    if ! command -v "$package" > /dev/null 2>&1; then
      echo
      info "Installing $package...\n"
      echo
      sudo apt-get install -y "$package"
    else
      echo
      success "$package is already installed\n"
      echo
    fi
  done
  
  echo
  info "Cleaning up apt...\n"
  sudo apt-get autoremove -y
  sudo apt-get autoclean
  echo
}

# Install a bunch of cargo packages.
function install_cargo_packages() {
  local packages=(
    gptcommit
  )

  local cargo_bin_dir="$HOME/.cargo/bin"  # Directory where Cargo binaries are installed

  for package in "${packages[@]}"; do
  
    # Check if the binary corresponding to the package is not in the PATH and not in cargo_bin_dir
    if ! command -v "$package" &>/dev/null && ! [ -x "$cargo_bin_dir/$package" ]; then
      echo
      info "Installing $package..."
      echo
      cargo install --locked "$package"
    else
      echo
      success "$package is already installed"
      echo
    fi
  
  done
  
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

# fnm = fast node manager
function install_fnm() {
  local install
  install="$(mktemp)"
  curl -fsSL https://fnm.vercel.app/install > "$install"
  bash -- "$install" </dev/null
  rm -- "$install"
}

# nvm = node version manager
function install_nvm() {
  local install
  install="$(mktemp)"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh > "$install"
  bash -- "$install" </dev/null
  rm -- "$install"
}

install_node_extras() {
  install_fnm
  install_nvm
}

# pyenv = python version manager
function install_pyenv() {
  local package
  package="pyenv"
  
  if ! command -v $package > /dev/null 2>&1; then
    echo
    info "Installing $package...\n"
    echo
    local install
    install="$(mktemp)"
    curl https://pyenv.run > "$install"
    bash -- "$install" </dev/null
    rm -- "$install"
  else
    echo
    success "$package is already installed\n"
    info "Installing updates if available"
    $package update
    echo
  fi
}

# Install Rust
function install_rust() {
  local package
  package="rustup"

  if ! command -v $package > /dev/null 2>&1; then
    echo
    info "Installing $package...\n"
    echo
    local install
    install="$(mktemp)"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "$install"
    sh -- "$install" </dev/null
    rm -- "$install"
  else
    echo
    success "$package is already installed\n"
    info "Installing updates if available\n"
    $package update
    echo
  fi
}

# oh-my-zsh (manage zsh configurations)
function install_oh-my-zsh() {
  local package
  package="oh-my-zsh"
  
  if [[ ! -d "$HOME/.$package" ]]; then
    echo
    info "Installing $package...\n"
    echo
    local install
    install="$(mktemp)"
    curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh > "$install"
    sh "$install" </dev/null
    rm -- "$install"
  else
    echo
    success "$package is already installed\n"
  fi
}

# Install a bunch of oh-my-zsh plugins.
function install_oh-my-zsh_plugins() {
  local plugins=(
    zsh-completions
    zsh-autosuggestions
    zsh-syntax-highlighting
  )

  for plugin in "${plugins[@]}"; do
    plugin_path="${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}/plugins/$plugin"
    if [[ ! -d $plugin_path ]]; then
      info "Installing $plugin..."
      echo
      git clone https://github.com/zsh-users/"$plugin" "$plugin_path"
    else
      success "$plugin is already installed"
      echo
    fi
  done
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

function install_eza() {
  local latest_version
  latest_version="$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | jq -r '.tag_name')"
  latest_version="${latest_version#v}" # Remove the leading 'v'

  # Check if eza is already installed
  if ! command -v eza &>/dev/null; then
    echo "eza is not currently installed."
  else
    local installed_version
    installed_version="$(eza --version | awk '{print $2}')"

    # Compare versions
    if [[ "$installed_version" == "$latest_version" ]]; then
      echo "eza is already up to date (version $latest_version)."
      return
    fi

    echo "Installed eza version: $installed_version"
  fi

  echo "The latest version of eza is $latest_version."
  read -p "Do you want to install the newer version? (y/n): " choice
  if [[ "$choice" == [Yy]* ]]; then
    local zip
    zip="$(mktemp)"
    curl -fsSL "https://github.com/eza-community/eza/releases/download/v${latest_version}/eza_x86_64-unknown-linux-gnu.zip" > "$zip"
    unzip "$zip"
    rm "$zip"
    sudo chmod +x eza
    sudo chown root:root eza
    sudo mv eza /usr/local/bin/eza
    echo "eza $latest_version has been installed."
  else
    echo "You chose not to install the newer version."
  fi
}

function install_bat() {
  local latest_version
  latest_version="$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | jq -r '.tag_name')"
  latest_version="${latest_version#v}" # Remove the leading 'v'

  # Check if bat is already installed
  if ! command -v bat &>/dev/null; then
    echo "bat is not currently installed."
  else
    local installed_version
    installed_version="$(bat --version | awk '{print $2}')"

    # Compare versions
    if [[ "$installed_version" == "$latest_version" ]]; then
      echo "bat is already up to date (version $latest_version)."
      return
    fi

    echo "Installed bat version: $installed_version"
  fi

  echo "The latest version of bat is $latest_version."
  read -p "Do you want to install the newer version? (y/n): " choice
  if [[ "$choice" == [Yy]* ]]; then
    local deb
    deb="$(mktemp)"
    curl -fsSL "https://github.com/sharkdp/bat/releases/download/v${latest_version}/bat_${latest_version}_amd64.deb" > "$deb"
    sudo dpkg -i "$deb"
    rm "$deb"
    echo "bat $latest_version has been installed."
  else
    echo "You chose not to install the newer version."
  fi
}

function install_gh() {
  local latest_version
  latest_version="$(curl -s https://api.github.com/repos/cli/cli/releases/latest | jq -r '.tag_name')"
  latest_version="${latest_version#v}" # Remove the leading 'v'

  # Check if gh is already installed or if the installed version matches the latest version
  if ! command -v gh &>/dev/null; then
    echo "gh is not currently installed."
  else
    local installed_version
    installed_version="$(gh --version | awk '{print $3}')"

    # Compare versions
    if [[ "$installed_version" == "$latest_version" ]]; then
      echo "gh is already up to date (version $latest_version)."
      return
    fi

    echo "Installed gh version: $installed_version"
  fi

  echo "The latest version of gh is $latest_version."
  read -p "Do you want to install the newer version? (y/n): " choice
  if [[ "$choice" == [Yy]* ]]; then
    local deb
    deb="$(mktemp)"
    curl -fsSL "https://github.com/cli/cli/releases/download/v${latest_version}/gh_${latest_version}_linux_amd64.deb" > "$deb"
    sudo dpkg -i "$deb"
    rm "$deb"
    echo "gh v$latest_version has been installed."
  else
    echo "You chose not to install the newer version."
  fi
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
install_node_extras
install_pyenv
install_rust
install_oh-my-zsh
install_oh-my-zsh_plugins
install_cargo_packages
install_brew
install_vscode
install_bat
install_gh
install_eza
install_nuget # WSL only
install_fonts # WSL only

enable_sshd

fix_locale
fix_clock
fix_shm
fix_dbus

set_preferences

info "Let's sort github authentication..."
gh auth login
echo
info "Let's add some github extensions"
gh extension install dlvhdr/gh-dash
echo

success "SUCCESS - all finished"
