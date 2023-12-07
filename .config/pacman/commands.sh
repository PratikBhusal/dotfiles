#!/usr/bin/env sh

# List explicitly installed packages from AUR
pacman -Qqm > aur_packages.txt

# List explicitly installed packages not from AUR
pacman -Qqe | grep -v "$(pacman -Qqm)" > pacman_packages.txt

# # Install packages in pacman_packages.txt file
# pacman -S --needed $(grep -o '^[^#]*' pacman_packages.txt)

# # Install packages in pacman_packages.txt file
# yay -S --needed $(grep -o '^[^#]*' aur_packages.txt)
