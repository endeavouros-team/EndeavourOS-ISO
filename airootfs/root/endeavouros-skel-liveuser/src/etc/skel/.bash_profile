#
# ~/.bash_profile
#

# Source bashrc if it exists
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Redirect all output and errors to log
exec >> /tmp/live-session.log 2>&1

echo "==== Starting Plasma Live Session on EndeavourOS $(date) ===="

# Automatically start Plasma Wayland only on TTY1
if [[ -z "$WAYLAND_DISPLAY" ]] && [[ "$(tty)" == "/dev/tty1" ]]; then
    # Define session types and desktop environment targets
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=KDE
    export DESKTOP_SESSION=plasma
    export XDG_CURRENT_DESKTOP=KDE

    # Ensure XWayland compatibility flags are set
    export GDK_BACKEND="wayland,x11"

  # Execute the Plasma session manager directly within the PAM/systemd session context
    exec startplasma-wayland > /dev/null 2>&1
fi
