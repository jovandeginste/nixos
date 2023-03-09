#!/bin/bash

fdisk /dev/vda <<EO_PT
o
n
p
1
2048
+500M
n
p
2


t
2
lvm
w
EO_PT

wipefs -a /dev/vda1

mkfs.fat -F 32 /dev/vda1
fatlabel /dev/vda1 boot

wipefs -a /dev/vda2
pvcreate /dev/vda2
vgcreate rootvg /dev/vda2

lvcreate -L 20G -n root rootvg
mkfs.ext4 /dev/rootvg/root -L root

lvcreate -L 4G -n swap rootvg
mkswap /dev/rootvg/swap

mount /dev/disk/by-label/root /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
