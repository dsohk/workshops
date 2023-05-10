#! /bin/bash

SUSEConnect --url=${scc_url} -e ${scc_reg_email} -r ${scc_reg_code}
zypper in -t pattern -y kvm_server kvm_tools
systemctl enable libvirtd
systemctl start libvirtd

# Enable GUI for virt-manager
# SUSEConnect -p sle-module-desktop-applications/15.4/x86_64
# zypper in -y -t pattern gnome_basic
# zypper in -y xrdp
