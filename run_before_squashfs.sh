#!/usr/bin/env bash

# Made by Fernando "maroto"
# Run anything in the filesystem right before being "mksquashed"
# ISO-NEXT specific cleanup removals and additions (08-2021) @killajoe and @manuel

script_path=$(readlink -f ${0%/*})
work_dir=work

# Adapted from AIS. An excellent bit of code!
arch_chroot(){
    arch-chroot $script_path/${work_dir}/x86_64/airootfs /bin/bash -c "${1}"
}
do_merge(){
arch_chroot "

##############################
# start chrooted commandlist #
##############################

# prepare livesession settings and user
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
rm /etc/skel/{set_once.sh,mousepad.dconf}

#set root permission and shell
chmod -R 700 /root
chown root:root -R /root
usermod -s /usr/bin/bash root

useradd -m -p \"\" -g users -G 'sys,rfkill,wheel,uucp,nopasswdlogin,adm,tty' -s /bin/bash liveuser

# insert special desktop settings for installer livesession
# placing needed config files for user tools
# fix permissions and owner
cd /root/liveuser-desktop-settings
mkdir /root/.config
cp -R .config/{Kvantum,qt5ct} /root/.config/
dbus-launch dconf load / < xed.dconf
rm -R /home/liveuser/.config
cp -R .config /home/liveuser/.config
rm /home/liveuser/{.bashrc,.bash_profile,xed.dconf}
cp .bashrc .bash_profile LICENSE user_pkglist.txt user_commands.bash .xinitrc .xprofile .Xauthority .xsession xed.dconf /home/liveuser/
chown -R liveuser:liveuser /home/liveuser
chmod +x /home/liveuser/{.xprofile,.xinitrc,.xsession,user_commands.bash}
sudo -H -u liveuser bash -c 'dbus-launch dconf load / < /home/liveuser/xed.dconf'
rm /home/liveuser/xed.dconf
cd ..
rm -R liveuser-desktop-settings

# set wallpaper for live-session
chmod 644 /usr/share/endeavouros/*.png
rm -rf /usr/share/backgrounds/xfce/xfce-verticals.png
ln -s /usr/share/endeavouros/backgrounds/endeavouros-wallpaper.png /usr/share/backgrounds/xfce/xfce-verticals.png


# fixing permission on other file paths
chmod 755 /etc/sudoers.d
mkdir -p /media
chmod 755 /media
chmod 440 /etc/sudoers.d/g_wheel
chown 0 /etc/sudoers.d
chown 0 /etc/sudoers.d/g_wheel
chown root:root /etc/sudoers.d
chown root:root /etc/sudoers.d/g_wheel
chmod 755 /etc

# fix configurations
sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
# archiso now has a /airootfs/etc/systemd/journald.conf.d/volatile-storage.conf
#sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf
# archiso now has /airootfs/etc/systemd/logind.conf.d/do-not-suspend.conf
#sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
#sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
#sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

# enable systemd services
systemctl enable NetworkManager.service
systemctl enable vboxservice.service vmtoolsd.service vmware-vmblock-fuse.service
systemctl set-default multi-user.target

# revert from arch-iso preset to default preset
cp -rf /usr/share/mkinitcpio/hook.preset /etc/mkinitcpio.d/linux.preset
sed -i 's?%PKGBASE%?linux?' /etc/mkinitcpio.d/linux.preset

# fetch fallback mirrorlist for offline installs:
wget https://raw.githubusercontent.com/endeavouros-team/EndeavourOS-iso-next/main/mirrorlist
cp mirrorlist /etc/pacman.d/
rm mirrorlist

# patching EndeavourOS specific grub config
patch -u /etc/default/grub -i /root/grub.patch
rm /root/grub.patch

# get default mkinitcpio.conf (possible patching it here)
wget https://raw.githubusercontent.com/archlinux/mkinitcpio/master/mkinitcpio.conf
patch -u mkinitcpio.conf -i /root/mkinitcpio.patch
cp mkinitcpio.conf /etc/
rm mkinitcpio.conf /root/mkinitcpio.patch

# remove unneeded grub stuff from /boot
# rm /boot/grub/grub.cfg #archiso does not create it anymore
rm -R /boot/syslinux
rm -R /boot/memtest86+
rm /boot/amd-ucode.img
rm /boot/initramfs-linux.img
rm /boot/intel-ucode.img
rm /boot/vmlinuz-linux

# to install locally builded packages on ISO:
#pacman -U --noconfirm /root/calamares_current-3.2.44.3-4-any.pkg.tar.zst
#rm /root/calamares_current-3.2.44.3-4-any.pkg.tar.zst
#rm /var/log/pacman.log

# fix packages that we want to keep but they would get uninstalled caused by dependency removals
pacman -D --asexplicit sshfs rsync
rm /var/log/pacman.log

# custom fixes currently needed:
# current fix for getting bash configs installed:
cp /home/liveuser/
# move blacklisting nouveau out of ISO (needs to pull to target for offline installs)
mv /usr/lib/modprobe.d/nvidia-dkms.conf /etc/calamares/files/
# fix for r8169 module
sed -i /usr/lib/modprobe.d/r8168.conf -e 's|r8169|r8168|'

############################
# end chrooted commandlist #
############################

"
}

#################################
########## STARTS HERE ##########
#################################

do_merge
