# EndeavourOS-ISO

[![Maintenance](https://img.shields.io/maintenance/yes/2023.svg)]()

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

<img src="https://raw.githubusercontent.com/endeavouros-team/screenshots/master/KDE-LiveSession.png" alt="Installer LiveSession" width="600"/>

- https://endeavouros.com
- [Getting help at the forum](https://forum.endeavouros.com)
- [Bug report](https://forum.endeavouros.com/c/Arch-based-related-questions/bug-reports)
- [Telegram help-chat](https://t.me/Endeavouros)
- [Twitter news](https://twitter.com/OsEndeavour)

Our journey wouldn't be made possible without the generosity of our [Open Collective community](https://opencollective.com/endeavouros)!


### Development source

- [EndeavourOS-ISO source](https://github.com/endeavouros-team/EndeavourOS-ISO) (Live environment with KDE-Desktop)
- [Calamares {EndeavourOS fork}](https://github.com/endeavouros-team/calamares) (installer framework)


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

General information: 

https://endeavouros-team.github.io/EndeavourOS-Development/

Read the changelog before starting to learn about latest changes:

https://github.com/endeavouros-team/EndeavourOS-ISO/blob/main/CHANGELOG.md

### Install build dependencies

```
sudo pacman -S archiso mkinitcpio-archiso git squashfs-tools --needed
```
It is recommended to reboot after these changes.

### Build

##### 1. Prepare

If you want the last release state to rebuild the ISO, you need to use a specifically tagged tarball from here:
https://github.com/endeavouros-team/EndeavourOS-ISO/tags

If not, it will default to using the latest "unstable" development state.

example using latest **stable** release (23.11.1.2 Galileo KDE Release) 

**Warning:** do **not** use the zip tarball, in case this causes issues with symlinks.

```
wget https://github.com/endeavouros-team/EndeavourOS-ISO/archive/refs/tags/23.11.1.2.tar.gz
tar -xvf 23.11.1.2.tar.gz
cd "EndeavourOS-ISO-23.11.1.2"
./prepare.sh
```
### Or use latest **unstable** development branch using by cloning this repo using git:

```
git clone https://github.com/endeavouros-team/EndeavourOS-ISO.git
cd EndeavourOS-ISO
./prepare.sh
```
### In case you want to build pre Galileo Releases:

If  that you can use older tags like:
```
wget https://github.com/endeavouros-team/EndeavourOS-ISO/archive/refs/tags/22.12.2.tar.gz
tar -xvf 22.12.2.tar.gz
cd "EndeavourOS-ISO-22.12.2"
./prepare.sh
```
But caused by the change to KDE these iso will use XFCE4 LiveSession and you will need to build calamares manually:

using this PKGBUILD: 
https://raw.githubusercontent.com/endeavouros-team/PKGBUILDS/18e3f580abb68486091492168956619bb0f32abe/calamares/PKGBUILD

And put the resulting package into ISO structure to get installed with the ISO build procedure:

`airootfs/root/packages/`

To get this working you need to remove `calamares` from `packages.x86_64` before starting ISO build.

##### 2. Build

~~~
sudo ./mkarchiso -v "."
~~~

**or with log:**

~~~
sudo ./mkarchiso -v "." 2>&1 | tee "eosiso_$(date -u +'%Y.%m.%d-%H:%M').log"
~~~

##### 3. The .iso file appears in the `out` directory...


## Advanced

To install locally built packages on ISO, put the packages inside the following directory:

~~~
airootfs/root/packages
~~~

Packages will be installed and the directory will be cleaned up after that.
