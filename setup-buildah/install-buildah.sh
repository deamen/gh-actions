#!/bin/bash

set -e

OS=$1

install_ubuntu_fedora() {
  sudo apt-get update
  sudo apt-get install -y buildah qemu-user-static
}

install_rhel() {
  sudo yum install -y buildah
  install_qemu_static_rhel9
}

install_qemu_static_rhel9() {
  wget -c https://github.com/multiarch/qemu-user-static/releases/download/v7.2.0-1/qemu-aarch64-static -P /tmp/
  chmod a+x /tmp/qemu-aarch64-static
  sudo cp /tmp/qemu-aarch64-static /usr/bin/
  wget -c https://raw.githubusercontent.com/qemu/qemu/e75941331e4cdc05878119e08635ace437aae721/scripts/qemu-binfmt-conf.sh -P /tmp/
  chmod a+x /tmp/qemu-binfmt-conf.sh
  sudo /tmp/qemu-binfmt-conf.sh --qemu-suffix "-static" --qemu-path /usr/bin/
}

case "$OS" in
  ubuntu|fedora)
    install_ubuntu_fedora
    ;;
  rhel|rhel9)
    install_rhel
    ;;
  *)
    echo "Unsupported operating system: $OS"
    exit 1
    ;;
esac
