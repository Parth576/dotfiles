#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
#PS1='[\u@\h \W]\$ '
PS1=$'\[\033[34m\]\u279C\[\033[37m\]\[\033[36m\]  \W \[\033[37m\]'
gitStatus=$(git symbolic-ref --short HEAD 2>/dev/null)

_checkGitStatus() {
    PS1=$'\[\033[34m\]\u279C\[\033[37m\]\[\033[36m\]  \W \[\033[37m\]'
    gitStatus=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [[ $gitStatus ]]; then
        PS1=$'\[\033[34m\]\u279C\[\033[37m\]\[\033[36m\]  \W \[\033[34m\]git:(\[\033[37m\]\[\033[31m\]$(git symbolic-ref --short HEAD 2>/dev/null)\[\033[37m\]\[\033[34m\])\[\033[37m\] \[\033[37m\]'
    fi
}

# create a PROPMT_COMMAND equivalent to store chpwd functions
# https://unix.stackexchange.com/questions/170279/can-i-hook-into-the-cd-command
typeset -g CHPWD_COMMAND=""

_chpwd_hook() {
  shopt -s nullglob

  local f

  # run commands in CHPWD_COMMAND variable on dir change
  if [[ "$PREVPWD" != "$PWD" ]]; then
    local IFS=$';'
    for f in $CHPWD_COMMAND; do
      "$f"
    done
    unset IFS
  fi
  # refresh last working dir record
  export PREVPWD="$PWD"
}

# add `;` after _chpwd_hook if PROMPT_COMMAND is not empty
PROMPT_COMMAND="_chpwd_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
CHPWD_COMMAND="${CHPWD_COMMAND:+$CHPWD_COMMAND;}_checkGitStatus"

gowords random -n 5

#if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]]
#then
#	exec fish
#fi
#export PATH=$PATH:"/home/parth/go/bin /usr/local/bin/go /home/parth/.cargo/bin /usr/local/sbin /usr/local/bin /usr/bin /usr/bin/site_perl /usr/bin/vendor_perl /usr/bin/core_perl"
export EDITOR=nvim
export GOPATH="$HOME/go"
alias vim="nvim"
alias gw="gowords search"
alias ll="exa --long --group-directories-first"
alias tree="exa --tree"
alias vmode="setxkbmap -option caps:swapescape"
alias nmode="setxkbmap -option"
source "$HOME/.cargo/env"
#set -o vi
# https://superuser.com/questions/1466222/move-vi-mode-string-to-end-of-bash-prompt
bind 'set editing-mode vi'
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'
bind 'set show-mode-in-prompt on'
bind 'set vi-ins-mode-string "\e[1;33mI\e[1m\e[1;37m  " '
bind 'set vi-cmd-mode-string "\e[1;31mN\e[1m\e[1;37m  " '

export PATH=/home/parth/bin:$PATH

[[ -e "/home/parth/lib/oracle-cli/lib/python3.9/site-packages/oci_cli/bin/oci_autocomplete.sh" ]] && source "/home/parth/lib/oracle-cli/lib/python3.9/site-packages/oci_cli/bin/oci_autocomplete.sh"
