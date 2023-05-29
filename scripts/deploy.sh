#!/usr/bin/bash

# source ./poky/oe-init-build-env before running this script to set BUILDDIR

# build with bitbake bootlinlabs-image-minimal-dbg

set +x

IMAGE=stm32mp1
IMAGE=bootlinlabs

TFTP_ROOT=/srv/tftp
NFS_ROOT=/nfs

echo "Uncompressing rootfs"
sudo tar xvpf $BUILDDIR/tmp/deploy/images/$IMAGE/bootlinlabs-image-minimal-dbg-bootlinlabs.tar.gz -C $NFS_ROOT

echo "Copying kernel and dtb"
sudo cp $BUILDDIR/tmp/deploy/images/$IMAGE/kernel/zImage $TFTP_ROOT/zImage
sudo cp $BUILDDIR/tmp/deploy/images/$IMAGE/kernel/stm32mp157f-dk2.dtb $TFTP_ROOT/stm32mp157f-dk2.dtb