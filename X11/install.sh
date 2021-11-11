#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

[ -d /etc/X11/xorg.conf.d ] || sudo mkdir /etc/X11/xorg.conf.d
sudo ln -svf $dir/50-device.conf /etc/X11/xorg.conf.d/50-device.conf
sudo ln -svf $dir/90-touchpad.conf /etc/X11/xorg.conf.d/90-touchpad.conf
#ln -svf $dir/.xinitrc $HOME/.xinitrc
