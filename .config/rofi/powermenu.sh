#!/usr/bin/env bash

# Menu options with clean spacing
lock="󰌾  Lock"
logout="󰗽  Logout"
suspend="󰤄  Suspend"
reboot="󰑐  Reboot"
shutdown="󰐥  Power Off"

options="$lock\n$logout\n$suspend\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | rofi -dmenu -i -theme ~/.config/rofi/powermenu.rasi -p "Power")"

case "$chosen" in
    "$lock")
        i3lock -c 000000
        ;;
    "$logout")
        i3-msg exit
        ;;
    "$suspend")
        # Void's native suspend utility (use ZZZ for hibernation)
        loginctl suspend 2>/dev/null || zzz
        ;;
    "$reboot")
        # Uses elogind/loginctl if available, otherwise falls back to system reboot
        loginctl reboot 2>/dev/null || sudo shutdown -r now
        ;;
    "$shutdown")
        # Uses elogind/loginctl if available, otherwise falls back to system poweroff
        loginctl poweroff 2>/dev/null || sudo shutdown -h now
        ;;
esac
