# EndeavourOS-ISO

[![Maintenance](https://img.shields.io/maintenance/yes/2022.svg)]()

**main** branch is development latest (unstable)

### Developers:
- [joekamprad](https://github.com/killajoe)
- [manuel](https://github.com/manuel-192)
- [fernandomaroto](https://github.com/Portergos) (initial developer)

### Contributors:
- [keybreak](https://github.com/keybreak)

..and our beloved community

This ISO is based on hugely modified Arch-ISO to provide Installation Environment for EndeavourOS.  
More info at [EndeavourOS-GitHub-Development](https://endeavouros-team.github.io/EndeavourOS-Development/)


## Resources:

<img src="https://raw.githubusercontent.com/endeavouros-team/screenshots/master/Artemis/Artemis-LiveSession.png" alt="Installer LiveSession" width="600"/>

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
<img src="https://raw.githubusercontent.com/endeavouros-team/screenshots/master/Apollo/apollo-systemdboot.png" alt="drawing" width="600"/>

Bios-boot (syslinux) for legacy systems:  
<img src="https://raw.githubusercontent.com/endeavouros-team/screenshots/master/Apollo/apollo-syslinux.png" alt="drawing" width="600"/>



# How to build ISO

You need to use an installed EndeavourOS system or any archbased system with EndeavourOS [repository](https://github.com/endeavouros-team/mirrors) enabled.

As the installer packages and needed dependencies will get installed from EndeavourOS repository.

general information: 

https://endeavouros-team.github.io/EndeavourOS-Development/

And read the changelog before starting to know about latest changes:

https://github.com/endeavouros-team/EndeavourOS-ISO/blob/main/CHANGELOG.md

### Install build dependencies

```
sudo pacman -S archiso mkinitcpio-archiso git squashfs-tools --needed
```
Recommended to reboot after this changes.

### Build

##### 1. Prepare

If you want the last release state to rebuild ISO you need to use specific tag tarball.
https://github.com/endeavouros-team/EndeavourOS-ISO/tags

If not you will use latest "unstable" development state.

use last stable release (exemple for 22.9 Artemis-nova Release):

```
wget https://github.com/endeavouros-team/EndeavourOS-ISO/archive/refs/tags/22.9.tar.gz
tar -xvf 22.9.tar.gz
cd "EndeavourOS-ISO-22.9"
./prepare.sh
```

##### 2. Build

~~~
sudo ./mkarchiso -v "."
~~~

**or with log:**

~~~
sudo ./mkarchiso -v "." 2>&1 | tee "eosiso_$(date -u +'%Y.%m.%d-%H:%M').log"
~~~

##### 3. The .iso appears in `out` directory


## Advanced

To install locally builded packages on ISO put the packages inside directory:

~~~
airootfs/root/packages
~~~

Packages will get installed and directory will be cleaned up after that.
