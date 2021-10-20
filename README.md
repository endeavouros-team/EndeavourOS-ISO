## EndeavourOS-iso-next

## testing new merged repository structure (october 2021) by joekamprad@endeavouros.com
now live-user-desktop-settings are included under /airootfs/root/liveuser-desktop-settings


[![Maintenance](https://img.shields.io/maintenance/yes/2021.svg)]()

Developer: [joekamprad](https://github.com/killajoe), [manuel](https://github.com/manuel-192) and our beloved community.

Initial Developer: [fernandomaroto](https://github.com/Portergos)

More info: [EndeavourOS-GitHub-Development](https://endeavouros-team.github.io/EndeavourOS-Development/)

## This ISO is based on Arch-ISO modified hugely to provide Installation Environment for EndeavourOS.

https://endeavouros.com

<img src="https://raw.githubusercontent.com/endeavouros-team/artwork-images-logo/master/NEXT/livesession.png" alt="drawing" width="600"/>

EndeavourOS-archiso Sources:

https://github.com/endeavouros-team/EndeavourOS-iso-next

Arch-ISO Source:

https://gitlab.archlinux.org/archlinux/archiso

Live environment on XFCE4-Desktop with calamares as your installer:

https://github.com/calamares/calamares

Bugs can be reported here:

https://forum.endeavouros.com/c/Arch-based-related-questions/bug-reports

Getting help at the forum: https://forum.endeavouros.com

Help-Chat is available on telegram: https://t.me/Endeavouros

News at reddit: https://www.reddit.com/r/EndeavourOS

News at twitter: https://twitter.com/OsEndeavour

Our journey wouldn't be made possible without the generosity of our open collective community:

https://opencollective.com/endeavouros

Systemd-boot for UEFI systems:

<img src="https://raw.githubusercontent.com/endeavouros-team/artwork-images-logo/master/NEXT/systemd-boot.png" alt="drawing" width="600"/>

Bios-boot for legacy systems:

<img src="https://raw.githubusercontent.com/endeavouros-team/artwork-images-logo/master/NEXT/bios-boot.png" alt="drawing" width="600"/>

## How to build ISO:
To build you need to use installed EndeavourOS system or any archbased system with EndeavourOS repository enabled.

https://github.com/endeavouros-team/mirrors

## Install necessary packages
`sudo pacman -S archiso mkinitcpio-archiso git squashfs-tools --needed`

Clone:
`git clone https://github.com/endeavouros-team/EndeavourOS-ISO.git`

for testing you can use a branch: `git clone -b 08-2021 --single-branch https://github.com/endeavouros-team/EndeavourOS-ISO.git`

`cd EndeavourOS-iso-next`

## Run fix permissions script
`sudo ./fix_permissions.sh`

## Build
`sudo ./mkarchiso /path/to/profile` 

path is where you clone the ISO structure... 

## The iso appears at `out` folder

to install locally builded packages on ISO:
you can do so like that putting the packages inside ISO-next/airootfs/root/ and use this lines:

`pacman -U --noconfirm /root/calamares_current-3.2.41.1-5-any.pkg.tar.zst`

`rm /root/calamares_current-3.2.41.1-5-any.pkg.tar.zst`

`pacman -U --noconfirm /root/calamares_config_next-2.0-4-any.pkg.tar.zst`

`rm /root/calamares_config_next-2.0-4-any.pkg.tar.zst`
