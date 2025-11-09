# Niri on EndavourOS

This assumes you have installed EndavourOS with KDE Plasma and no other configuration changes have been made.

## Required Packages

```shell
yay -S niri mako xdg-desktop-portal-gtk xdg-desktop-portal-gnome gnome-keyring fuzzel xwayland-satellite waybar alacritty swaybg swayidle network-manager-applet ttf-font-awesome otf-font-awesome swaylock fastfetch cliphist nautilus --noconfirm
```

## Changes to PAM

If you happen to use KDE Plasma you will also have a kwallet and it might be things will not work properly.

Make sure /etc/pama.d/sddm contains these exact lines.
If they are preceded by `-` remove it:

```
```
auth       optional    pam_kwallet5.so
session    optional    pam_kwallet5.so         auto_start
```

```

## KDE Polkit changes

Edit the polkit service `systemctl --user edit --full plasma-polkit-agent.service` and make sure the 'After' line reads:

```
After=plasma-core.target graphical-session.target
```


## Additional required services

Download the two services inside the systemd folder, these will allow swaybg and swayidle to run properly. Copy these files to `~/.config/systemd/user/` and reload + enable the services.

```

```
systemctl --user daemon-reload
systemctl --user add-wants niri.service swayidle.service
systemctl --user add-wants niri.service swaybg.service



