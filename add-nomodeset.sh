#!/bin/bash

# Run in superuser
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

sed -iE 's/GRUB_CMDLINE_LINUX_DEFAULT\="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT\="quiet splash nomodeset"/g' /etc/default/grub && update-grub;
