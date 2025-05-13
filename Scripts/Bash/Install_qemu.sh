#!/bin/bash

#install qemu#
sudo pacman -S qemu-full qemu-emulators-full virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libvirt
sudo systemctl enable libvirtd
sudo systemctl start --now libvirtd

# Add User to new group
sudo usermod -aG libvirt $(whoami)
newgrp libvirt
sudo EDITOR=nano virsh net-edit default

# Install libvirtd
sudo systemctl restart libvirtd
sudo virsh net-start default
sudo virsh net-autostart default
qemu-system-x86_64 --version
sudo virsh net-list --all
virt-manager
