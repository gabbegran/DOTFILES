#!/bin/sh
# Derived from Manjaro Sway (https://github.com/manjaro-sway/manjaro-sway)
# Licensed under MIT License

case $1'' in
'status') 
    printf '{\"text\":\"%s\",\"tooltip\":\"%s\"}' "$(checkupdates | wc -l)" "$(checkupdates | awk 1 ORS='\\n' | sed 's/\\n$//')"
    ;;
'check')
    [ $(pacman checkupdates | wc -l) -gt 0 ]
    exit $?
    ;;
'upgrade')
    if [ -x "$(command -v pacseek)" ]; then
        exec alacritty --class floating_shell -T 'system upgrade' -e pacseek -u
    elif [ -x "$(command -v topgrade)" ]; then
        exec alacritty --class floating_shell -T 'system upgrade' -e topgrade
    elif [ -x "$(command -v pamac-manager)" ]; then
        exec alacritty --class floating_shell -T 'system upgrade' -e pamac-manager --updates
    else
        exec alacritty --class floating_shell -T 'system upgrade' -e pacman -Syu
    fi
    ;;
esac
