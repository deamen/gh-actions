#!/bin/bash

set -e

OS=$1

install_ubuntu_fedora() {
  sudo apt-get update
  sudo apt-get install -y buildah qemu-user-static
}

install_rhel() {
  sudo yum install -y buildah
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
