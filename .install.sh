#!/bin/bash

# Basic 
sudo apt update -y
sudo apt upgrade -y

gnome-font-viewer Caskaydia\ Cove\ Nerd\ Font\ Complete\ Regular.otf
read nothing

# Github
echo "Enter Github address mail : "
read GitMail
echo "Enter Github name : "
read GitName

echo "Press only Enter"
ssh-keygen -t ed25519 -C "$GitMail"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

echo "Go to Github -> Settings -> SSH and GPG keys
-> [Paste the key] -> Add SSH key :"
sudo cat ~/.ssh/id_ed25519.pub
read nothing

sudo apt install -y curl
#Nodejs
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
sudo apt install -y npm

# Install global
sudo apt install git gcc g++ zsh vim feh light flameshot pulseaudio pulseaudio-utils ripgrep i3 libreoffice python3-pip firefox apache2 stow -y


# auto-cpufreq
sudo snap install auto-cpufreq

# snap install
sudo snap install discord
sudo snap install nvim --classic

# Git config final
git config --global user.mail "$GitMail"
git config --global user.name "$GitName"

#Dotnet
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update
sudo apt-get install -y dotnet-sdk-7.0
sudo apt-get install -y aspnetcore-runtime-7.0
sudo rm packages-microsoft-prod.deb

#Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH/plugins/zsh-autosuggestions
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/plugins/zsh-syntax-highlighting
sudo git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH/plugins/zsh-vi-mode

#Keyboard and Mouse
sudo mkdir -p /etc/X11/xorg.conf.d
sudo touch /etc/X11/xorg.conf.d/90-touchpad.conf
sudo chmod 777 /etc/X11/xorg.conf.d/90-touchpad.conf
sudo echo 'Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
EndSection' >> /etc/X11/xorg.conf.d/90-touchpad.conf
sudo chmod 755 /etc/X11/xorg.conf.d/90-touchpad.conf


stow --adopt */
git reset --hard
stow */

sudo apt autoremove -y

reboot
