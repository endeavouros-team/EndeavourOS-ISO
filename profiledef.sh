#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="endeavouros"
iso_label="EOS_$(date +%Y%m)"
iso_publisher="EndeavourOS <https://endeavouros.com>"
iso_application="EndeavourOS Live/Rescue CD"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
quiet="n"
work_dir="work"
out_dir="out"
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="airootfs/etc/pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/etc/sudoers.d"]="0:0:750"

  ["/etc/skel/.xprofile"]="0:0:755"
  ["/etc/skel/.xinitrc"]="0:0:755"
  ["/etc/skel/set_once_xfce4.sh"]="0:0:755"
  ["/etc/skel/user_commands.bash"]="0:0:755"
)
