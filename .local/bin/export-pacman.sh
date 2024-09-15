#/bin/bash

pacman -Qqe | grep --invert-match .*nvidia.* > ~/.config/pacman/pkglist.txt


