# Yocto Workspace

TODO:
- sphinx documentation
- VS Code integration
- With the environnment `~/yocto-tmp` Understand why a change made to `meta-bootlinlabs/recipes-core/images/bootlinlabs-image-minimal-dbg.bb`
(addition or removal of a package) doesn't have any effect on the final image. Bitbake seems to not detect
the change event with  `bitbake -c cleansstate bootlinlabs-image-minimal-dbg` or
`bitbake -f bootlinlabs-image-minimal-dbg`. Read **https://stackoverflow.com/questions/46878640/is-there-a-way-to-check-the-exact-list-of-packages-that-will-be-installed-in-the**.

- Understand why the .ext4 filesystem doesn't get build when MACHINE is `qemuarm` or `qemux86`.
- Try out `meta-zephyr` layer
- Try to build cargo/rust for the SDK

## Prerequisites

- Fedora 37

Install required packages:

    sudo dnf groupinstall "Development Tools" "Development Libraries"
    sudo dnf install git gawk make wget tar bzip2 gzip python3 unzip perl patch \
                    diffutils diffstat git cpp gcc gcc-c++ g++ glibc-devel texinfo chrpath \
                    ccache perl-Data-Dumper perl-Text-ParseWords perl-Thread-Queue perl-bignum \
                    socat python3-pexpect findutils which file cpio python xz SDL-devel \
                    xterm rpcgen mesa-libGL-devel podman buildah qemu-user-static \
                    fakeroot squashfs-tools flex bison openssl-devel bc libyaml-devel fakeroot \
                    dosfstools mtools unzip rsync ncurses-devel lz4 zstd autoconf rpcgen \
                    python3-dnf python3-devel python2-devel perl-open.noarch perl-locale.noarch \
                    tmux

## Setup environment (first setup)

Setup python virtual environment

    python3 -m venv .venv
    source .venv/bin/activate
    pip install --upgrade pip
    python -m pip install pycryptodome pyelftools jinja2 pexpect GitPython cryptography

## Setup Yocto (first setup)

Source the Yocto environment

    source poky/oe-init-build-env

Configure layers, edit [build/conf/bblayers.conf](build/conf/bblayers.conf) and configure following layers:

```sh
BBLAYERS ?= " \
  /home/lucas/yocto-tmp/poky/meta \
  /home/lucas/yocto-tmp/poky/meta-poky \
  /home/lucas/yocto-tmp/poky/meta-yocto-bsp \
  /home/lucas/yocto/meta-openembedded/meta-oe \
  /home/lucas/yocto/meta-openembedded/meta-python \
  /home/lucas/yocto/meta-openembedded/meta-networking \
  /home/lucas/yocto/meta-st-stm32mp \
  /home/lucas/yocto/meta-bootlinlabs \
  /home/lucas/yocto/meta-rust \
  "
```

Configure [build/conf/local.conf](build/conf/local.conf)

Add/modify following lines:

```sh
# MACHINE ??= "qemux86-64"
MACHINE ??= "stm32mp1"
MACHINE ?= "bootlinlabs"

PACKAGE_CLASSES ?= "package_ipk"

# PACKAGECONFIG:append:pn-qemu-system-native = " sdl"

INHERIT += "rm_work"
```

## Build

Prebuild steps

    source .venv/bin/activate
    source poky/oe-init-build-env

Build `bootlinlabs` image for STM32MP1

    bitbake bootlinlabs-image-minimal

Build debug version

    bitbake bootlinlabs-image-minimal-dbg

Build SDK

    bitbake -c populate_sdk bootlinlabs-image-minimal

Build `core` image for qemuarm

    export MACHINE=qemuarm
    bitbake core-image-minimal

Run in qemu

    runqemu qemuarm nographic