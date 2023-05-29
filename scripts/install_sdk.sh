#!/usr/bin/bash

# source ./poky/oe-init-build-env before running this script to set BUILDDIR

set +x

IMAGE=stm32mp1
IMAGE=bootlinlabs

echo "Installing sdk"
$BUILDDIR/tmp/deploy/sdk/poky-glibc-x86_64-bootlinlabs-image-minimal-cortexa7t2hf-neon-vfpv4-bootlinlabs-toolchain-4.0.8.sh
