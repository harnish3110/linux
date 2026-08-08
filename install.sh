#!/bin/bash

echo "🚀 Starting Dark Theme Deployment Suite..."

# 1. Update system databases
sudo apt update && sudo apt upgrade -y

# 2. Add the Papirus PPA for modern Kvantum engines
echo "📦 Adding PPA repositories..."
sudo add-apt-repository ppa:papirus/papirus -y
sudo apt update

# 3. Install all your data-dense applications & tools
echo "📥 Installing application suite..."

sudo apt install -y \
    stow git wget unzip curl gpg \
    conky-all yakuake arc-theme \
    qt5-style-kvantum qt6-style-kvantum \
    fastfetch lsd bat btop htop ncurses-term \
    build-essential cmake gcc g++ make pkg-config \
    google-android-platform-tools-installer \
    gparted timeshift bleachbit keepassxc localsend rustdesk \
    filezilla remmina qbittorrent solaar p7zip-full net-tools \
    obs-studio kdenlive vlc mpv ffmpeg cheese ani-cli \
    steam-installer chromium-browser kando

# Flatpak Support
sudo apt install -y flatpak
sudo apt install -y gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Adding Coding Packages"
sudo apt install -y openjdk-17-jdk
sudo apt install -y openjdk-21-jdk
sudo apt install -y python3 python3-pip python3-netifaces python3-qrcode


# 4. Create custom aliases for naming conflicts (like batcat)
if ! grep -q "alias bat=" ~/.bashrc; then
    echo "🔧 Setting up command aliases..."
    echo "alias bat='batcat'" >> ~/.bashrc
fi

# 5. Download and inject Hack Nerd Font if it doesn't exist
if [ ! -d "$HOME/.local/share/fonts" ] || [ -z "$(fc-list | grep -i 'HackNerd')" ]; then
    echo "🔤 Downloading and caching Hack Nerd Font..."
    mkdir -p ~/.local/share/fonts
    #wget -q --show-progress https://github.com
    curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
    #unzip -q Hack.zip -d ~/.local/share/fonts/
    tar -xf JetBrainsMono.tar.xz -C ~/.local/share/fonts/
    rm JetBrainsMono.tar.xz
    fc-cache -fv
fi

# 6. Install Starship Shell Prompt
if ! command -v starship &> /dev/null; then
    echo "⭐ Installing Starship Prompt..."
    curl -sS https://starship.rs/install.sh | sh -- -y
fi

echo "✅ System environment is fully prepared!"
echo "👉 Run 'cd ~/dotfiles && stow conky && stow bash' to link configs."
