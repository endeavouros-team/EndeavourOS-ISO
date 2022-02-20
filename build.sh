pacman -S --noconfirm --needed archlinux-keyring
pacman -S --needed --noconfirm archiso mkinitcpio-archiso
pacman -S wget --noconfirm --needed
pacman-key --init && pacman-key --recv-key 003DB8B0CB23504F --keyserver keyserver.ubuntu.com && pacman-key --lsign-key 003DB8B0CB23504F
wget https://raw.githubusercontent.com/endeavouros-team/EndeavourOS-ISO/main/airootfs/etc/pacman.conf -O /etc
wget https://raw.githubusercontent.com/endeavouros-team/PKGBUILDS/master/endeavouros-mirrorlist/endeavouros-mirrorlist -O /etc/pacman.d/endeavouros-mirrorlist

mkarchiso -v -w ./work -o ./out ./
echo "ISO Built in ./out folder!"
