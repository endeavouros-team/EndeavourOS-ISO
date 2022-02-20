pacman -S --noconfirm --needed archlinux-keyring
pacman -S --needed --noconfirm archiso mkinitcpio-archiso
pacman -S wget --noconfirm --needed
pacman-key --init && pacman-key --recv-key 003DB8B0CB23504F --keyserver keyserver.ubuntu.com && pacman-key --lsign-key 003DB8B0CB23504F && pacman --noconfirm -U 'https://mirror.alpix.eu/endeavouros/repo/endeavouros/x86_64/endeavouros-'{keyring,mirrorlist}'.pkg.tar.zst'
echo "[multilib]" >> /etc/pacman.conf && echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf && echo "[endeavouros]" >> /etc/pacman.conf && echo "SigLevel = PackageRequired" >> /etc/pacman.conf && echo "Include = /etc/pacman.d/endeavouros-mirrorlist" >> /etc/pacman.conf

mkarchiso -v -w ./work -o ./out ./
echo "ISO Built in ./out folder!"
