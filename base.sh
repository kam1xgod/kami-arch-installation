#!/bin/bash

# HOSTNAME
declare -r HOSTNAME="temp"
# USERNAME
declare -r USERNAME="kami"
# root password
ROOTPAS="RKY2A5)"
# USERNAME password
USERNAMEPAS="123456"

# set system time
ln -sf /usr/share/zoneinfo/Europe/Samara /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen

# set keyboard layout
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "$HOSTNAME" >> /etc/hostname

# set local host address
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts

# set root password
echo root:"$ROOTPAS" | chpasswd

# install packages for booting
pacman --noconfirm -S grub grub-btrfs efibootmgr

# install packages for network
pacman --noconfirm -S networkmanager network-manager-applet wpa_supplicant

# install DOS filesystem utilities & disk tools
pacman --noconfirm -S mtools dosfstools os-prober

# install shell dialog box, arch mirrorlist
pacman --noconfirm -S dialog reflector

# install linux system group packages
pacman --noconfirm -S linux-headers

# install user directories & command line tools
pacman --noconfirm -S xdg-user-dirs xdg-utils

# install additional support network & dns packages, service discovery tools
# pacman --noconfirm -S nfs-utils inetutils dnsutils openbsd-netcat iptables-nft ipset nss-mdns avahi

# install bluetooth protocol stack packages
pacman --noconfirm -S bluez bluez-utils

# install support packages & drivers for printers
# pacman --noconfirm -S cups hplip

# install sound system packages
pacman --noconfirm -S alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack pavucontrol

# install SSH protocol support & sync packages
pacman --noconfirm -S openssh rsync

# install support for  battery, power, and thermals
pacman --noconfirm -S acpi acpi_call tlp acpid

# install support for Virtual machines & emulators
# virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2

# install firewall support
pacman --noconfirm -S firewalld

# install GRUB as bootloader
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# For Discrete Graphics Cards
pacman --noconfirm -S --noconfirm xf86-video-amdgpu
# pacman --noconfirm -S --noconfirm nvidia nvidia-utils nvidia-settings

# enable services to always start at system boot
systemctl enable NetworkManager
# systemctl enable bluetooth
# systemctl enable cups.service
systemctl enable sshd
# systemctl enable avahi-daemon
systemctl enable tlp
systemctl enable reflector.timer
systemctl enable fstrim.timer

# enable for virtualization
# systemctl enable libvirtd

systemctl enable firewalld
systemctl enable acpid

# add user and give priviliges
useradd -m "$USERNAME" 
echo "$USERNAME":"$USERNAMEPAS" | chpasswd
usermod -aG wheel "$USERNAME" 

# give user ownership for virtualization
# usermod -aG libvirt example-user

echo "$USERNAME ALL=(ALL) ALL" >> /etc/sudoers.d/"$USERNAME"

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
