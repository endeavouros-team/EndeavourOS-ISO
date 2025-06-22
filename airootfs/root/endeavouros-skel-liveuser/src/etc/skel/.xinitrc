#!/bin/sh
# needed for plasma x11 session
export DESKTOP_SESSION=plasma
export XDG_CURRENT_DESKTOP=KDE
export XDG_SESSION_DESKTOP=KDE
export KDE_FULL_SESSION=true
export QT_QPA_PLATFORM=xcb
# for auto-keymap.sh
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export INPUT_METHOD=fcitx
# start plasma x11 session
exec startplasma-x11
