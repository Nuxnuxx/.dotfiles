#!/bin/bash

# Functions
install_package() {
    package=$1
    if ! dpkg -s "$package" &> /dev/null; then
        echo "Installing $package..."
        sudo apt install -y "$package"
    else
        echo "$package is already installed."
    fi
}

install_snap() {
    snap=$1
    classic=$2
    if ! snap list | grep -q "^$snap"; then
        echo "Installing $snap..."
        if [ "$classic" == "true" ]; then
            sudo snap install "$snap" --classic
        else
            sudo snap install "$snap"
        fi
    else
        echo "$snap is already installed."
    fi
}

install_zsh_plugin() {
    plugin_name=$1
    plugin_repo=$2
    plugin_path="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin_name"
    if [ ! -d "$plugin_path" ]; then
        echo "Installing $plugin_name..."
        git clone "$plugin_repo" "$plugin_path"
    else
        echo "$plugin_name is already installed."
    fi
}

# Update system
sudo apt update -y
sudo apt upgrade -y

# Install required packages
required_packages=("gnome-font-viewer" "curl" "wget" "git" "snapd" "stow")
for package in "${required_packages[@]}"; do
    install_package "$package"
done

# Display font
gnome-font-viewer Caskaydia\ Cove\ Nerd\ Font\ Complete\ Regular.otf
read -n1 -r -p "Press any key to continue..."

# SSH key setup
if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "No SSH key found, creating a new one."

    git_email=$(git config --global user.email)
    git_name=$(git config --global user.name)

    if [[ -z "$git_email" || -z "$git_name" ]]; then
        echo "Enter your GitHub email address:"
        read git_email
        echo "Enter your GitHub name:"
        read git_name
    fi

    echo "Press only Enter"
    ssh-keygen -t ed25519 -C "$git_email"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519

    echo "Go to Github -> Settings -> SSH and GPG keys
    -> [Paste the key] -> Add SSH key :"
    cat ~/.ssh/id_ed25519.pub
    read -n1 -r -p "Press any key to continue..."
fi

# Node.js
if ! grep -q "^deb .*nodesource" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "Adding Node.js repository..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
fi

# Install Node.js and npm
install_package "nodejs"
install_package "npm"

# Install packages
packages=("git" "gcc" "g++" "zsh" "vim" "feh" "light" "flameshot" "pulseaudio" "pulseaudio-utils" "ripgrep" "i3" "libreoffice" "python3-pip" "firefox" "apache2" "stow")
for package in "${packages[@]}"; do
    install_package "$package"
done

# Install auto-cpufreq
install_snap "auto-cpufreq"
install_snap "discord" "false"
install_snap "nvim" "true"

# Configure Git
git config --global user.email "$git_email"
git config --global user.name "$git_name"

# .NET
if ! grep -q "^deb .*packages-microsoft" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "Adding .NET repository..."
    wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    sudo rm packages-microsoft-prod.deb
    sudo apt update
fi

# Install .NET
install_package "dotnet-sdk-7.0"
install_package "aspnetcore-runtime-7.0"

# Install Oh-My-Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh-My-Zsh is already installed."
fi

# Install zsh plugins
zsh_plugins=("zsh-autosuggestions" "zsh-syntax-highlighting" "zsh-vi-mode")
zsh_plugin_repos=("https://github.com/zsh-users/zsh-autosuggestions.git" "https://github.com/zsh-users/zsh-syntax-highlighting.git" "https://github.com/jeffreytse/zsh-vi-mode")

for i in "${!zsh_plugins[@]}"; do
    install_zsh_plugin "${zsh_plugins[$i]}" "${zsh_plugin_repos[$i]}"
done

# Keyboard and Mouse
if [ ! -f /etc/X11/xorg.conf.d/90-touchpad.conf ]; then
    sudo mkdir -p /etc/X11/xorg.conf.d
    sudo bash -c 'cat > /etc/X11/xorg.conf.d/90-touchpad.conf <<- EOM
Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
EndSection
EOM'
fi

# Set Zsh as the default shell
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    chsh -s /usr/bin/zsh
    echo "Zsh has been set as the default shell. Please restart your terminal or computer for the changes to take effect."
else
    echo "Zsh is already the default shell."
fi

# Stow
stow --adopt */
git reset --hard
stow */

# Cleanup
sudo apt autoremove -y

echo "Script completed! Some changes may require restarting your terminal or computer to take effect."


