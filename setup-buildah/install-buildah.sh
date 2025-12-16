#!/bin/bash

set -e

OS=$1
QEMU_STATIC_VER="v7.2.0-1"
QEMU_VER="v10.1.3"

export QEMU_TARGET_LIST="aarch64"

install_ubuntu_fedora() {
  sudo apt-get update
  sudo apt-get install -y buildah qemu-user-static
  set_qemu_binfmt
}

install_rhel() {
  sudo yum install -y buildah
  install_qemu_static_rhel
  set_qemu_binfmt
}

install_qemu_static_rhel() {
  wget -c https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_STATIC_VER}/qemu-aarch64-static -P /tmp/
  chmod 0755 /tmp/qemu-aarch64-static
  sudo cp /tmp/qemu-aarch64-static /usr/bin/
}

set_qemu_binfmt() {
  wget -c https://raw.githubusercontent.com/qemu/qemu/refs/tags/${QEMU_VER}/scripts/qemu-binfmt-conf.sh -P /tmp/
  chmod a+x /tmp/qemu-binfmt-conf.sh
  # Patch qemu-binfmt-conf.sh so it picks up QEMU_TARGET_LIST
  patch /tmp/qemu-binfmt-conf.sh qemu-binfmt-conf-aarch.patch
  # --credential yes is needed for rootless buildah when running arm64 containers on amd64 host
  sudo -E  /tmp/qemu-binfmt-conf.sh --qemu-suffix "-static" --qemu-path /usr/bin --credential yes --persistent yes --preserve-argv0 yes

  # To reset the binfmt_misc entries:
  # sudo find /proc/sys/fs/binfmt_misc -type f -name 'qemu-*' -exec sh -c 'echo -1 > {}' \;
}

case "$OS" in
  ubuntu|fedora)
    install_ubuntu_fedora
    ;;
  rhel)
    install_rhel
    ;;
  *)
    echo "Unsupported operating system: $OS"
    exit 1
    ;;
esac
