# EndeavourOS-ISO

[![Maintenance](https://img.shields.io/maintenance/yes/2021.svg)]()

New merged repository structure (october 2021) by joekamprad.
now `live-user-desktop-settings` are included under `/airootfs/root/liveuser-desktop-settings`

### Developers:
- [joekamprad](https://github.com/killajoe)
- [manuel](https://github.com/manuel-192)
- [fernandomaroto](https://github.com/Portergos) (initial developer)
- our beloved community

This ISO is based on hugely modified Arch-ISO to provide Installation Environment for EndeavourOS.  
More info at [EndeavourOS-GitHub-Development](https://endeavouros-team.github.io/EndeavourOS-Development/)



# Resources

<img src="https://raw.githubusercontent.com/endeavouros-team/screenshots/master/eos-installer-iso-nov-2021.png" alt="drawing" width="600"/>

- https://endeavouros.com
- [Getting help at the forum](https://forum.endeavouros.com)
- [Bug report](https://forum.endeavouros.com/c/Arch-based-related-questions/bug-reports)
- [Telegram help-chat](https://t.me/Endeavouros)
- [Reddit news](https://www.reddit.com/r/EndeavourOS)
- [Twitter news](https://twitter.com/OsEndeavour)

Our journey wouldn't be made possible without the generosity of our [Open Collective community](https://opencollective.com/endeavouros)!


### Development source

- [EndeavourOS-ISO source](https://github.com/endeavouros-team/EndeavourOS-ISO) (Live environment with XFCE4-Desktop)
- [EndeavourOS-calamares](https://github.com/endeavouros-team/EndeavourOS-calamares) (installer framework)


### Base source

- [Arch-ISO](https://gitlab.archlinux.org/archlinux/archiso)
- [Calamares](https://github.com/calamares/calamares)



# Boot options

Systemd-boot for UEFI systems:  
<img src="https://raw.githubusercontent.com/endeavouros-team/screenshots/master/systemd-boot-iso-nov21.png" alt="drawing" width="600"/>

Bios-boot (syslinux) for legacy systems:  
<img src="https://raw.githubusercontent.com/endeavouros-team/screenshots/master/eos-iso-syslinux-nov2021.png" alt="drawing" width="600"/>



# How to build ISO

You need to use an installed EndeavourOS system or any archbased system with EndeavourOS [repository](https://github.com/endeavouros-team/mirrors) enabled.

As the installer packages and needed dependencies will get installed from EndeavourOS repository.

general information: https://endeavouros-team.github.io/EndeavourOS-Development/

### Install build dependencies

```
sudo pacman -S archiso mkinitcpio-archiso git squashfs-tools --needed
```

### Build

##### 1. Prepare

```
git clone https://github.com/endeavouros-team/EndeavourOS-ISO.git
cd "EndeavourOS-ISO"
sudo ./fix_permissions.sh
```

##### 2. Build

~~~
sudo ./mkarchiso "."
~~~

or with log

~~~
sudo ./mkarchiso "." 2>&1 | tee "eosiso.log"
~~~

##### 3. The .iso appears in `out` directory


## Advanced

To install locally builded packages on ISO put the packages inside `airootfs/root` and use something like this lines:

```
pacman -U --noconfirm "/root/calamares_current-3.2.44.3-4-any.pkg.tar.zst
rm /root/calamares_current-3.2.44.3-4-any.pkg.tar.zst
```
inside `run_before_squashfs.sh
