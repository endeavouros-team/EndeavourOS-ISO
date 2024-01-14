#!/bin/bash
#
# A template file for configuring the calamares installer.
# This will be called before starting calamares.
# The chosen install mode (offline or online) is the only parameter.
#
# To use this, add your required commands below.
# You may also "uncomment" any of the examples below, if needed.

install_mode="$1"     # value: 'offline' or 'online'

## Example 1: set KDE-Desktop as default.
# printf "\ndefault: KDE-Desktop\n" >> /etc/calamares/modules/packagechooser.conf

## Example 2: change the default filesystem from ext4 to btrfs in virtualbox VM.
# if [ "$(device-info --virtualbox)" = "yes" ] ; then
#     sed -i /etc/calamares/modules/partition.conf -E \
#         -e 's|^defaultFileSystemType:.*|defaultFileSystemType: "btrfs"|' \
#         -e 's|^(availableFileSystemTypes:.*)"ext4","btrfs"|\1"btrfs","ext4"|'
# fi
