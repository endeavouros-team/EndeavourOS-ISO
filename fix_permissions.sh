#!/bin/bash

# For all folders
find ./airootfs -type d -exec chmod -R 755 {} \;
chown root:root -R ./airootfs
chmod 700 ./airootfs/root
chmod -R 700 airootfs/etc/sudoers.d
chmod 444 ./airootfs/etc/sudoers.d/g_wheel
chmod +x ./{mkarchiso,run_before_squashfs.sh}


