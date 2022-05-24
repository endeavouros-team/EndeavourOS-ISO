#!/usr/bin/env bash

# Made by Fernando "maroto"
# Run anything in the filesystem right before being "mksquashed"
# ISO-NEXT specific cleanup removals and additions (08-2021 + 10-2021) @killajoe and @manuel
# refining and changes november 2021 @killajoe and @manuel

script_path=$(readlink -f "${0%/*}")
work_dir="work"

# Adapted from AIS. An excellent bit of code!
# all pathes must be in quotation marks "path/to/file/or/folder" for now.

arch_chroot() {
    arch-chroot "${script_path}/${work_dir}/x86_64/airootfs" /bin/bash -c "${1}"
}

do_merge() {

arch_chroot "$(cat << EOF

echo "##############################"
echo "# start chrooted commandlist #"
echo "##############################"

cd "/root"

# Init & Populate keys
pacman-key --init
pacman-key --populate archlinux endeavouros

# Install liveuser skel (in case of conflicts use overwrite)
pacman -U --noconfirm --overwrite "/etc/skel/.bash_profile","/etc/skel/.bashrc" -- "/root/endeavouros-skel-liveuser/"*".pkg.tar.zst"

# Prepare livesession settings and user
sed -i 's/#\(en_US\.UTF-8\)/\1/' "/etc/locale.gen"
locale-gen
ln -sf "/usr/share/zoneinfo/UTC" "/etc/localtime"

# Set root permission and shell
usermod -s /usr/bin/bash root

# Create liveuser
useradd -m -p "" -g 'liveuser' -G 'sys,rfkill,wheel,uucp,nopasswdlogin,adm,tty' -s /bin/bash liveuser

# Remove liveuser skel to then install user skel
pacman -Rns --noconfirm -- "endeavouros-skel-liveuser"
rm -rf "/root/endeavouros-skel-liveuser"

# Root qt style for Calamares
mkdir "/root/.config"
cp -Rf "/home/liveuser/.config/"{"Kvantum","qt5ct"} "/root/.config/"

# Add builddate to motd:
cat "/usr/lib/endeavouros-release" >> "/etc/motd"
echo "------------------" >> "/etc/motd"

# Fix configurations
sed -i 's/#\(PermitRootLogin \).\+/\1yes/' "/etc/ssh/sshd_config"
# archiso now has a /airootfs/etc/systemd/journald.conf.d/volatile-storage.conf
#sed -i 's/#\(Storage=\)auto/\1volatile/' "/etc/systemd/journald.conf"
# archiso now has /airootfs/etc/systemd/logind.conf.d/do-not-suspend.conf
#sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' "/etc/systemd/logind.conf"
#sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' "/etc/systemd/logind.conf"
#sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' "/etc/systemd/logind.conf"

# Enable systemd services
systemctl enable NetworkManager.service systemd-timesyncd.service bluetooth.service firewalld.service
systemctl enable vboxservice.service vmtoolsd.service vmware-vmblock-fuse.service
systemctl set-default multi-user.target

# Revert from arch-iso preset to default preset
cp -rf "/usr/share/mkinitcpio/hook.preset" "/etc/mkinitcpio.d/linux.preset"
sed -i 's?%PKGBASE%?linux?' "/etc/mkinitcpio.d/linux.preset"

# Patching EndeavourOS specific grub config
patch -u "/etc/default/grub" -i "/root/grub.patch"
rm "/root/grub.patch"

# Patching mkinitcpio.conf
patch -u "mkinitcpio.conf" -i "/root/mkinitcpio.patch"
cp "mkinitcpio.conf" "/etc/"
rm "mkinitcpio.conf" "/root/mkinitcpio.patch"

# Remove unneeded grub stuff from /boot
# rm "/boot/grub/grub.cfg" #archiso does not create it anymore
rm -R "/boot/syslinux"
rm -R "/boot/memtest86+"
rm "/boot/amd-ucode.img"
rm "/boot/initramfs-linux.img"
rm "/boot/intel-ucode.img"
rm "/boot/vmlinuz-linux"

# Install locally builded packages on ISO (place packages under airootfs/root/packages)
pacman -U --noconfirm -- "/root/packages/"*".pkg.tar.zst"
rm -rf "/root/packages/"

# Set wallpaper for live-session and original for installed system
mv "endeavouros-wallpaper.png" "/etc/calamares/files/endeavouros-wallpaper.png"
mv "/root/livewall.png" "/usr/share/endeavouros/backgrounds/endeavouros-wallpaper.png"
chmod 644 "/usr/share/endeavouros/backgrounds/"*".png"
rm -rf "/usr/share/backgrounds/xfce/xfce-verticals.png"
ln -s "/usr/share/endeavouros/backgrounds/endeavouros-wallpaper.png" "/usr/share/backgrounds/xfce/xfce-verticals.png"


# TEMPORARY CUSTOM FIXES

# Fix for getting bash configs installed
cp -af "/home/liveuser/"{".bashrc",".bash_profile"} "/etc/skel/"

# Move blacklisting nouveau out of ISO (copy back to target for offline installs)
mv "/usr/lib/modprobe.d/nvidia-utils.conf" "/etc/calamares/files/nv-modprobe"
mv "/usr/lib/modules-load.d/nvidia-utils.conf" "/etc/calamares/files/nv-modules-load"

# Fix for r8169 module
#sed -i "/usr/lib/modprobe.d/r8168.conf" -e 's|r8169|r8168|'

# Get extra drivers!
mkdir "/opt/extra-drivers"
sudo pacman -Sw --noconfirm --cachedir "/opt/extra-drivers" r8168

# Clean pacman log
rm "/var/log/pacman.log"

echo "############################"
echo "# end chrooted commandlist #"
echo "############################"

EOF
)"
}

#################################
########## STARTS HERE ##########
#################################

do_merge
