## Changelog holding milestones and major changes to the code
---

# for Artemis neo (August 2022) 
* we use calamares 3.2.59 version becaus of: https://github.com/calamares/calamares/issues/2008
* packages injection install needs downgraded xkeyboard-config and the eos-theming-package to hold theming for neo.
* https://archive.archlinux.org/packages/x/xkeyboard-config/xkeyboard-config-2.35.1-1-any.pkg.tar.zst
* https://github.com/endeavouros-team/endeavouros-theming/tree/artemis_neo


# April, May 2022 // @keybreak and @killajoe ISO process cleanup for package handling and LiveSession creation:

* [packages.x86_64](https://github.com/endeavouros-team/EndeavourOS-ISO/blob/main/packages.x86_64)
and:
* [chrooted_cleaner_script.sh#L181](https://github.com/endeavouros-team/EndeavourOS-calamares/blob/13511822baa4cb9414d837b9b2ccb258335010aa/calamares/scripts/chrooted_cleaner_script.sh#L181)

are in sync now :clap: :partying_face:

And will be easy to maintain in the future also if we go to split `chrooted_cleaner_script.sh` in to more logical pices, where the `clean_offline_packages` could be one module. 

[run_before_squashfs.sh](https://github.com/endeavouros-team/EndeavourOS-ISO/blob/main/run_before_squashfs.sh)

look at it its clean and really slick now! The way it creates and handles liveuser session clean and easy to handle now without the hustle to fight with permissions and copy single config by config all over the place. 

instead it creates a package with all the settings you can find in one folder using skel method and cleanly removes that after user creation. 

All over file permissions are now handled centralized in the way archiso gives:
[profiledef.sh](https://github.com/endeavouros-team/EndeavourOS-ISO/blob/main/profiledef.sh)
`fixpermissions.sh` is gone and no need to fix permissions in a third place on livesession setup anymore.

[prepare.sh](https://github.com/endeavouros-team/EndeavourOS-ISO/blob/main/prepare.sh)
handles file downloads and liveuser-skel-package needed for the buildprocess in one place outside `run_before_squashfs.sh` easy to use for future changes and needs.

Remove legacy code from `run_before_squashfs.sh`
- https://github.com/endeavouros-team/EndeavourOS-ISO/commit/c8603d5cb5805da0e68c52fbea054f4ccab0064a
- https://github.com/endeavouros-team/EndeavourOS-ISO/commit/c484f3895770870013d33ac5483e15abb13f6b37


# October 2021

New merged repository structure (october 2021) by joekamprad. 
Now live-user-desktop-settings are included under /airootfs/root/liveuser-desktop-settings
First step on clean up the natrurally grown ISO structure..

Adding [mkarchiso-changes.md](https://github.com/endeavouros-team/EndeavourOS-ISO/blob/main/mkarchiso-changes.md) to keep track of changes on the mkarchiso script for updating it to the latest version from time to time.
