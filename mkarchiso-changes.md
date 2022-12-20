removed os-release handling in mkarchiso (16.10.2022):
https://github.com/endeavouros-team/EndeavourOS-ISO/commit/67a5a371967b57edf21b6e8a93a2720a358571ec

merged changes from latest mkarchiso on 02.10.2022 
```
Version: archiso 67-1
```

merged changes from latest mkarchiso on 17.9.2022 
```
Version: archiso 66-1
```
clean up of ISO structure:

added:

```
 # Pull /usr/lib/endeavouros-release at place to use for prompt info in Live Session
	mkdir -p "${pacstrap_dir}/usr/lib"
	echo "VERSION=${iso_version}" >> "${pacstrap_dir}/usr/lib/endeavouros-release"

```
  
it deletes all stuff in /boot per default need to be changed to leave grub theming and files there as they will be missing for offline installs.. 
done that in run_before_squashfs to have it do what we need...

```
# Delete all files in /boot
 #   [[ -d "${pacstrap_dir}/boot" ]] && find "${pacstrap_dir}/boot" -mindepth 1 -delete`
```

we need package databases present for offline installs and live-session:

```
    # Delete pacman database sync cache
    # [[ -d "${pacstrap_dir}/var/lib/pacman/sync" ]] && find "${pacstrap_dir}/var/lib/pacman/sync" -delete

```



# Cleanup airootfs

```
_cleanup_pacstrap_dir() {
    _msg_info "Cleaning up in pacstrap location..."
    # Pull /usr/lib/endeavouros-release at place to use for prompt info in Live Session
	mkdir -p "${pacstrap_dir}/usr/lib"
	echo "VERSION=${iso_version}" >> "${pacstrap_dir}/usr/lib/endeavouros-release"
    # Delete all files in /boot
    # [[ -d "${pacstrap_dir}/boot" ]] && find "${pacstrap_dir}/boot" -mindepth 1 -delete
    # Delete pacman database sync cache files (*.tar.gz)
    [[ -d "${pacstrap_dir}/var/lib/pacman" ]] && find "${pacstrap_dir}/var/lib/pacman" -maxdepth 1 -type f -delete
    # Delete pacman database sync cache
    [[ -d "${pacstrap_dir}/var/lib/pacman/sync" ]] && find "${pacstrap_dir}/var/lib/pacman/sync" -delete
    # Delete pacman package cache
    [[ -d "${pacstrap_dir}/var/cache/pacman/pkg" ]] && find "${pacstrap_dir}/var/cache/pacman/pkg" -type f -delete
    # Delete all log files, keeps empty dirs.
    [[ -d "${pacstrap_dir}/var/log" ]] && find "${pacstrap_dir}/var/log" -type f -delete
    # Delete all temporary files and dirs
    [[ -d "${pacstrap_dir}/var/tmp" ]] && find "${pacstrap_dir}/var/tmp" -mindepth 1 -delete
    # Delete package pacman related files.
    find "${work_dir}" \( -name '*.pacnew' -o -name '*.pacsave' -o -name '*.pacorig' \) -delete
    # Create an empty /etc/machine-id
    rm -f -- "${pacstrap_dir}/etc/machine-id"
    printf '' > "${pacstrap_dir}/etc/machine-id"

    _msg_info "Done!"
}
```

# added parts for run_before_squashfs to run:

```
script_path="$( cd -P "$( dirname "$(readlink -f "$0")" )" && pwd )"
# executed inside _mkairootfs_sfs right before squashfs
RUN_BEFORE_SQUASHFS=$script_path/run_before_squashfs.sh

    $RUN_BEFORE_SQUASHFS
```
    
