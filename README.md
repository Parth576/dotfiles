# dotfiles
As the repository name suggests, this is a collection of my dotfiles. I have also created an installation script to install the required programs and copy the files automatically (i3, zsh, polybar, neovim, dunst, rofi, kitty)

## Select the branch based on the config

* main `git checkout main`

  ![main](https://drive.google.com/uc?export=view&id=1EwK_5nkQ4oT3laNb8iO_nDxwK2AqJVvv)

* config2 `git checkout config2`
  
  ![config2](https://drive.google.com/uc?export=view&id=1ZAbG3Mho2gth4a6ND8D-3yDNGwPhePYN)

## Instructions to run the installation script 
**Note:** This installation script will only work on Arch Linux and Arch based distributions since packages are installed using pacman. Requires elevated privileges for installation of packages.
```bash
chmod +x install.sh
sudo ./install.sh
```

## Instructions to run update script
This script will only copy all the configs to the correct locations irrespective of the distro, can be used to switch between configs or update configs
```bash
chmod +x update.sh
./update.sh
```
