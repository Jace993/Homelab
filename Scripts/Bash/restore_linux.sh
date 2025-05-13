#!/bin/bash

# Boot live iso 
mkdir /mnt/system/mnt/usb

lsblk

#Then we have to mount the filesystem and the backup on the USB flash drive:

mount /dev/sda1 /mnt/system mount /dev/sdb1 /mnt/usb

# Restore backup

rsync -aAXv --delete --exclude="lost+found" /mnt/usb/ /mnt/system/

