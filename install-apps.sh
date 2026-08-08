#!/bin/bash

echo "🚀 Starting Third-Party Software Installation Suite..."

# Ensure system tool dependencies are present
sudo apt update && sudo apt install -y curl gpg wget

# ----------------------------------------------------
# 1. INSTALL VISUAL STUDIO CODE (Official Microsoft Repo)
# ----------------------------------------------------
if ! command -v code &> /dev/null; then
    echo "💻 Installing Visual Studio Code..."
    # Download Microsoft's signing key
    wget -qO- https://microsoft.com | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    # Add the official VS Code repository
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://microsoft.com stable main" > /etc/apt/sources.list.d/vscode.list'
    # Clean up key file and install
    rm -f packages.microsoft.gpg
    sudo apt update && sudo apt install -y code
else
    echo "✅ VS Code is already installed."
fi

# ----------------------------------------------------
# 2. INSTALL INTELLIJ IDEA (Official Snap Framework)
# ----------------------------------------------------
# JetBrains recommends Snaps on Ubuntu systems for easy sandboxed upgrades
if ! command -v intellij-idea-community &> /dev/null; then
    echo "☕ Installing IntelliJ IDEA Community Edition..."
    sudo snap install intellij-idea-community --classic
else
    echo "✅ IntelliJ IDEA is already installed."
fi

# ----------------------------------------------------
# 3. INSTALL GOOGLE CHROME (Official Google Repo)
# ----------------------------------------------------
if ! command -v google-chrome-stable &> /dev/null; then
    echo "🌐 Installing Google Chrome..."
    wget https://google.com
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb
else
    echo "✅ Google Chrome is already installed."
fi

echo "🎉 All web-managed software profiles are completely provisioned!"
