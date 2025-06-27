#!/bin/sh

# needed for plasma x11 session
export XDG_SESSION_TYPE=x11
export DESKTOP_SESSION=plasma
export XDG_CURRENT_DESKTOP=KDE
export XDG_SESSION_DESKTOP=KDE
export KDE_FULL_SESSION=true
export QT_QPA_PLATFORM=xcb

# Start Plasma session on X11
exec startplasma-x11
