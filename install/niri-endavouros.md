# Niri on EndavourOS

This assumes you have installed EndavourOS with KDE Plasma and no other configuration changes have been made.

## Required Packages

```shell
yay -S niri mako xdg-desktop-portal-gtk xdg-desktop-portal-gnome gnome-keyring fuzzel xwayland-satellite waybar alacritty swaybg swayidle network-manager-applet ttf-font-awesome otf-font-awesome swaylock fastfetch cliphist nautilus brightnessctl --noconfirm
```

## Changes to PAM

If you happen to use KDE Plasma you will also have a kwallet and it might be things will not work properly.

Make sure /etc/pama.d/sddm contains these exact lines.
If they are preceded by `-` remove it:

```
auth       optional    pam_kwallet5.so
session    optional    pam_kwallet5.so         auto_start
```

## KDE Polkit changes

Edit the polkit service `systemctl --user edit --full plasma-polkit-agent.service` and make sure the 'After' line reads:

```
After=plasma-core.target graphical-session.target
```

### Startup tips

If you keep on having issues with KDE polkit (like I have in conjunction with 1password). 
I recommend starting it with `spawn-at-startup` in you niri config.

```ini
spawn-at-startup "/usr/lib/polkit-kde-authentication-agent-1"
```


## Additional required services

Download the two services inside the systemd folder, these will allow swaybg and swayidle to run properly. Copy these files to `~/.config/systemd/user/` and reload + enable the services.

```shell
systemctl --user daemon-reload
systemctl --user add-wants niri.service swayidle.service
systemctl --user add-wants niri.service swaybg.service
```

# 1Password

I had little luck getting 1Password to start up properly and have its icon in the tray.
To get it working properly, I created an autostart desktop file in `~/.config/autostart/` with the following contents:

```ini
[Desktop Entry]
Categories=Office;
Comment=Password manager and secure wallet
Exec=bash -c "sleep 10 && /opt/1Password/1password --silent --ozone-platform-hint=x11"
Icon=1password
MimeType=x-scheme-handler/onepassword;
Name=1Password
StartupWMClass=1Password
Terminal=false
Type=Application
X-GNOME-Autostart-Delay=10
X-MATE-Autostart-Delay=10
X-KDE-autostart-after=panel
```

The Exec entry uses a bash sleep to wait for 1Password to start properly.