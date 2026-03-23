#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="EndeavourOS_Titan"
iso_label="EOS_$(date +%Y%m)"
iso_publisher="EndeavourOS <https://endeavouros.com>"
iso_application="EndeavourOS Live/Rescue CD"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
quiet="n"
work_dir="work"
out_dir="out"
bootmodes=('bios.syslinux' 'uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/etc/sudoers.d"]="0:0:750"
  ["/etc/sudoers.d/g_wheel"]="0:0:440"
  ["/usr/bin/intel-legacy-gpu-installer"]="0:0:755"
  ["/usr/bin/broadcom-wl_detect.sh"]="0:0:755"
  ["/usr/bin/broadcom-wl_enable.sh"]="0:0:755"
  ["/usr/bin/eos-hardware-detect"]="0:0:755"
  ["/etc/calamares"]="0:0:755"
  ["/etc/calamares/files"]="0:0:755"
  ["/home/liveuser"]="1000:1000:750"
  ["/etc/NetworkManager/conf.d/00-macrandomize.conf"]="0:0:644"
  ["/etc/NetworkManager/conf.d/10-dns.conf"]="0:0:644"
  ["/etc/systemd/resolved.conf.d/00-dnssec.conf"]="0:0:644"
  ["/etc/sysctl.d/99-security.conf"]="0:0:644"
  ["/etc/modprobe.d/security.conf"]="0:0:644"
)
