#!/bin/bash
#
# Sets up environment. Can be run multiple times.

#####
##### reusable functions 
#####
function info() {
  tput setaf 4
  printf "==> $@\n"
  tput sgr0
}

function warning() {
  tput setaf 3
  tput bold
  printf "==> $@\n"
  tput sgr0
  sleep 0.5
}

function success() {
  tput setaf 2
  printf "==> $@\n"
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
    deborphan
    fzf
    gcc
    git
    gnome-icon-theme
    gnupg
    gpg
    gzip
    htop
    iotop
    inetutils-traceroute
    jsonnet
    jq
    jqp
    lsb-release
    make
    mc
    nano
    nodejs
    npm
    openssh-client
    openssh-server
    p7zip-full
    p7zip-rar
    perl
    python3
    python3-pip
    qemu-guest-agent
    shellcheck
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
  fi

  info "Updating apt..."

  sudo apt-get update

  # DEBIAN_FRONTEND=noninteractive: suppresses any interactive prompts, allowing the command to run without user intervention.
  # DPkg::options::=--force-confdef : resolve configuration file conflicts during package upgrades by using the package maintainer's version
  # DPkg::options::=--force-confold : resolve configuration file conflicts during package upgrades by keeping the current version of the configuration file
  # upgrade -y : perform a non-interactive upgrade of installed packages
  sudo bash -c 'DEBIAN_FRONTEND=noninteractive apt-get -o DPkg::options::=--force-confdef -o DPkg::options::=--force-confold upgrade -y' \
    && sudo apt dist-upgrade \
    && sudo apt autoremove \
    && sudo apt autoclean \
    && sudo apt clean

  for package in "${packages[@]}"; do
    
    if ! dpkg -s "$package" &> /dev/null; then
      info "Installing $package..."
      sudo apt-get install -y "$package"
    else
      success "$package is already installed"
    fi
  done

}

# Install a bunch of python packages.
function install_python_packages() {
  local packages=(
    hyfetch
  )

  info "Updating pip..."
  pip install --upgrade pip
  info "The following pip/python packages will be updated..."
  pip list --outdated
  pip list --outdated | awk '{print $1}' | tail -n +3 | xargs -n1 pip install -U

}

function install_go() {
  local package
  package="go"
  local latest_version
  latest_version=$(curl -s "https://go.dev/dl/" | grep -o 'href="[^"]*go[0-9]\+\.[0-9]\+\.[0-9]\+\.linux-amd64\.tar\.gz"' | sort -V | tail -n1 | sed 's/href="//' | sed 's/"$//' | sed 's#.*/##' | sed 's/go\([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/')  

  # Check if go is already installed
  if ! command -v $package &>/dev/null; then
    warning "$package is not currently installed."
  else
    local installed_version
    installed_version=$(go version 2>&1 | sed -E 's/[^0-9]+([0-9]+\.[0-9]+\.[0-9]+).*/\1/')

    # Compare versions
    if [[ "$installed_version" == "$latest_version" ]]; then
      success "$package is already up to date (version $latest_version)."
      return
    fi

    info "Installed $package version: $installed_version"

  fi

  info "The latest version of $package is $latest_version."

  read -r -p "Do you want to install the newer version? (y/n): " choice
  if [[ "$choice" == [Yy]* ]]; then
    warning "Installing $package $latest_version..."
    local target
    target="$(mktemp)"
    wget -O "$target" "https://go.dev/dl/go$latest_version.linux-amd64.tar.gz" \
      && sudo rm -rf /usr/local/go \
      warning "removing any remnants of previous versions if found" \
      && sudo tar -C /usr/local -xzf "$target" \
      && rm -- "$target" \
      && success "$package $latest_version has been installed."
  else
    warning "You chose not to install the newer version."
  fi
}

# Install a bunch of cargo packages.
function install_cargo_packages() {
  local packages=(
    gptcommit
    jless
  )

  local cargo_bin_dir="$HOME/.cargo/bin"  # Directory where Cargo binaries are installed

  for package in "${packages[@]}"; do
  
    # Check if the binary corresponding to the package is not in the PATH and not in cargo_bin_dir
    if ! command -v "$package" &>/dev/null && ! [ -x "$cargo_bin_dir/$package" ]; then
      info "Installing $package..."
      cargo install --locked "$package"
    else
      success "$package is already installed"
    fi
  
  done
  
}

function install_docker() {
  local package
  package="docker"

  if (( WSL )); then
    local release
    release="$(lsb_release -cs)"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu
      $release
      stable"
    package="docker-ce"      
    sudo apt-get update -y
    info "Installing $package..."
    sudo apt-get install -y "$package"
  else
    package="docker-io" 
    info "Installing $package..."
    sudo apt-get install -y "$package"
  fi
  info "Adding $USER to the docker group..."
  sudo usermod -aG docker "$USER"
  package="docker-compose"
  info "Installing $package..."
  pip3 install --user docker-compose
}

function install_brew() {
  local package
  package="brew"
  info "Installing $package..."
  local install
  install="$(mktemp)"
  curl -fsSLo "$install" https://raw.githubusercontent.com/Homebrew/install/master/install.sh
  bash -- "$install" </dev/null
  rm -- "$install"
}

# fnm = fast node manager
function install_fnm() {
  local package
  package="fnm"
  info "Installing $package..."
  local install
  install="$(mktemp)"
  curl -fsSL https://fnm.vercel.app/install > "$install"
  bash -- "$install" </dev/null
  rm -- "$install"
}

# nvm = node version manager
function install_nvm() {
  local package
  package="nvm"
  info "Installing $package..."
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
    info "Installing $package..."
    local install
    install="$(mktemp)"
    curl https://pyenv.run > "$install"
    bash -- "$install" </dev/null
    rm -- "$install"
  else
    success "$package is already installed"
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
    info "Installing $package..."
    local install
    install="$(mktemp)"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "$install"
    sh -- "$install" </dev/null
    rm -- "$install"
    echo
  else
    success "$package is already installed"
    info "Installing updates if available"
    $package update
  fi
}

# oh-my-zsh (manage zsh configurations)
function install_oh-my-zsh() {
  local package
  package="oh-my-zsh"
  
  if [[ ! -d "$HOME/.$package" ]]; then
    info "Installing $package..."
    local install
    install="$(mktemp)"
    curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh > "$install"
    sh "$install" </dev/null
    rm -- "$install"
    echo
  else
    success "$package is already installed"
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
      git clone https://github.com/zsh-users/"$plugin" "$plugin_path"
    else
      success "$plugin is already installed"
    fi
  done
}
 
# Install Visual Studio Code.
function install_vscode() {
  local package
  package="vscode"
  info "Installing $package..."
  (( !WSL )) || return 0
  ! command -v code &>/dev/null || return 0
  local deb
  deb="$(mktemp)"
  curl -fsSL 'https://go.microsoft.com/fwlink/?LinkID=760868' >"$deb"
  sudo dpkg -i "$deb"
  rm -- "$deb"
}

function install_eza() {
  local package
  package="eza"
  local latest_version
  latest_version="$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | jq -r '.tag_name')"

  # Check if eza is already installed
  if ! command -v $package &>/dev/null; then
    warning "$package is not currently installed."
  else
    local installed_version
    installed_version=$(eza --version | grep -oP 'v\d+(\.\d+)+')

    # Compare versions
    if [[ "$installed_version" == "$latest_version" ]]; then
      success "$package is already up to date (version $latest_version)."
      return
    fi

    info "Installed $package version: $installed_version"

  fi

  info "The latest version of $package is $latest_version."
  read -r -p "Do you want to install the newer version? (y/n): " choice
  if [[ "$choice" == [Yy]* ]]; then
    warning "Installing $package $latest_version..."
    local zip
    zip="$(mktemp)"
    curl -fsSL "https://github.com/eza-community/eza/releases/download/v${latest_version}/eza_x86_64-unknown-linux-gnu.zip" > "$zip"
    unzip "$zip"
    rm "$zip"
    sudo chmod +x eza
    sudo chown root:root eza
    sudo mv eza /usr/local/bin/eza
    success "$package $latest_version has been installed."
  else
    warning "You chose not to install the newer version."
  fi
}

function install_bat() {
  local package
  package="bat"
  local latest_version
  latest_version="$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | jq -r '.tag_name')"
  latest_version="${latest_version#v}" # Remove the leading 'v'

  # Check if bat is already installed
  if ! command -v bat &>/dev/null; then
    warning "$package is not currently installed."
  else
    local installed_version
    installed_version="$(bat --version | awk '{print $2}')"

    # Compare versions
    if [[ "$installed_version" == "$latest_version" ]]; then
      success "$package is already up to date (version $latest_version)."
      return
    fi

    info "Installed $package version: $installed_version"

  fi

  info "The latest version of $package is $latest_version."
  
  read -r -p "Do you want to install the newer version? (y/n): " choice
  if [[ "$choice" == [Yy]* ]]; then
    warning "Installing $package $latest_version..."
    local deb
    deb="$(mktemp)"
    curl -fsSL "https://github.com/sharkdp/bat/releases/download/v${latest_version}/bat_${latest_version}_amd64.deb" > "$deb"
    sudo dpkg -i "$deb"
    rm "$deb"
    success "$package $latest_version has been installed."
  else
    warning "You chose not to install the newer version."
  fi
}

function install_fd() {
  local package
  package="fd"
  local latest_version
  latest_version="$(curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | jq -r '.tag_name')"
  latest_version="${latest_version#v}" # Remove the leading 'v'

  # Check if fd is already installed
  if ! command -v fd &>/dev/null; then
    warning "$package is not currently installed."
  else
    local installed_version
    installed_version="$(fd --version | awk '{print $2}')"

    # Compare versions
    if [[ "$installed_version" == "$latest_version" ]]; then
      success "$package is already up to date (version $latest_version)."
      return
    fi

    info "Installed $package version: $installed_version"

  fi

  info "The latest version of $package is $latest_version."
  read -r -p "Do you want to install the newer version? (y/n): " choice
  if [[ "$choice" == [Yy]* ]]; then
    warning "Installing $package $latest_version..."
    local deb
    deb="$(mktemp)"
    curl -fsSL "https://github.com/sharkdp/fd/releases/download/v${latest_version}/fd_${latest_version}_amd64.deb" > "$deb"
    sudo dpkg -i "$deb"
    rm "$deb"
    success "$package $latest_version has been installed."
  else
    warning "You chose not to install the newer version."
  fi
}

function install_gh() {
  local package
  package="gh"
  local latest_version
  latest_version="$(curl -s https://api.github.com/repos/cli/cli/releases/latest | jq -r '.tag_name')"
  latest_version="${latest_version#v}" # Remove the leading 'v'

  # Check if gh is already installed or if the installed version matches the latest version
  if ! command -v gh &>/dev/null; then
    warning "$package is not currently installed."
  else
    local installed_version
    installed_version="$(gh --version | awk '{print $3}')"

    # Compare versions
    if [[ "$installed_version" == "$latest_version" ]]; then
      success "$package is already up to date (version $latest_version)."
      return
    fi

    info "Installed $package version: $installed_version"

  fi

  info "The latest version of $package is $latest_version." 
  read -r -p "Do you want to install the newer version? (y/n): " choice
  if [[ "$choice" == [Yy]* ]]; then
    warning "Installing $package $latest_version..."
    local deb
    deb="$(mktemp)"
    curl -fsSL "https://github.com/cli/cli/releases/download/v${latest_version}/gh_${latest_version}_linux_amd64.deb" > "$deb"
    sudo dpkg -i "$deb"
    rm "$deb"
    success "$package v$latest_version has been installed."
  else
    warning "You chose not to install the newer version."
  fi
}


function install_gh_desktop() {
    local package="github-desktop"
    local key_url="https://apt.packages.shiftkey.dev/gpg.key"
    local source_url="deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main"
    local source_local_file="/etc/apt/sources.list.d/shiftkey-packages.list"
    
    if ! command -v $package &>/dev/null; then
        warning "$package is not currently installed."
  
      # Check if running on a desktop environment
      if ! isDesktop; then
          warning "$package is a desktop application only. Server detected. $package will NOT be installed."
          return 1
      fi
  
      # Check if GPG key is installed
      if ! is_gpg_key_installed "$key_url"; then
          error "Failed to install GPG key for $package."
          return 1
      fi
  
      # Check if repository source is defined
      if ! is_repository_defined "$source_url" "$source_local_file"; then
          error "Failed to define repository source for $package."
          return 1
      fi
  
      # Install the package
      info "Installing $package..."
      if sudo apt update && sudo apt install -y github-desktop; then
          success "$package has been installed successfully."
          return 0
      else
          error "Failed to install $package."
          return 1
      fi
      
    else
      success "$package is already installed."
      return 0
    fi
}

function install_nuget() {
  local package
  package="nuget"
  info "Installing $package..."

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
    local file
    file="$(basename "$src")"
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
  local package
  package="fonts"
  info "Installing $package..."

  (( WSL )) || return 0
  win_install_fonts ~/.local/share/fonts/NerdFonts/*.ttf
}

function add_to_sudoers() {
  # This is to be able to create /etc/sudoers.d/"$username".
  if [[ "$USER" == *'~' || "$USER" == *.* ]]; then
    >&2 warning "$BASH_SOURCE: invalid username: $USER"
    exit 1
  fi

  info "Adding user $USER to sudoers..."

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

if [ "$(id -u)" -eq 0 ]; then
  warning "$BASH_SOURCE: please run as non-root" >&2
  exit 1
fi

enable_sshd() {
  # start service automatically on boot
  # Ubuntu/Debian : the SSH service is typically managed by the ssh service unit, not sshd, ulie centos/fedora which use sshd
  sudo systemctl enable ssh
}

umask g-w,o-w

add_to_sudoers

install_packages
install_python_packages
install_docker
install_node_extras
install_pyenv
install_rust
install_oh-my-zsh
install_oh-my-zsh_plugins
install_go
install_cargo_packages
install_brew
install_vscode
install_bat
install_fd
install_gh
install_gh_desktop
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

info "Let's add some github extensions"

gh extension install dlvhdr/gh-dash

success "SUCCESS - all finished"
