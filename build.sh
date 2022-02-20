pacman -S --noconfirm --needed archlinux-keyring
pacman -S --needed --noconfirm archiso mkinitcpio-archiso
pacman -S wget --noconfirm --needed
wget https://raw.githubusercontent.com/endeavouros-team/PKGBUILDS/master/endeavouros-mirrorlist/endeavouros-mirrorlist -O /etc/pacman.d/endeavouros-mirrorlist
wget https://raw.githubusercontent.com/endeavouros-team/EndeavourOS-ISO/main/airootfs/etc/pacman.conf -O /etc/pacman.conf
pacman-key --lsign-key EndeavourOS
sudo pacman-key --init
sudo pacman-key --populate archlinux endeavouros
sudo pacman -Syy endeavouros-keyring

mkarchiso -v -w ./work -o ./out ./
echo "ISO Built in ./out folder!"
