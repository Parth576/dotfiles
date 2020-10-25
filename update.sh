#!/bin/bash

# i3
if [ -d "$HOME/.config/i3" ]
then
    cp ./config/i3/config $HOME/.config/i3/config
else 
    mkdir $HOME/.config/i3
    cp ./config/i3/config $HOME/.config/i3/config
fi

# neovim
if [ -d "$HOME/.config/nvim" ]
then
    cp ./config/nvim/init.vim $HOME/.config/nvim/init.vim
else 
    mkdir /home/$SUDO_USER/.config/nvim
    cp ./config/nvim/init.vim $HOME/.config/nvim/init.vim
fi

nvim --headless +PlugInstall +qa

# kitty
if [ -d "$HOME/.config/kitty" ]
then
    cp ./config/kitty/kitty.conf $HOME/.config/kitty/kitty.conf
else 
    mkdir /home/$SUDO_USER/.config/kitty
    cp ./config/kitty/kitty.conf $HOME/.config/kitty/kitty.conf
fi

# polybar
if [ -d "$HOME/.config/polybar" ]
then
    cp ./config/polybar/* $HOME/.config/polybar/
else 
    cp -R ./config/polybar $HOME/.config/
fi

# rofi
if [ -d "$HOME/.config/rofi" ]
then
    cp ./config/rofi/* $HOME/.config/rofi/
else 
    cp -R ./config/rofi $HOME/.config/
fi

# picom
if [ -d "$HOME/.config/picom" ]
then
    cp ./config/picom/picom.conf $HOME/.config/picom/picom.conf
else 
    mkdir /home/$SUDO_USER/.config/picom
    cp ./config/picom/picom.conf $HOME/.config/picom/picom.conf
fi

# zsh
cp ./zshrc $HOME/.zshrc

# wallpaper
if [ -d "$HOME/Downloads" ]
then
    cp ./wallpaper.png $HOME/Downloads/wallpaper.png
else 
    mkdir $HOME/Downloads
    cp ./wallpaper.png $HOME/Downloads/wallpaper.png
fi

