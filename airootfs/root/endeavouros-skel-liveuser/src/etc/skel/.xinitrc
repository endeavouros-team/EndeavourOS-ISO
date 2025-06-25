#!/bin/sh

# needed for plasma x11 session
export DESKTOP_SESSION=plasma
export XDG_CURRENT_DESKTOP=KDE
export XDG_SESSION_DESKTOP=KDE
export KDE_FULL_SESSION=true
export QT_QPA_PLATFORM=xcb

# Automatically detect country code via GeoIP and set keymap
country="$(show-location-info -l country)"
case "$country" in
    us | gb | fr | it | es | de | fi | jp | cn) setxkbmap $country ;;
    # others here...
    *) setxkbmap us ;;    # fallback
esac

# Start Plasma session on X11
exec startplasma-x11
