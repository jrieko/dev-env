# vim: ft=sh:
# .zshrc
# John R. Ray <john@johnray.io>
# set -x
#

# Load Auto Completions
autoload -U compinit && compinit

# Show completion on first TAB
setopt menucomplete

# Allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## Keep background processes at full speed
#setopt NOBGNICE

## Restart running processes on exit
#setopt HUP

## History
setopt APPEND_HISTORY
setopt hist_ignore_all_dups

## Share history between zsh processes
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Never ever beep ever
setopt NO_BEEP

## Automatically decide when to page a list of completions
#LISTMAX=0

## Disable mail checking
#MAILCHECK=0

# Colors
autoload -U colors
colors
setopt prompt_subst

# RVM
#if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi

# Prompt
[[ -f ~/.promptline.sh ]] && source ~/.promptline.sh

# Automatically add our private key. See ssh-add
ssh-add ~/.ssh/Keys/*.priv > /dev/null 2>&1

# Set no proxy
export no_proxy='localhost,127.0.0.1,chef-server,gitlab-server,10.1.1.101'

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ChefDk
eval "$(chef shell-init bash)"

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Some more ls aliases
#alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
# sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Dot Aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

## Functions
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xjf $1 ;;
      *.tar.gz) tar xzf $1 ;;
      *.bz2) bunzip2 $1 ;;
      *.rar) unrar e $1 ;;
      *.gz) gunzip $1 ;;
      *.tar) tar xf $1 ;;
      *.tbz2) tar xjf $1 ;;
      *.tgz) tar xzf $1 ;;
      *.zip) unzip $1 ;;
      *.Z) uncompress $1 ;;
      *.7z) 7z x $1 ;;
      *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file" 
  fi
}

