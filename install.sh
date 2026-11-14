#!/bin/bash

# Install python-nautilus
echo "Installing python-nautilus..."
if type "pacman" > /dev/null 2>&1
then
    pacman -Qi python-nautilus &> /dev/null
    if [ `echo $?` -eq 1 ]
    then
        sudo pacman -S --noconfirm python-nautilus
    else
        echo "python-nautilus is already installed"
    fi
elif type "apt-get" > /dev/null 2>&1
then
    package_name="python-nautilus"
    found_package=$(apt-cache search --names-only "$package_name")
    if [ -z "$found_package" ]
    then
        package_name="python3-nautilus"
    fi

    installed=$(apt list --installed "$package_name" -qq 2> /dev/null)
    if [ -z "$installed" ]
    then
        sudo apt-get install -y "$package_name"
    else
        echo "$package_name is already installed."
    fi
elif type "dnf" > /dev/null 2>&1
then
    installed=$(dnf list --installed nautilus-python 2> /dev/null)
    if [ -z "$installed" ]
    then
        sudo dnf install -y nautilus-python
    else
        echo "nautilus-python is already installed."
    fi
else
    echo "Failed to find python-nautilus, please install it manually."
fi

echo "Removing previous version (if found)..."
mkdir -p ~/.local/share/nautilus-python/extensions
rm -f ~/.local/share/nautilus-python/extensions/file-roller-nautilus.py

echo "Downloading newest version..."
wget -q -O ~/.local/share/nautilus-python/extensions/file-roller-nautilus.py https://raw.githubusercontent.com/PocketMiner82/file-roller-nautilus/main/file-roller-nautilus.py

echo "Restarting nautilus..."
nautilus -q

echo "Installation Complete"
