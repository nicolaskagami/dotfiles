#!/bin/bash
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.mouse speed $(dbus-launch gsettings get org.gnome.desktop.peripherals.mouse speed)
