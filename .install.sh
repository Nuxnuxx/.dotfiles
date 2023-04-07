#!/bin/bash

# Basic 
sudo apt update -y
sudo apt upgrade -y

# Github
cd ~
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

# Install global
sudo apt install git gcc g++ zsh curl vim feh light flameshot pulseaudio pulseaudio-utils ripgrep i3 libreoffice python3-pip firefox apache2 stow -y

#Nodejs
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs npm

# auto-cpufreq
sudo snap install auto-cpufreq
sudo auto-cpufreq --install

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

#Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sudo chsh -s /bin/zsh

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


# Delete contents of target directories before stowing
cd ~/.dotfiles
target_directories=($(find . -mindepth 2 -maxdepth 2 -type f -printf '%h\n' | sort -u))

# Delete the contents of the target directories
echo "Deleting contents of target directories"
for dir in "${target_directories[@]}"; do
  first_file=$(find "$dir" -type f | head -1)
  if [ -n "$first_file" ]; then
    real_dir=$(echo "$first_file" | sed -e "s|^\./||" -e "s|/[^/]*$||")
    if [ -d "$HOME/$real_dir" ]; then
      find "$HOME/$real_dir" -mindepth 1 -delete
    fi
  fi
done


#Font
mkdir -p ~/.local/share/fonts
cp ~/.dotfiles/Caskaydia\ Cove\ Nerd\ Font\ Complete\ Regular.otf ~/.local/share/fonts/
fc-cache -f -v

stow -R */

reboot
