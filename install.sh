#This script will do the following things: 
#   1. Install packages and dependencies (i3-gaps, polybar, etc)
#   2. Copy all dotfiles to correct locations

# Please note that yay is used as the AUR helper to install packages from 
# AUR. Please comment out those lines for AUR installation if you use a 
# different AUR helper.

# Installing required packages using pacman 
pacman -S --needed --noconfirm - < install.txt

# Installing required packages from AUR using yay
sudo -u $SUDO_USER yay -S --needed --noconfirm - < aur.txt

# Installing vim-plug and the plugins (manages vim plugins)
sudo -u $SUDO_USER sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

sudo -u $SUDO_USER nvim +PlugInstall +qa

# i3
if [ -d "/home/$SUDO_USER/.config/i3" ]
then
    cp ./config/i3/config /home/$SUDO_USER/.config/i3/config
else 
    mkdir /home/$SUDO_USER/.config/i3
    cp ./config/i3/config /home/$SUDO_USER/.config/i3/config
fi

# neovim
if [ -d "/home/$SUDO_USER/.config/nvim" ]
then
    cp ./config/nvim/init.vim /home/$SUDO_USER/.config/nvim/init.vim
else 
    mkdir /home/$SUDO_USER/.config/nvim
    cp ./config/nvim/init.vim /home/$SUDO_USER/.config/nvim/init.vim
fi


# kitty
if [ -d "/home/$SUDO_USER/.config/kitty" ]
then
    cp ./config/kitty/kitty.conf /home/$SUDO_USER/.config/kitty/kitty.conf
else 
    mkdir /home/$SUDO_USER/.config/kitty
    cp ./config/kitty/kitty.conf /home/$SUDO_USER/.config/kitty/kitty.conf
fi

# polybar
if [ -d "/home/$SUDO_USER/.config/polybar" ]
then
    cp ./config/polybar/* /home/$SUDO_USER/.config/polybar/
else 
    cp -R ./config/polybar /home/$SUDO_USER/.config/
fi

# rofi
if [ -d "/home/$SUDO_USER/.config/rofi" ]
then
    cp ./config/rofi/* /home/$SUDO_USER/.config/rofi/
else 
    cp -R ./config/rofi /home/$SUDO_USER/.config/
fi

# zsh
cp ./zshrc /home/$SUDO_USER/.zshrc

# wallpaper
if [ -d "/home/$SUDO_USER/Downloads" ]
then
    cp ./mountains-1412683.jpg /home/$SUDO_USER/Downloads/mountains-1412683.jpg
else 
    mkdir /home/$SUDO_USER/Downloads
    cp ./mountains-1412683.jpg /home/$SUDO_USER/Downloads/mountains-1412683.jpg
fi

# change shell to zsh
sudo -u $SUDO_USER chsh -s $(which zsh)
