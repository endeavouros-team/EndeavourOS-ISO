#!/bin/sh

# Force EGL and Qt to X11/XCB
export EGL_PLATFORM=x11
export QT_QPA_PLATFORM=xcb

# Essential for KDE to identify the session correctly
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=KDE
export KDE_FULL_SESSION=true

# Start Plasma session on X11
exec startplasma-x11
