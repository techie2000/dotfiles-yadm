# dotfiles-yadm

source: https://github.com/techie2000/dotfiles-yadm

My dotfiles as managed by yadm - https://yadm.io/

This dotfile repo uses the yadm tool (https://thelocehiliosan.github.io/yadm/docs/overview) in order to provision and configure dotfiles on a system.

## Usage

Prerequisite: yadm installation (https://thelocehiliosan.github.io/yadm/docs/install)

# Get the Dotfiles onto the system
yadm clone git@github.com:techie2000/dotfiles-yadm.git

# If the clone results in warnings because of pre-existing dotfiles, overwrite
#   the existing files.
yadm reset --hard HEAD

# Check for changes in your local dotfiles
yadm diff

# Commit changes back to the repo
yadm add -u :/
yadm commit -m "The description of changes"
yadm push

