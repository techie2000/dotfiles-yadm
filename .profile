echo "**** $HOME/.profile **** starts ****"

# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n 2> /dev/null || true

echo "**** $HOME/.profile **** ends ****"
. "$HOME/.cargo/env"
