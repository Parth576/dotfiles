# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
export KEYTIMEOUT=1
setopt prompt_subst
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/parth/.zshrc'

export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/Projects/scripts
export EDITOR=/usr/bin/nvim
source $HOME/.zsh/plugins/completion.zsh

alias vim='nvim'
alias ls='ls --color --group-directories-first'
alias gs='gowords search'
alias gr='gowords random -n 10'
alias kp='keepassxc-cli open ~/Passwords.kdbx'
alias rss='$HOME/Downloads/Fluent.Reader.1.0.0.AppImage'
alias notes='$HOME/Downloads/Obsidian-0.11.13.AppImage'
alias vmode="setxkbmap -option caps:swapescape"
alias nmode="setxkbmap -option"

export VENV_HOME="$HOME/.venv"
[[ -d $VENV_HOME ]] || mkdir $VENV_HOME

venv() {
  if [ $# -eq 0 ]
    then
      echo "Please provide venv name"
    else
      source "$VENV_HOME/$1/bin/activate"
  fi
}

mkvenv() {
  if [ $# -eq 0 ]
    then
      echo "Please provide venv name"
    else
      python3 -m venv $VENV_HOME/$1
  fi
}

rmvenv() {
  if [ $# -eq 0 ]
    then
      echo "Please provide venv name"
    else
      rm -r $VENV_HOME/$1
  fi
}

listvenv() {
	myvar=$(ls $VENV_HOME)
	echo $myvar
}

lsvenv() {
    if [ $# -eq 0 ]
      then
        echo "Please provide venv name"
      else
        venv $1
        myvar=$(pip freeze)
        deactivate
        echo $myvar
    fi
}

#export TERM=xterm-256color

fpath+=$HOME/.zsh/pure

autoload -Uz compinit
compinit
#gowords random -n 10
autoload -U promptinit; promptinit
prompt pure
source $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# End of lines added by compinstall
