#!/bin/bash
#
# This file can contain commands that will be executed at the end of
# EndeavourOS install (online mode only) on the target system.
# The commands will be executed as root.
#
# This allows you to customize the installed system in several ways!
#
# If you add commands to this file, start the install process after
# saving this file.
#
# Tip: save your customized commands into a file on an internet server
# and fetch that file with command:
#
#     wget -O ~/user_commands.bash "URL-referring-the-file"
#
# Ideas for customization:
#   - install packages
#   - remove packages
#   - enable or disable system services
#   - writing dotfiles under $HOME
#   - etc.
#
# Example commands:
#
#     pacman -S --noconfirm --needed gufw geany chromium
#     pacman -Rsn --noconfirm xed
#     systemctl enable ufw
#
# There are some limitations to the commands:
#   - The 'pacman' commands mentioned above require option '--noconfirm',
#     otherwise the install process may hang because pacman waits for a
#     confirmation!
#   - Installing packages with 'yay' does not work because yay may not
#     be run as root.
#     The 'makepkg' command suffers from the same limitation.
#     This essentially blocks installing AUR packages here.
#
# Advanced tip:
# To write files directly into $HOME, you can find the new username
# with command
#     username=$(cat /tmp/new_username.txt)
# and then write files under folder
#     /home/$username
#

