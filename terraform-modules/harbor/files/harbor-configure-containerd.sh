#! /bin/bash

echo "Configure containerd to access harbor instance with self-signed cert ..."
sudo mkdir -p /etc/rancher/rke2
sudo cp /tmp/harbor.crt /etc/rancher/rke2/harbor.crt
sudo chown root:root /etc/rancher/rke2/harbor.crt
sudo chmod 600 /etc/rancher/rke2/harbor.crt
sudo cp /tmp/registries.yaml /etc/rancher/rke2/registries.yaml
sudo chown root:root /etc/rancher/rke2/registries.yaml

if sudo systemctl list-units --type=service | grep -q "rke2-server"; then
  echo "Restart rke2-server service ..."
  sudo systemctl restart rke2-server
fi

if sudo systemctl list-units --type=service | grep -q "rke2-agent"; then
  echo "Restart rke2-agent service ..."
  sudo systemctl restart rke2-agent
fi
