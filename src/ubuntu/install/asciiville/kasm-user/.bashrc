source $STARTUPDIR/generate_container_user

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# TMP and TEMP are defined in the Windows environment.  Leaving
# them set to the default Windows temporary directory can have
# unexpected consequences.
unset TMP
unset TEMP

# Alternatively, set them to the Cygwin temporary directory
# or to any other tmp directory of your choice
# export TMP=/tmp
# export TEMP=/tmp

# Or use TMPDIR instead
export TMPDIR=/tmp

umask 022

# If you are running through a proxy service some external programs may need
# to know the proxy setting (e.g. gem). If so, configure and uncomment:
# export http_proxy=http://your.proxy.server.com:3128
# export no_proxy=alpha.wallhaven.cc

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
#HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=5000
HISTFILE=~/.bash_history

# ~/.bashrc: executed by bash(1) for non-login shells.
if [ $(echo $PATH | grep -c /usr/local/sbin) -ne "1" ]; then
  PATH="$PATH:/usr/local/bin:/usr/local/sbin"
fi
if [ $(echo $PATH | grep -c /usr/local/go/bin) -ne "1" ]; then
  PATH="$PATH:/usr/local/go/bin"
fi
if [ $(echo $PATH | grep -c /usr/games) -ne "1" ]; then
  PATH="$PATH:/usr/games"
fi
if [ $(echo $PATH | grep -c $HOME/go/bin) -ne "1" ]; then
  PATH="$PATH:$HOME/go/bin"
fi
if [ $(echo $PATH | grep -c $HOME/bin) -ne "1" ]; then
  PATH="$PATH:$HOME/bin"
fi
if [ $(echo $PATH | grep -c $HOME/.local/bin) -ne "1" ]; then
  PATH="$PATH:$HOME/.local/bin"
fi
export PATH

export VISUAL=vim
export EDITOR=$VISUAL

# enable terminal linewrap
setterm -linewrap on 2>/dev/null

# colorize man pages
man() {
  LESS_TERMCAP_mb=$'\e[1;32m' \
  LESS_TERMCAP_md=$'\e[1;32m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[01;33m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[1;4;31m' \
  command man "$@"
}

export LESSHISTFILE=-

# Set the location of the bat config file
export BAT_CONFIG_PATH="/etc/bat.conf"

# see /usr/share/doc/bash/examples/startup-files
# (in the package bash-doc) for examples

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return ;;
esac

# MEDIAROOT is used by doctorfree's Scripts to identify the media root
export MEDIAROOT=/share/media

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color | *-256color) color_prompt=yes ;;
  xterm*)
    export TERM=xterm-color
    color_prompt=yes
    ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \w:\[\033[00m\] \$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h \w: \$ '
fi
unset color_prompt force_color_prompt

PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm* | rxvt*)
    #   PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u: \w\a\]$PS1"
    PS1="\[\e]0;\w\a\]$PS1"
    ;;
  *) ;;
esac

if [ -f ~/.aliases ]; then
  . ~/.aliases
fi

if [ -f ~/.functions ]; then
  . ~/.functions
fi

if [ -f ~/.private ]; then
  . ~/.private
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Kitty bash completions
# source <(kitty + complete setup bash)

if command -v zoxide > /dev/null; then
  eval "$(zoxide init bash)"
fi

[ -d "$HOME/.nvm" ] && {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}
