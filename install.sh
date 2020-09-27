#!/bin/bash
#This script will do the following things: 
#   1. Install packages and dependencies (i3-gaps, polybar, etc)
#   2. Copy all dotfiles to correct locations

# Please note that yay is used as the AUR helper to install packages from 
# AUR. Please comment out those lines for AUR installation if you use a 
# different AUR helper.

echo "\nWARNING : Say yes to this only if you have an absolute base install and have not yet set up xorg or a display manager\n"
read -p "Do you want to install xorg, xorg-xinit, lightdm, lightdm-gtk-greeter? (y/n) : " option

# Installing required packages using pacman 
echo "--------------- INSTALLING PACMAN PACKAGES --------------- \n"
pacman -S --needed --noconfirm - < install.txt

# Installing yay
echo "--------------- INSTALLING YAY (AUR HELPER) --------------- \n"
sudo -u $SUDO_USER git clone http://aur.archlinux.org/yay.git
sudo -u $SUDO_USER cp -r yay/. .
sudo -u $SUDO_USER makepkg --noconfirm -si

# installing xorg and lightdm and copying xinitrc based on option entered
echo "--------------- INSTALLING DISPLAY MANAGER --------------- \n"
if [[ $option = "y" ]]
then
    pacman -S --needed --noconfirm - < extras.txt
    # xinitrc
    sudo -u $SUDO_USER cp ./xinitrc /home/$SUDO_USER/.xinitrc
    systemctl enable lightdm.service
else 
    echo "Assuming you have that stuff installed, let's move ahead"
fi

# Installing required packages from AUR using yay
echo "--------------- INSTALLING AUR PACKAGES --------------- \n"
sudo -u $SUDO_USER yay -S --needed --noconfirm - < aur.txt

# Installing vim-plug and the plugins (manages vim plugins)
echo "--------------- INSTALLING NEOVIM PLUGINS --------------- \n"
sudo -u $SUDO_USER sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

sudo -u $SUDO_USER nvim --headless +PlugInstall +qall

echo "--------------- COPYING ALL CONFIGS --------------- \n"
# i3
if [ -d "/home/$SUDO_USER/.config/i3" ]
then
    sudo -u $SUDO_USER cp ./config/i3/config /home/$SUDO_USER/.config/i3/config
else 
    sudo -u $SUDO_USER mkdir /home/$SUDO_USER/.config/i3
    sudo -u $SUDO_USER cp ./config/i3/config /home/$SUDO_USER/.config/i3/config
fi

# neovim
if [ -d "/home/$SUDO_USER/.config/nvim" ]
then
    sudo -u $SUDO_USER cp ./config/nvim/init.vim /home/$SUDO_USER/.config/nvim/init.vim
else 
    sudo -u $SUDO_USER mkdir /home/$SUDO_USER/.config/nvim
    sudo -u $SUDO_USER cp ./config/nvim/init.vim /home/$SUDO_USER/.config/nvim/init.vim
fi


# kitty
if [ -d "/home/$SUDO_USER/.config/kitty" ]
then
    sudo -u $SUDO_USER cp ./config/kitty/kitty.conf /home/$SUDO_USER/.config/kitty/kitty.conf
else 
    sudo -u $SUDO_USER mkdir /home/$SUDO_USER/.config/kitty
    sudo -u $SUDO_USER cp ./config/kitty/kitty.conf /home/$SUDO_USER/.config/kitty/kitty.conf
fi

# polybar
if [ -d "/home/$SUDO_USER/.config/polybar" ]
then
    sudo -u $SUDO_USER cp ./config/polybar/* /home/$SUDO_USER/.config/polybar/
else 
    sudo -u $SUDO_USER cp -R ./config/polybar /home/$SUDO_USER/.config/
fi

# rofi
if [ -d "/home/$SUDO_USER/.config/rofi" ]
then
    sudo -u $SUDO_USER cp ./config/rofi/* /home/$SUDO_USER/.config/rofi/
else 
    sudo -u $SUDO_USER cp -R ./config/rofi /home/$SUDO_USER/.config/
fi

# zsh
cp ./zshrc /home/$SUDO_USER/.zshrc

# wallpaper
if [ -d "/home/$SUDO_USER/Downloads" ]
then
    sudo -u $SUDO_USER cp ./mountains-1412683.jpg /home/$SUDO_USER/Downloads/mountains-1412683.jpg
else 
    sudo -u $SUDO_USER mkdir /home/$SUDO_USER/Downloads
    sudo -u $SUDO_USER cp ./mountains-1412683.jpg /home/$SUDO_USER/Downloads/mountains-1412683.jpg
fi

# change shell to zsh
sudo -u $SUDO_USER chsh -s $(which zsh)
