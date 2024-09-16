#/bin/bash

# TODO: Remove yay-bin, yay-bin-debug
pacman -Qqe | grep --invert-match .*nvidia.* > ~/.config/pacman/pkglist.txt


